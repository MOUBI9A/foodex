// IngredientHistoryItem model with Hive adapter and JSON support.
import 'package:hive/hive.dart';

part 'ingredient_history_item.g.dart';

@HiveType(typeId: 2)
class IngredientHistoryItem {
  @HiveField(0)
  final String action; // added, restocked, discarded, edited
  @HiveField(1)
  final double qty;
  @HiveField(2)
  final DateTime date;
  @HiveField(3)
  final String? note;

  const IngredientHistoryItem({
    required this.action,
    required this.qty,
    required this.date,
    this.note,
  });

  factory IngredientHistoryItem.fromJson(Map<String, dynamic> json) =>
      IngredientHistoryItem(
        action: json['action'] as String,
        qty: (json['qty'] as num).toDouble(),
        date: DateTime.parse(json['date'] as String),
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'action': action,
        'qty': qty,
        'date': date.toIso8601String(),
        'note': note,
      };
}
