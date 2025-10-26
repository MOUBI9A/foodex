// IngredientRepository interface defining required operations.
import '../models/ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> getAll();
  Future<void> add(Ingredient ingredient);
  Future<void> update(Ingredient ingredient);
  Future<void> restock(String id, double qty, {DateTime? expiry});
  Future<void> discard(String id, {double? qty});
  Future<void> seedIfEmpty();
}
