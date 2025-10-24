import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/ingredient.dart';
import '../../data/repositories/ingredient_repository_impl.dart';
import '../services/ingredient_service.dart';

/// Repository provider
final ingredientRepositoryProvider = Provider((ref) {
  return IngredientRepositoryImpl();
});

/// Service provider
final ingredientServiceProvider = Provider((ref) {
  final repository = ref.watch(ingredientRepositoryProvider);
  return IngredientService(repository);
});

/// Ingredient list provider for a specific chef
final ingredientListProvider =
    FutureProvider.family<List<Ingredient>, String>((ref, chefId) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.fetchByChef(chefId);
});

/// Single ingredient provider
final ingredientByIdProvider =
    FutureProvider.family<Ingredient?, String>((ref, id) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.fetchById(id);
});

/// Expiring soon ingredients provider
final expiringSoonIngredientsProvider =
    FutureProvider.family<List<Ingredient>, String>((ref, chefId) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.getExpiringSoon(chefId);
});

/// Low stock ingredients provider
final lowStockIngredientsProvider =
    FutureProvider.family<List<Ingredient>, String>((ref, chefId) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.getLowStock(chefId);
});

/// Expired ingredients provider
final expiredIngredientsProvider =
    FutureProvider.family<List<Ingredient>, String>((ref, chefId) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.getExpired(chefId);
});

/// Alert counts provider
final ingredientAlertCountsProvider =
    FutureProvider.family<Map<String, int>, String>((ref, chefId) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.getAlertCounts(chefId);
});

/// Inventory value provider
final inventoryValueProvider =
    FutureProvider.family<double, String>((ref, chefId) async {
  final service = ref.watch(ingredientServiceProvider);
  return await service.getInventoryValue(chefId);
});

/// Ingredient notifier for CRUD operations
class IngredientNotifier extends StateNotifier<AsyncValue<List<Ingredient>>> {
  final IngredientService _service;
  final String _chefId;

  IngredientNotifier(this._service, this._chefId)
      : super(const AsyncValue.loading()) {
    _loadIngredients();
  }

  Future<void> _loadIngredients() async {
    state = const AsyncValue.loading();
    try {
      final ingredients = await _service.fetchByChef(_chefId);
      state = AsyncValue.data(ingredients);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Refresh the ingredient list
  Future<void> refresh() async {
    await _loadIngredients();
  }

  /// Add a new ingredient
  Future<void> add(Ingredient ingredient) async {
    try {
      final newIngredient = await _service.create(ingredient);
      state.whenData((ingredients) {
        state = AsyncValue.data([...ingredients, newIngredient]);
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update an ingredient
  Future<void> update(Ingredient ingredient) async {
    try {
      final updated = await _service.update(ingredient);
      state.whenData((ingredients) {
        final index = ingredients.indexWhere((i) => i.id == updated.id);
        if (index != -1) {
          final newList = [...ingredients];
          newList[index] = updated;
          state = AsyncValue.data(newList);
        }
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete an ingredient
  Future<void> delete(String id) async {
    try {
      await _service.delete(id);
      state.whenData((ingredients) {
        state = AsyncValue.data(ingredients.where((i) => i.id != id).toList());
      });
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Restock an ingredient
  Future<void> restock(
    String id,
    double quantity, {
    DateTime? expiryDate,
    double? costPerUnit,
    String note = '',
  }) async {
    try {
      final updated = await _service.restock(
        id,
        quantity,
        expiryDate: expiryDate,
        costPerUnit: costPerUnit,
        note: note,
      );
      await update(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Use ingredient
  Future<void> use(String id, double amount, {String note = ''}) async {
    try {
      final updated = await _service.useIngredient(id, amount, note: note);
      await update(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Discard ingredient
  Future<void> discard(String id, String reason) async {
    try {
      final updated = await _service.discard(id, reason);
      await update(updated);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Search ingredients
  Future<void> search(String query) async {
    state = const AsyncValue.loading();
    try {
      final results = await _service.search(_chefId, query);
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Filter by category
  Future<void> filterByCategory(IngredientCategory category) async {
    state = const AsyncValue.loading();
    try {
      final results = await _service.filterByCategory(_chefId, category);
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Filter by storage type
  Future<void> filterByStorageType(StorageType storageType) async {
    state = const AsyncValue.loading();
    try {
      final results = await _service.filterByStorageType(_chefId, storageType);
      state = AsyncValue.data(results);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

/// Ingredient notifier provider
final ingredientNotifierProvider = StateNotifierProvider.family<
    IngredientNotifier, AsyncValue<List<Ingredient>>, String>(
  (ref, chefId) {
    final service = ref.watch(ingredientServiceProvider);
    return IngredientNotifier(service, chefId);
  },
);
