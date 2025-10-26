// Dish model with IngredientUsage, Hive adapters, JSON support.
import 'package:hive/hive.dart';

part 'dish.g.dart';

@HiveType(typeId: 4)
class IngredientUsage {
  @HiveField(0)
  final String ingredientId;
  @HiveField(1)
  final double qty;

  const IngredientUsage({required this.ingredientId, required this.qty});

  factory IngredientUsage.fromJson(Map<String, dynamic> json) =>
      IngredientUsage(
        ingredientId: json['ingredientId'] as String,
        qty: (json['qty'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'ingredientId': ingredientId,
        'qty': qty,
      };
}

@HiveType(typeId: 3)
class Dish {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String chefId;
  @HiveField(4)
  final List<IngredientUsage> ingredients;
  @HiveField(5)
  final double price;
  @HiveField(6)
  final int prepTime; // minutes
  @HiveField(7)
  final double rating;
  @HiveField(8)
  final List<String> images;

  const Dish({
    required this.id,
    required this.name,
    this.description = '',
    this.chefId = 'chef-001',
    required this.ingredients,
    required this.price,
    required this.prepTime,
    this.rating = 0,
    this.images = const [],
  });

  factory Dish.fromJson(Map<String, dynamic> json) => Dish(
        id: json['id'] as String,
        name: json['name'] as String,
        description: (json['description'] ?? '') as String,
        chefId: (json['chefId'] ?? 'chef-001') as String,
        ingredients: (json['ingredients'] as List)
            .map((e) => IngredientUsage.fromJson(e as Map<String, dynamic>))
            .toList(),
        price: (json['price'] as num).toDouble(),
        prepTime: (json['prepTime'] as num).toInt(),
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        images: (json['images'] as List?)?.cast<String>() ?? const [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'chefId': chefId,
        'ingredients': ingredients.map((e) => e.toJson()).toList(),
        'price': price,
        'prepTime': prepTime,
        'rating': rating,
        'images': images,
      };
}
