// Lightweight customer preference summary for safety logic.
class CustomerPreference {
  final String customerId;
  final List<String> likedIngredients;
  final List<String> dislikedIngredients;
  final List<String> allergies;
  final List<String> dietFlags;

  const CustomerPreference({
    required this.customerId,
    required this.likedIngredients,
    required this.dislikedIngredients,
    required this.allergies,
    required this.dietFlags,
  });

  factory CustomerPreference.fromJson(Map<String, dynamic> json) => CustomerPreference(
        customerId: json['customerId'] as String,
        likedIngredients:
            (json['likedIngredients'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
        dislikedIngredients:
            (json['dislikedIngredients'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
        allergies:
            (json['allergies'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
        dietFlags:
            (json['dietFlags'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
      );

  Map<String, dynamic> toJson() => {
        'customerId': customerId,
        'likedIngredients': likedIngredients,
        'dislikedIngredients': dislikedIngredients,
        'allergies': allergies,
        'dietFlags': dietFlags,
      };
}
