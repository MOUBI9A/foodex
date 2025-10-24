import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/menu_item_entity.dart';

@JsonSerializable()
class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.category,
    required super.allergens,
    required super.calories,
    required super.rating,
    required super.reviewCount,
    super.isAvailable,
    super.isVegetarian,
    super.isVegan,
    super.isGlutenFree,
    super.isSpicy,
    required super.preparationTime,
    required super.ingredients,
    super.customizations,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String? ?? '',
      category: MenuItemCategory.values.firstWhere(
        (e) => e.toString() == 'MenuItemCategory.${json['category']}',
        orElse: () => MenuItemCategory.mainCourse,
      ),
      restaurantId: json['restaurantId'] as String,
      allergens: (json['allergens'] as List<dynamic>?)?.cast<String>() ?? [],
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      preparationTime: (json['preparationTime'] as num?)?.toInt() ?? 15,
      ingredients:
          (json['ingredients'] as List<dynamic>?)?.cast<String>() ?? [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      isGlutenFree: json['isGlutenFree'] as bool? ?? false,
      isSpicy: json['isSpicy'] as bool? ?? false,
      customizations: (json['customizations'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'restaurantId': restaurantId,
    };
  }

  factory MenuItemModel.fromEntity(MenuItemEntity entity) {
    return MenuItemModel(
      id: entity.id,
      restaurantId: entity.restaurantId,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      price: entity.price,
      category: entity.category,
      allergens: entity.allergens,
      calories: entity.calories,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      isAvailable: entity.isAvailable,
      isVegetarian: entity.isVegetarian,
      isVegan: entity.isVegan,
      isGlutenFree: entity.isGlutenFree,
      isSpicy: entity.isSpicy,
      preparationTime: entity.preparationTime,
      ingredients: entity.ingredients,
      customizations: entity.customizations,
    );
  }

  MenuItemEntity toEntity() => this;
}
