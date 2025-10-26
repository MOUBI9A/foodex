// IngredientRepositoryImpl using Hive and seed JSON.
import 'package:hive/hive.dart';
import '../models/ingredient.dart';
import '../models/ingredient_history_item.dart';
import '../repositories/ingredient_repository.dart';
import '../../core/services/local_db_service.dart';
import 'mock_data_provider.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  static const String boxName = 'ingredients_box';

  Future<Box<Ingredient>> _box() async {
    await LocalDbService.init();
    return LocalDbService.openBox<Ingredient>(boxName);
  }

  @override
  Future<List<Ingredient>> getAll() async {
    final box = await _box();
    return box.values.toList(growable: false);
  }

  @override
  Future<void> add(Ingredient ingredient) async {
    final box = await _box();
    await box.put(ingredient.id, ingredient);
  }

  @override
  Future<void> update(Ingredient ingredient) async {
    final box = await _box();
    await box.put(ingredient.id, ingredient);
  }

  @override
  Future<void> restock(String id, double qty, {DateTime? expiry}) async {
    final box = await _box();
    final ing = box.get(id);
    if (ing == null) return;
    ing.quantity += qty;
    if (expiry != null) {
      ing.expiryDate = expiry;
    }
    ing.history = List.of(ing.history)
      ..add(IngredientHistoryItem(action: 'restocked', qty: qty, date: DateTime.now()));
    ing.recalculateFreshness();
    await box.put(ing.id, ing);
  }

  @override
  Future<void> discard(String id, {double? qty}) async {
    final box = await _box();
    final ing = box.get(id);
    if (ing == null) return;
    if (qty == null || qty >= ing.quantity) {
      // discard all
      await box.delete(id);
      return;
    }
    ing.quantity -= qty;
    ing.history = List.of(ing.history)
      ..add(IngredientHistoryItem(action: 'discarded', qty: qty, date: DateTime.now()));
    await box.put(ing.id, ing);
  }

  @override
  Future<void> seedIfEmpty() async {
    final box = await _box();
    if (box.isNotEmpty) return;
    final data = await MockDataProvider.load('ingredients_seed.json');
    final list = (data['ingredients'] as List)
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();
    for (final ing in list) {
      await box.put(ing.id, ing);
    }
  }
}
