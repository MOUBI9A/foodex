import '../../data/models/ingredient.dart';
import '../../data/repositories/admin/ingredient_repository.dart';

/// Business logic service for ingredient management
class IngredientService {
  final IngredientRepository _repository;

  IngredientService(this._repository);

  /// Fetch all ingredients for a chef
  Future<List<Ingredient>> fetchByChef(String chefId) async {
    return await _repository.fetchByChef(chefId);
  }

  /// Fetch a single ingredient
  Future<Ingredient?> fetchById(String id) async {
    return await _repository.fetchById(id);
  }

  /// Create a new ingredient
  Future<Ingredient> create(Ingredient ingredient) async {
    // Calculate initial freshness
    final ingredientWithFreshness = ingredient.recalculateFreshness();
    return await _repository.create(ingredientWithFreshness);
  }

  /// Update ingredient
  Future<Ingredient> update(Ingredient ingredient) async {
    return await _repository.update(ingredient);
  }

  /// Delete ingredient
  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  /// Restock ingredient
  Future<Ingredient> restock(
    String id,
    double quantity, {
    DateTime? expiryDate,
    double? costPerUnit,
    String note = '',
  }) async {
    return await _repository.restock(
      id,
      quantity,
      expiryDate: expiryDate,
      costPerUnit: costPerUnit,
      note: note,
    );
  }

  /// Use ingredient (reduce quantity)
  Future<Ingredient> useIngredient(
    String id,
    double amount, {
    String note = '',
  }) async {
    return await _repository.use(id, amount, note: note);
  }

  /// Discard ingredient
  Future<Ingredient> discard(String id, String reason) async {
    return await _repository.discard(id, reason);
  }

  /// Recalculate freshness for all chef's ingredients
  Future<void> recalculateAllFreshness() async {
    await _repository.recalculateAllFreshness();
  }

  /// Get ingredients expiring soon
  Future<List<Ingredient>> getExpiringSoon(String chefId,
      {int days = 2}) async {
    return await _repository.getExpiringSoon(chefId, days: days);
  }

  /// Get low stock ingredients
  Future<List<Ingredient>> getLowStock(String chefId) async {
    return await _repository.getLowStock(chefId);
  }

  /// Get expired ingredients
  Future<List<Ingredient>> getExpired(String chefId) async {
    return await _repository.getExpired(chefId);
  }

  /// Search ingredients
  Future<List<Ingredient>> search(String chefId, String query) async {
    if (query.trim().isEmpty) {
      return await fetchByChef(chefId);
    }
    return await _repository.search(chefId, query);
  }

  /// Filter by category
  Future<List<Ingredient>> filterByCategory(
    String chefId,
    IngredientCategory category,
  ) async {
    return await _repository.filterByCategory(chefId, category);
  }

  /// Filter by storage type
  Future<List<Ingredient>> filterByStorageType(
    String chefId,
    StorageType storageType,
  ) async {
    return await _repository.filterByStorageType(chefId, storageType);
  }

  /// Get alert counts for a chef
  Future<Map<String, int>> getAlertCounts(String chefId) async {
    final ingredients = await fetchByChef(chefId);

    int lowStockCount = 0;
    int expiringSoonCount = 0;
    int expiredCount = 0;

    for (final ingredient in ingredients) {
      if (ingredient.isExpired) {
        expiredCount++;
      } else if (ingredient.isExpiringSoon) {
        expiringSoonCount++;
      }
      if (ingredient.isLowStock) {
        lowStockCount++;
      }
    }

    return {
      'lowStock': lowStockCount,
      'expiringSoon': expiringSoonCount,
      'expired': expiredCount,
      'total': ingredients.length,
    };
  }

  /// Get inventory value for a chef
  Future<double> getInventoryValue(String chefId) async {
    final ingredients = await fetchByChef(chefId);
    return ingredients.fold<double>(
      0.0,
      (double sum, ingredient) =>
          sum + (ingredient.quantity * ingredient.costPerUnit),
    );
  }

  /// Use ingredients for a dish order
  Future<Map<String, bool>> useIngredientsForDish(
    Map<String, double> ingredientRequirements,
  ) async {
    final results = <String, bool>{};

    for (final entry in ingredientRequirements.entries) {
      try {
        await useIngredient(
          entry.key,
          entry.value,
          note: 'Used for dish order',
        );
        results[entry.key] = true;
      } catch (e) {
        results[entry.key] = false;
      }
    }

    return results;
  }

  /// Check if ingredient has sufficient quantity
  Future<bool> hasSufficientQuantity(String id, double required) async {
    final ingredient = await fetchById(id);
    if (ingredient == null) return false;
    return ingredient.quantity >= required && !ingredient.isExpired;
  }
}
