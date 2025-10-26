import '../../data/models/customer_preference.dart';
import '../../data/models/dish.dart';
import '../../data/models/ingredient.dart';

class DishSafetyResult {
  final bool isBlocked;
  final bool isDiscouraged;
  final List<String> warnings;

  const DishSafetyResult({
    required this.isBlocked,
    required this.isDiscouraged,
    required this.warnings,
  });
}

class DishSafetyService {
  DishSafetyResult evaluate({
    required Dish dish,
    required CustomerPreference preference,
    required Map<String, Ingredient> ingredientLookup,
  }) {
    bool blocked = false;
    bool discouraged = false;
    final warnings = <String>[];

    for (final usage in dish.ingredients) {
      final ingredient = ingredientLookup[usage.ingredientId];
      final ingName = ingredient?.name ?? usage.ingredientId;
      final normalized = ingName.toLowerCase();
      final idToken = usage.ingredientId.toLowerCase();

      if (_matchesAny(normalized, preference.allergies, alt: idToken)) {
        blocked = true;
        warnings.add('Contient $ingName (allergène)');
      }
      if (_matchesAny(normalized, preference.dislikedIngredients, alt: idToken)) {
        discouraged = true;
        warnings.add('$ingName fait partie de tes ingrédients désapprouvés');
      }

      final dietWarning = _dietViolationMessage(preference.dietFlags, normalized);
      if (dietWarning != null) {
        blocked = true;
        warnings.add(dietWarning);
      }
    }

    return DishSafetyResult(
      isBlocked: blocked,
      isDiscouraged: !blocked && discouraged,
      warnings: warnings,
    );
  }

  bool _matchesAny(String ingredientName, List<String> targets, {String? alt}) {
    if (targets.isEmpty) return false;
    final loweredTargets = targets.map((t) => t.toLowerCase()).toList();
    return loweredTargets.any(
      (entry) => ingredientName.contains(entry) || (alt != null && alt.contains(entry)),
    );
  }

  String? _dietViolationMessage(List<String> flags, String ingredientName) {
    if (flags.isEmpty) return null;
    final normalized = ingredientName.toLowerCase();

    bool containsAny(Iterable<String> needles) =>
        needles.any((needle) => normalized.contains(needle));

    for (final flag in flags) {
      switch (flag) {
        case 'no_pork':
        case 'halal':
          if (containsAny(const ['pork', 'porc', 'bacon', 'ham', 'lardon'])) {
            return 'Contient du porc, incompatible avec tes préférences.';
          }
          break;
        case 'no_gluten':
          if (containsAny(const ['wheat', 'ble', 'farine', 'bread', 'pasta'])) {
            return 'Contient du gluten.';
          }
          break;
        case 'vegetarian':
          if (containsAny(const ['chicken', 'beef', 'lamb', 'fish', 'shrimp'])) {
            return 'Plat non végétarien.';
          }
          break;
        case 'vegan':
          if (containsAny(const ['egg', 'lait', 'milk', 'butter', 'cheese', 'yogurt'])) {
            return 'Plat non vegan.';
          }
          break;
        default:
          break;
      }
    }
    return null;
  }
}
