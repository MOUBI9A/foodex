// TasteProfile model with Hive adapter and JSON support.
import 'package:hive/hive.dart';

part 'taste_profile.g.dart';

@HiveType(typeId: 5)
class TasteProfile {
  @HiveField(0)
  final List<String> likedIngredients;
  @HiveField(1)
  final List<String> dislikedIngredients;
  @HiveField(2)
  final List<String> allergens;
  @HiveField(3)
  final List<String> cuisines;
  @HiveField(4)
  final bool prefersSpicy;
  @HiveField(5)
  final bool prefersHealthy;

  const TasteProfile({
    this.likedIngredients = const [],
    this.dislikedIngredients = const [],
    this.allergens = const [],
    this.cuisines = const [],
    this.prefersSpicy = false,
    this.prefersHealthy = false,
  });

  factory TasteProfile.fromJson(Map<String, dynamic> json) => TasteProfile(
        likedIngredients: (json['likedIngredients'] as List?)?.cast<String>() ??
            const [],
        dislikedIngredients:
            (json['dislikedIngredients'] as List?)?.cast<String>() ?? const [],
        allergens: (json['allergens'] as List?)?.cast<String>() ?? const [],
        cuisines: (json['cuisines'] as List?)?.cast<String>() ?? const [],
        prefersSpicy: (json['prefersSpicy'] as bool?) ?? false,
        prefersHealthy: (json['prefersHealthy'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => {
        'likedIngredients': likedIngredients,
        'dislikedIngredients': dislikedIngredients,
        'allergens': allergens,
        'cuisines': cuisines,
        'prefersSpicy': prefersSpicy,
        'prefersHealthy': prefersHealthy,
      };
}
