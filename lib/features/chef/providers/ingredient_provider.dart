// IngredientListProvider and IngredientNotifier for CRUD and freshness logic.
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ingredient.dart';
import '../../../data/repositories/ingredient_repository.dart';
import '../../../data/repositories/ingredient_repository_impl.dart';

final ingredientRepositoryProvider = Provider<IngredientRepository>((ref) {
  return IngredientRepositoryImpl();
});

final ingredientListProvider = AsyncNotifierProvider<IngredientListNotifier, List<Ingredient>>(IngredientListNotifier.new);

class IngredientListNotifier extends AsyncNotifier<List<Ingredient>> {
  IngredientRepository get repo => ref.read(ingredientRepositoryProvider);

  @override
  Future<List<Ingredient>> build() async {
    await repo.seedIfEmpty();
    return repo.getAll();
  }

  Future<void> add(Ingredient ing) async {
    await repo.add(ing);
    state = AsyncValue.data(await repo.getAll());
  }

  Future<void> updateIngredient(Ingredient ing) async {
    await repo.update(ing);
    state = AsyncValue.data(await repo.getAll());
  }

  Future<void> restock(String id, double qty, {DateTime? expiry}) async {
    await repo.restock(id, qty, expiry: expiry);
    state = AsyncValue.data(await repo.getAll());
  }

  Future<void> discard(String id, {double? qty}) async {
    await repo.discard(id, qty: qty);
    state = AsyncValue.data(await repo.getAll());
  }

  Future<void> reload() async {
    state = AsyncValue.data(await repo.getAll());
  }

  Future<void> consumeIngredients(Map<String, double> usage) async {
    if (usage.isEmpty) return;
    final ingredients = await repo.getAll();
    for (final entry in usage.entries) {
      final ingIndex = ingredients.indexWhere((ingredient) => ingredient.id == entry.key);
      if (ingIndex == -1) continue;
      final ing = ingredients[ingIndex];
      ing.quantity = max(0, ing.quantity - entry.value);
      ing.recalculateFreshness();
      await repo.update(ing);
    }
    state = AsyncValue.data(await repo.getAll());
  }
}
