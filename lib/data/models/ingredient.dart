import 'ingredient_history_item.dart';

/// Storage type for ingredients
enum StorageType {
  fridge('Fridge'),
  freezer('Freezer'),
  pantry('Pantry'),
  countertop('Countertop');

  final String label;
  const StorageType(this.label);
}

/// Ingredient category
enum IngredientCategory {
  vegetables('Vegetables'),
  fruits('Fruits'),
  meat('Meat'),
  poultry('Poultry'),
  seafood('Seafood'),
  dairy('Dairy'),
  grains('Grains'),
  spices('Spices'),
  herbs('Herbs'),
  condiments('Condiments'),
  oils('Oils'),
  other('Other');

  final String label;
  const IngredientCategory(this.label);
}

/// Ingredient model with stock tracking and freshness calculation
class Ingredient {
  final String id;
  final String chefId;
  final String name;
  final IngredientCategory category;
  final String unit; // gram, ml, piece, kg, etc.
  final double quantity; // current quantity
  final double threshold; // low stock threshold
  final double costPerUnit;
  final DateTime addedAt; // when first added or last restocked
  final DateTime? expiryDate; // null for non-perishable
  final double freshnessScore; // 0..100
  final StorageType storageType;
  final DateTime lastChecked; // when freshness last computed
  final DateTime updatedAt;
  final List<IngredientHistoryItem> history;

  const Ingredient({
    required this.id,
    required this.chefId,
    required this.name,
    required this.category,
    required this.unit,
    required this.quantity,
    required this.threshold,
    required this.costPerUnit,
    required this.addedAt,
    this.expiryDate,
    this.freshnessScore = 100.0,
    required this.storageType,
    required this.lastChecked,
    required this.updatedAt,
    this.history = const [],
  });

  /// Check if ingredient is expired
  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }

  /// Check if ingredient is low stock
  bool get isLowStock => quantity <= threshold;

  /// Check if ingredient is expiring soon (within 2 days)
  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysUntilExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 2 && daysUntilExpiry >= 0;
  }

  /// Get days until expiry (negative if expired)
  int? get daysUntilExpiry {
    if (expiryDate == null) return null;
    return expiryDate!.difference(DateTime.now()).inDays;
  }

  /// Calculate freshness score based on time since added and expiry
  static double calculateFreshness(DateTime addedAt, DateTime? expiryDate) {
    if (expiryDate == null || expiryDate.isBefore(addedAt)) {
      return 100.0; // Non-perishable or invalid expiry date
    }

    final total = expiryDate.difference(addedAt).inDays.clamp(1, 3650);
    final elapsed = DateTime.now().difference(addedAt).inDays.clamp(0, total);
    final score = ((1 - (elapsed / total)) * 100).clamp(0, 100);
    return double.parse(score.toStringAsFixed(1));
  }

  /// Get freshness color for UI
  String get freshnessColor {
    if (freshnessScore >= 70) return 'green';
    if (freshnessScore >= 40) return 'orange';
    return 'red';
  }

  /// Get freshness label for UI
  String get freshnessLabel {
    if (freshnessScore >= 70) return 'Fresh';
    if (freshnessScore >= 40) return 'Fair';
    return 'Poor';
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] as String,
      chefId: json['chef_id'] as String,
      name: json['name'] as String,
      category: IngredientCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => IngredientCategory.other,
      ),
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toDouble().clamp(0, double.infinity),
      threshold: (json['threshold'] as num).toDouble(),
      costPerUnit: (json['cost_per_unit'] as num).toDouble(),
      addedAt: DateTime.parse(json['added_at'] as String),
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      freshnessScore: (json['freshness_score'] as num?)?.toDouble() ?? 100.0,
      storageType: StorageType.values.firstWhere(
        (e) => e.name == json['storage_type'],
        orElse: () => StorageType.pantry,
      ),
      lastChecked: DateTime.parse(json['last_checked'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      history: (json['history'] as List<dynamic>?)
              ?.map((e) =>
                  IngredientHistoryItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chef_id': chefId,
      'name': name,
      'category': category.name,
      'unit': unit,
      'quantity': quantity,
      'threshold': threshold,
      'cost_per_unit': costPerUnit,
      'added_at': addedAt.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'freshness_score': freshnessScore,
      'storage_type': storageType.name,
      'last_checked': lastChecked.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'history': history.map((e) => e.toJson()).toList(),
    };
  }

  Ingredient copyWith({
    String? id,
    String? chefId,
    String? name,
    IngredientCategory? category,
    String? unit,
    double? quantity,
    double? threshold,
    double? costPerUnit,
    DateTime? addedAt,
    DateTime? expiryDate,
    double? freshnessScore,
    StorageType? storageType,
    DateTime? lastChecked,
    DateTime? updatedAt,
    List<IngredientHistoryItem>? history,
  }) {
    return Ingredient(
      id: id ?? this.id,
      chefId: chefId ?? this.chefId,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      threshold: threshold ?? this.threshold,
      costPerUnit: costPerUnit ?? this.costPerUnit,
      addedAt: addedAt ?? this.addedAt,
      expiryDate: expiryDate ?? this.expiryDate,
      freshnessScore: freshnessScore ?? this.freshnessScore,
      storageType: storageType ?? this.storageType,
      lastChecked: lastChecked ?? this.lastChecked,
      updatedAt: updatedAt ?? this.updatedAt,
      history: history ?? this.history,
    );
  }

  /// Add a history item
  Ingredient addHistory(IngredientHistoryItem item) {
    return copyWith(
      history: [...history, item],
      updatedAt: DateTime.now(),
    );
  }

  /// Recalculate freshness score
  Ingredient recalculateFreshness() {
    final newScore = calculateFreshness(addedAt, expiryDate);
    return copyWith(
      freshnessScore: newScore,
      lastChecked: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Use ingredient (reduce quantity)
  Ingredient use(double amount, {String note = ''}) {
    final newQuantity =
        (quantity - amount).clamp(0.0, double.infinity).toDouble();
    return copyWith(
      quantity: newQuantity,
      updatedAt: DateTime.now(),
    ).addHistory(
      IngredientHistoryItem(
        date: DateTime.now(),
        action: 'used',
        quantity: amount,
        note: note,
      ),
    );
  }

  /// Restock ingredient
  Ingredient restock(
    double amount, {
    DateTime? newExpiryDate,
    double? newCostPerUnit,
    String note = '',
  }) {
    return copyWith(
      quantity: quantity + amount,
      addedAt: DateTime.now(), // Reset added date for freshness calculation
      expiryDate: newExpiryDate ?? expiryDate,
      costPerUnit: newCostPerUnit ?? costPerUnit,
      updatedAt: DateTime.now(),
    ).recalculateFreshness().addHistory(
          IngredientHistoryItem(
            date: DateTime.now(),
            action: 'restocked',
            quantity: amount,
            note: note,
          ),
        );
  }

  /// Discard ingredient (expired or damaged)
  Ingredient discard(String reason) {
    return copyWith(
      quantity: 0,
      updatedAt: DateTime.now(),
    ).addHistory(
      IngredientHistoryItem(
        date: DateTime.now(),
        action: 'discarded',
        quantity: quantity,
        note: reason,
      ),
    );
  }

  @override
  String toString() {
    return 'Ingredient(id: $id, name: $name, quantity: $quantity $unit, freshness: $freshnessScore%)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Ingredient && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
