import '../../models/ingredient.dart';

/// Repository interface for ingredient CRUD operations
abstract class IngredientRepository {
  /// Fetch all ingredients for a chef
  Future<List<Ingredient>> fetchByChef(String chefId);

  /// Fetch a single ingredient by ID
  Future<Ingredient?> fetchById(String id);

  /// Create a new ingredient
  Future<Ingredient> create(Ingredient ingredient);

  /// Update an existing ingredient
  Future<Ingredient> update(Ingredient ingredient);

  /// Delete an ingredient
  Future<void> delete(String id);

  /// Restock an ingredient
  Future<Ingredient> restock(
    String id,
    double quantity, {
    DateTime? expiryDate,
    double? costPerUnit,
    String note = '',
  });

  /// Use ingredient (reduce quantity)
  Future<Ingredient> use(
    String id,
    double amount, {
    String note = '',
  });

  /// Discard ingredient
  Future<Ingredient> discard(String id, String reason);

  /// Recalculate freshness for all ingredients
  Future<void> recalculateAllFreshness();

  /// Get last recalculation timestamp
  DateTime? get lastRecalculatedAt;

  /// Get ingredients expiring soon (within specified days)
  Future<List<Ingredient>> getExpiringSoon(String chefId, {int days = 2});

  /// Get low stock ingredients
  Future<List<Ingredient>> getLowStock(String chefId);

  /// Get expired ingredients
  Future<List<Ingredient>> getExpired(String chefId);

  /// Search ingredients by name
  Future<List<Ingredient>> search(String chefId, String query);

  /// Filter ingredients by category
  Future<List<Ingredient>> filterByCategory(
    String chefId,
    IngredientCategory category,
  );

  /// Filter ingredients by storage type
  Future<List<Ingredient>> filterByStorageType(
    String chefId,
    StorageType storageType,
  );
}
