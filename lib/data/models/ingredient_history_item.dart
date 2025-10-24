/// History item tracking ingredient stock changes
class IngredientHistoryItem {
  final DateTime date;
  final String action; // added | used | expired | restocked | discarded
  final double quantity;
  final String note;

  const IngredientHistoryItem({
    required this.date,
    required this.action,
    required this.quantity,
    this.note = '',
  });

  factory IngredientHistoryItem.fromJson(Map<String, dynamic> json) {
    return IngredientHistoryItem(
      date: DateTime.parse(json['date'] as String),
      action: json['action'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'action': action,
      'quantity': quantity,
      'note': note,
    };
  }

  IngredientHistoryItem copyWith({
    DateTime? date,
    String? action,
    double? quantity,
    String? note,
  }) {
    return IngredientHistoryItem(
      date: date ?? this.date,
      action: action ?? this.action,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }

  @override
  String toString() {
    return 'IngredientHistoryItem(date: $date, action: $action, quantity: $quantity, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IngredientHistoryItem &&
        other.date == date &&
        other.action == action &&
        other.quantity == quantity &&
        other.note == note;
  }

  @override
  int get hashCode {
    return date.hashCode ^ action.hashCode ^ quantity.hashCode ^ note.hashCode;
  }
}
