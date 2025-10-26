// Ingredient model with Hive adapter and JSON support.
import 'package:hive/hive.dart';
import 'ingredient_history_item.dart';

part 'ingredient.g.dart';

@HiveType(typeId: 1)
class Ingredient {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  double quantity;
  @HiveField(3)
  String unit;
  @HiveField(4)
  DateTime? expiryDate;
  @HiveField(5)
  int threshold; // low stock threshold
  @HiveField(6)
  double freshness; // 0..100
  @HiveField(7)
  String category;
  @HiveField(8)
  String storageType; // fridge, freezer, dry
  @HiveField(9)
  double cost; // optional cost per unit
  @HiveField(10)
  List<IngredientHistoryItem> history;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    this.expiryDate,
    this.threshold = 1,
    this.freshness = 100,
    this.category = 'General',
    this.storageType = 'dry',
    this.cost = 0,
    List<IngredientHistoryItem>? history,
  }) : history = history ?? const [];

  bool get isExpired => expiryDate != null && expiryDate!.isBefore(DateTime.now());
  bool get isLowStock => quantity <= threshold;

  void recalculateFreshness() {
    if (expiryDate == null) {
      freshness = 100;
      return;
    }
    final daysLeft = expiryDate!.difference(DateTime.now()).inDays;
    if (daysLeft <= 0) {
      freshness = 0;
    } else {
      freshness = ((daysLeft / 7.0) * 100).clamp(0, 100).toDouble();
    }
  }

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json['id'] as String,
        name: json['name'] as String,
        quantity: (json['qty'] ?? json['quantity']) is num
            ? ((json['qty'] ?? json['quantity']) as num).toDouble()
            : double.tryParse((json['qty'] ?? json['quantity']).toString()) ?? 0,
        unit: (json['unit'] ?? 'pcs') as String,
        expiryDate: (json['expiryDate'] as String?) != null
            ? DateTime.tryParse(json['expiryDate'] as String)
            : null,
        threshold: (json['threshold'] as num?)?.toInt() ?? 1,
        freshness: (json['freshnessScore'] ?? json['freshness']) is num
            ? ((json['freshnessScore'] ?? json['freshness']) as num).toDouble()
            : 100,
        category: (json['category'] ?? 'General') as String,
        storageType: (json['storageType'] ?? 'dry') as String,
        cost: (json['cost'] as num?)?.toDouble() ?? 0,
        history: (json['history'] as List?)
                ?.map((e) => IngredientHistoryItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'unit': unit,
        'expiryDate': expiryDate?.toIso8601String(),
        'threshold': threshold,
        'freshness': freshness,
        'category': category,
        'storageType': storageType,
        'cost': cost,
        'history': history.map((e) => e.toJson()).toList(),
      };
}
