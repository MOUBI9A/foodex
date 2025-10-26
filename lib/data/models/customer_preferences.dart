// Customer preferences model for ingredient filtering and dish recommendations.
import 'package:hive/hive.dart';

part 'customer_preferences.g.dart';

@HiveType(typeId: 8)
class CustomerPreferences {
  @HiveField(0)
  String customerId;
  
  @HiveField(1)
  List<String> likedIngredients;
  
  @HiveField(2)
  List<String> dislikedIngredients;
  
  @HiveField(3)
  List<String> allergies;
  
  @HiveField(4)
  List<String> dietaryRestrictions; // vegetarian, vegan, gluten-free, halal, kosher, etc.
  
  @HiveField(5)
  int spiceLevel; // 0=none, 1=mild, 2=medium, 3=hot, 4=extra-hot
  
  @HiveField(6)
  List<String> favoriteCuisines;
  
  @HiveField(7)
  bool organicPreference;
  
  @HiveField(8)
  DateTime? updatedAt;

  CustomerPreferences({
    required this.customerId,
    List<String>? likedIngredients,
    List<String>? dislikedIngredients,
    List<String>? allergies,
    List<String>? dietaryRestrictions,
    this.spiceLevel = 2,
    List<String>? favoriteCuisines,
    this.organicPreference = false,
    this.updatedAt,
  })  : likedIngredients = likedIngredients ?? [],
        dislikedIngredients = dislikedIngredients ?? [],
        allergies = allergies ?? [],
        dietaryRestrictions = dietaryRestrictions ?? [],
        favoriteCuisines = favoriteCuisines ?? [];

  // Check if a dish matches customer preferences
  bool isDishCompatible(List<String> dishIngredients) {
    // Check for allergies (highest priority)
    for (final allergy in allergies) {
      if (dishIngredients.any((ing) => ing.toLowerCase().contains(allergy.toLowerCase()))) {
        return false; // Dish contains allergen
      }
    }
    
    // Check for disliked ingredients
    for (final disliked in dislikedIngredients) {
      if (dishIngredients.any((ing) => ing.toLowerCase().contains(disliked.toLowerCase()))) {
        return false; // Dish contains disliked ingredient
      }
    }
    
    return true;
  }

  // Calculate preference score for a dish (0-100)
  double calculateDishScore(List<String> dishIngredients) {
    if (!isDishCompatible(dishIngredients)) {
      return 0; // Incompatible dish
    }
    
    double score = 50.0; // Base score
    
    // Add points for liked ingredients
    for (final liked in likedIngredients) {
      if (dishIngredients.any((ing) => ing.toLowerCase().contains(liked.toLowerCase()))) {
        score += 10;
      }
    }
    
    return score.clamp(0, 100);
  }

  factory CustomerPreferences.fromJson(Map<String, dynamic> json) {
    return CustomerPreferences(
      customerId: json['customerId'] as String,
      likedIngredients: (json['likedIngredients'] as List?)?.cast<String>() ?? [],
      dislikedIngredients: (json['dislikedIngredients'] as List?)?.cast<String>() ?? [],
      allergies: (json['allergies'] as List?)?.cast<String>() ?? [],
      dietaryRestrictions: (json['dietaryRestrictions'] as List?)?.cast<String>() ?? [],
      spiceLevel: (json['spiceLevel'] as int?) ?? 2,
      favoriteCuisines: (json['favoriteCuisines'] as List?)?.cast<String>() ?? [],
      organicPreference: (json['organicPreference'] as bool?) ?? false,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'likedIngredients': likedIngredients,
      'dislikedIngredients': dislikedIngredients,
      'allergies': allergies,
      'dietaryRestrictions': dietaryRestrictions,
      'spiceLevel': spiceLevel,
      'favoriteCuisines': favoriteCuisines,
      'organicPreference': organicPreference,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
