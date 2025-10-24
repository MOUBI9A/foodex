import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/ingredient.dart';
import '../models/ingredient_history_item.dart';
import 'admin/ingredient_repository.dart';

/// Mock/local implementation of IngredientRepository
/// Stores data in a local JSON file for development
class IngredientRepositoryImpl implements IngredientRepository {
  static const String _fileName = 'ingredients.json';
  List<Ingredient> _cachedIngredients = [];
  DateTime? _lastRecalculatedAt;
  bool _isInitialized = false;

  @override
  DateTime? get lastRecalculatedAt => _lastRecalculatedAt;

  /// Initialize repository and load data from file
  Future<void> _initialize() async {
    if (_isInitialized) return;

    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final jsonData = jsonDecode(contents) as Map<String, dynamic>;
        _cachedIngredients = (jsonData['ingredients'] as List<dynamic>)
            .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
            .toList();
        _lastRecalculatedAt = jsonData['last_recalculated_at'] != null
            ? DateTime.parse(jsonData['last_recalculated_at'] as String)
            : null;
      } else {
        // Initialize with empty data
        await _saveToFile();
      }
      _isInitialized = true;
    } catch (e) {
      print('Error initializing ingredient repository: $e');
      _cachedIngredients = [];
      _isInitialized = true;
    }
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _saveToFile() async {
    try {
      final file = await _getLocalFile();
      final jsonData = {
        'ingredients': _cachedIngredients.map((e) => e.toJson()).toList(),
        'last_recalculated_at': _lastRecalculatedAt?.toIso8601String(),
      };
      await file.writeAsString(jsonEncode(jsonData));
    } catch (e) {
      print('Error saving ingredients to file: $e');
    }
  }

  @override
  Future<List<Ingredient>> fetchByChef(String chefId) async {
    await _initialize();
    return _cachedIngredients
        .where((ingredient) => ingredient.chefId == chefId)
        .toList();
  }

  @override
  Future<Ingredient?> fetchById(String id) async {
    await _initialize();
    try {
      return _cachedIngredients.firstWhere((ingredient) => ingredient.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Ingredient> create(Ingredient ingredient) async {
    await _initialize();

    // Add initial history item
    final ingredientWithHistory = ingredient.addHistory(
      IngredientHistoryItem(
        date: DateTime.now(),
        action: 'added',
        quantity: ingredient.quantity,
        note: 'Initial stock',
      ),
    );

    _cachedIngredients.add(ingredientWithHistory);
    await _saveToFile();
    return ingredientWithHistory;
  }

  @override
  Future<Ingredient> update(Ingredient ingredient) async {
    await _initialize();
    final index =
        _cachedIngredients.indexWhere((item) => item.id == ingredient.id);
    if (index == -1) {
      throw Exception('Ingredient not found: ${ingredient.id}');
    }
    _cachedIngredients[index] = ingredient.copyWith(updatedAt: DateTime.now());
    await _saveToFile();
    return _cachedIngredients[index];
  }

  @override
  Future<void> delete(String id) async {
    await _initialize();
    _cachedIngredients.removeWhere((ingredient) => ingredient.id == id);
    await _saveToFile();
  }

  @override
  Future<Ingredient> restock(
    String id,
    double quantity, {
    DateTime? expiryDate,
    double? costPerUnit,
    String note = '',
  }) async {
    await _initialize();
    final ingredient = await fetchById(id);
    if (ingredient == null) {
      throw Exception('Ingredient not found: $id');
    }

    final updatedIngredient = ingredient.restock(
      quantity,
      newExpiryDate: expiryDate,
      newCostPerUnit: costPerUnit,
      note: note.isEmpty ? 'Restocked $quantity ${ingredient.unit}' : note,
    );

    return await update(updatedIngredient);
  }

  @override
  Future<Ingredient> use(
    String id,
    double amount, {
    String note = '',
  }) async {
    await _initialize();
    final ingredient = await fetchById(id);
    if (ingredient == null) {
      throw Exception('Ingredient not found: $id');
    }

    final updatedIngredient = ingredient.use(
      amount,
      note: note.isEmpty ? 'Used $amount ${ingredient.unit}' : note,
    );

    return await update(updatedIngredient);
  }

  @override
  Future<Ingredient> discard(String id, String reason) async {
    await _initialize();
    final ingredient = await fetchById(id);
    if (ingredient == null) {
      throw Exception('Ingredient not found: $id');
    }

    final updatedIngredient = ingredient.discard(reason);
    return await update(updatedIngredient);
  }

  @override
  Future<void> recalculateAllFreshness() async {
    await _initialize();
    _cachedIngredients = _cachedIngredients
        .map((ingredient) => ingredient.recalculateFreshness())
        .toList();
    _lastRecalculatedAt = DateTime.now();
    await _saveToFile();
  }

  @override
  Future<List<Ingredient>> getExpiringSoon(String chefId,
      {int days = 2}) async {
    await _initialize();
    return _cachedIngredients
        .where((ingredient) =>
            ingredient.chefId == chefId &&
            ingredient.expiryDate != null &&
            !ingredient.isExpired &&
            ingredient.expiryDate!.difference(DateTime.now()).inDays <= days)
        .toList();
  }

  @override
  Future<List<Ingredient>> getLowStock(String chefId) async {
    await _initialize();
    return _cachedIngredients
        .where((ingredient) =>
            ingredient.chefId == chefId && ingredient.isLowStock)
        .toList();
  }

  @override
  Future<List<Ingredient>> getExpired(String chefId) async {
    await _initialize();
    return _cachedIngredients
        .where(
            (ingredient) => ingredient.chefId == chefId && ingredient.isExpired)
        .toList();
  }

  @override
  Future<List<Ingredient>> search(String chefId, String query) async {
    await _initialize();
    final lowerQuery = query.toLowerCase();
    return _cachedIngredients
        .where((ingredient) =>
            ingredient.chefId == chefId &&
            ingredient.name.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Future<List<Ingredient>> filterByCategory(
    String chefId,
    IngredientCategory category,
  ) async {
    await _initialize();
    return _cachedIngredients
        .where((ingredient) =>
            ingredient.chefId == chefId && ingredient.category == category)
        .toList();
  }

  @override
  Future<List<Ingredient>> filterByStorageType(
    String chefId,
    StorageType storageType,
  ) async {
    await _initialize();
    return _cachedIngredients
        .where((ingredient) =>
            ingredient.chefId == chefId &&
            ingredient.storageType == storageType)
        .toList();
  }

  /// Seed initial data for testing
  Future<void> seedData(List<Ingredient> ingredients) async {
    await _initialize();
    _cachedIngredients = ingredients;
    await _saveToFile();
  }

  /// Clear all data
  Future<void> clearData() async {
    await _initialize();
    _cachedIngredients = [];
    _lastRecalculatedAt = null;
    await _saveToFile();
  }
}
