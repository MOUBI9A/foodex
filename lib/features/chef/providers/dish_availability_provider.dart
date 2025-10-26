import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/dish.dart';
import '../../../data/models/ingredient.dart';
import '../../../core/providers/dish_providers.dart';
import 'ingredient_provider.dart';

class DishAvailabilityStatus {
  static const available = 'available';
  static const limited = 'limited';
  static const unavailable = 'unavailable';
}

class DishAvailability {
  final String dishId;
  final String status;
  final String reason;

  const DishAvailability({
    required this.dishId,
    required this.status,
    required this.reason,
  });

  bool get isAvailable => status == DishAvailabilityStatus.available;
  bool get isLimited => status == DishAvailabilityStatus.limited;
}

const _freshnessThreshold = 40.0;

final dishAvailabilityProvider = Provider<Map<String, DishAvailability>>((ref) {
  final dishesAsync = ref.watch(dishListProvider);
  final ingredientsAsync = ref.watch(ingredientListProvider);

  final dishes = dishesAsync.maybeWhen(data: (data) => data, orElse: () => const <Dish>[]);
  final ingredients = ingredientsAsync.maybeWhen(
    data: (data) => data,
    orElse: () => const <Ingredient>[],
  );

  if (dishes.isEmpty || ingredients.isEmpty) {
    return const <String, DishAvailability>{};
  }

  final ingredientMap = {for (final ingredient in ingredients) ingredient.id: ingredient};
  final result = <String, DishAvailability>{};

  for (final dish in dishes) {
    result[dish.id] = _evaluateDish(dish, ingredientMap);
  }
  return result;
});

DishAvailability _evaluateDish(Dish dish, Map<String, Ingredient> ingredients) {
  var status = DishAvailabilityStatus.available;
  var reason = 'Prêt à être servi';
  double? limitingPortion;
  final missing = <String>[];
  final expired = <String>[];
  final lowFreshness = <String>[];

  for (final usage in dish.ingredients) {
    final ingredient = ingredients[usage.ingredientId];
    if (ingredient == null) {
      missing.add(usage.ingredientId);
      status = DishAvailabilityStatus.unavailable;
      reason = 'Ingrédients manquants';
      continue;
    }
    if (ingredient.isExpired) {
      expired.add(ingredient.name);
      status = DishAvailabilityStatus.unavailable;
      reason = 'Ingrédient expiré: ${ingredient.name}';
      continue;
    }
    if (ingredient.freshness < _freshnessThreshold) {
      lowFreshness.add(ingredient.name);
      status = DishAvailabilityStatus.unavailable;
      reason = 'Fraîcheur insuffisante: ${ingredient.name}';
      continue;
    }
    if (usage.qty > 0) {
      final portions = ingredient.quantity / usage.qty;
      limitingPortion = limitingPortion == null ? portions : portions.clamp(0, limitingPortion);
    }
  }

  if (status == DishAvailabilityStatus.available && (limitingPortion ?? 0) < 3) {
    status = DishAvailabilityStatus.limited;
    final portionText = limitingPortion == null ? 'quelques' : limitingPortion.floor().toString();
    reason = 'Stock faible: $portionText portions restantes';
  }

  if (status == DishAvailabilityStatus.unavailable) {
    final issues = <String>[];
    if (missing.isNotEmpty) issues.add('Manque ${missing.join(', ')}');
    if (expired.isNotEmpty) issues.add('Expiré: ${expired.join(', ')}');
    if (lowFreshness.isNotEmpty) issues.add('Fraîcheur critique: ${lowFreshness.join(', ')}');
    reason = issues.isEmpty ? reason : issues.join(' · ');
  }

  return DishAvailability(dishId: dish.id, status: status, reason: reason);
}
