import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dish_models.dart';
import '../../data/models/ingredient.dart';
import 'ingredient_provider.dart';

/// Availability status for dishes
enum AvailabilityStatus {
  available,
  limited,
  unavailable,
}

/// Dish availability info
class DishAvailability {
  final String dishId;
  final AvailabilityStatus status;
  final String reason;
  final List<String> missingIngredients;
  final List<String> lowFreshnessIngredients;

  const DishAvailability({
    required this.dishId,
    required this.status,
    this.reason = '',
    this.missingIngredients = const [],
    this.lowFreshnessIngredients = const [],
  });

  bool get isAvailable => status == AvailabilityStatus.available;
  bool get isLimited => status == AvailabilityStatus.limited;
  bool get isUnavailable => status == AvailabilityStatus.unavailable;

  DishAvailability copyWith({
    String? dishId,
    AvailabilityStatus? status,
    String? reason,
    List<String>? missingIngredients,
    List<String>? lowFreshnessIngredients,
  }) {
    return DishAvailability(
      dishId: dishId ?? this.dishId,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      missingIngredients: missingIngredients ?? this.missingIngredients,
      lowFreshnessIngredients:
          lowFreshnessIngredients ?? this.lowFreshnessIngredients,
    );
  }
}

/// Minimum freshness threshold for ingredients (configurable)
const double minFreshnessThreshold = 40.0;

/// Check dish availability based on ingredient stock and freshness
DishAvailability checkDishAvailability(
  Dish dish,
  Map<String, Ingredient> ingredientStock,
) {
  final missing = <String>[];
  final lowFreshness = <String>[];
  bool anyLowFreshness = false;

  // Simple check: dish.ingredients contains ingredient names
  // In real implementation, you'd map ingredient names to IDs
  for (final ingredientName in dish.ingredients) {
    // Find ingredient by name (case-insensitive)
    final ingredient = ingredientStock.values.firstWhere(
      (ing) => ing.name.toLowerCase() == ingredientName.toLowerCase(),
      orElse: () => throw StateError('Ingredient not found'),
    );

    // Check if ingredient exists
    if (ingredientStock[ingredient.id] == null) {
      missing.add(ingredientName);
      continue;
    }

    final ing = ingredientStock[ingredient.id]!;

    // Check if expired or zero quantity
    if (ing.isExpired || ing.quantity <= 0) {
      missing.add(ingredientName);
      continue;
    }

    // Check freshness
    if (ing.freshnessScore < minFreshnessThreshold) {
      lowFreshness.add(ingredientName);
      anyLowFreshness = true;
    }
  }

  // Determine status
  if (missing.isNotEmpty) {
    return DishAvailability(
      dishId: dish.id,
      status: AvailabilityStatus.unavailable,
      reason: 'Missing or insufficient ingredients: ${missing.join(", ")}',
      missingIngredients: missing,
    );
  }

  if (anyLowFreshness) {
    return DishAvailability(
      dishId: dish.id,
      status: AvailabilityStatus.limited,
      reason: 'Some ingredients have low freshness',
      lowFreshnessIngredients: lowFreshness,
    );
  }

  return DishAvailability(
    dishId: dish.id,
    status: AvailabilityStatus.available,
    reason: 'All ingredients available and fresh',
  );
}

/// Dish availability provider for a specific chef
final dishAvailabilityProvider =
    FutureProvider.family<Map<String, DishAvailability>, String>(
  (ref, chefId) async {
    // Get all ingredients for chef
    final ingredientsAsync =
        await ref.watch(ingredientListProvider(chefId).future);

    // Convert to map for quick lookup
    final ingredientMap = {
      for (var ing in ingredientsAsync) ing.id: ing,
    };

    // Note: In real implementation, you'd fetch dishes from a dish provider
    // For now, return empty map
    // You would need to create a dish provider and integrate it here
    return <String, DishAvailability>{};
  },
);

/// Single dish availability provider
final singleDishAvailabilityProvider = FutureProvider.family
    .autoDispose<DishAvailability, ({String chefId, Dish dish})>(
  (ref, params) async {
    final ingredientsAsync =
        await ref.watch(ingredientListProvider(params.chefId).future);

    final ingredientMap = {
      for (var ing in ingredientsAsync) ing.id: ing,
    };

    return checkDishAvailability(params.dish, ingredientMap);
  },
);

/// Get availability badge text
String getAvailabilityBadgeText(AvailabilityStatus status) {
  switch (status) {
    case AvailabilityStatus.available:
      return 'Available';
    case AvailabilityStatus.limited:
      return 'Limited';
    case AvailabilityStatus.unavailable:
      return 'Unavailable';
  }
}

/// Get availability badge color
String getAvailabilityBadgeColor(AvailabilityStatus status) {
  switch (status) {
    case AvailabilityStatus.available:
      return 'green';
    case AvailabilityStatus.limited:
      return 'orange';
    case AvailabilityStatus.unavailable:
      return 'red';
  }
}
