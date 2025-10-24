/// Revenue data point for charting
/// Represents revenue value at a specific date/time
class RevenuePoint {
  final DateTime date;
  final double value;

  const RevenuePoint(this.date, this.value);

  factory RevenuePoint.fromJson(Map<String, dynamic> json) {
    return RevenuePoint(
      DateTime.parse(json['date']),
      (json['value'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'value': value,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RevenuePoint &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          value == other.value;

  @override
  int get hashCode => date.hashCode ^ value.hashCode;
}
