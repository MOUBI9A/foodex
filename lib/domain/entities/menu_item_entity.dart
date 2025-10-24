import 'package:equatable/equatable.dart';

enum MenuItemCategory {
  burgers,
  pizza,
  pasta,
  sushi,
  desserts,
  drinks,
  salads,
  appetizers,
  mainCourse,
}

class MenuItemEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final MenuItemCategory category;
  final List<String> allergens;
  final int calories;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isSpicy;
  final int preparationTime; // in minutes
  final List<String> ingredients;
  final Map<String, double>? customizations; // e.g., "Extra Cheese": 2.00

  const MenuItemEntity({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.allergens,
    required this.calories,
    required this.rating,
    required this.reviewCount,
    this.isAvailable = true,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.isSpicy = false,
    required this.preparationTime,
    required this.ingredients,
    this.customizations,
  });

  MenuItemEntity copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    MenuItemCategory? category,
    List<String>? allergens,
    int? calories,
    double? rating,
    int? reviewCount,
    bool? isAvailable,
    bool? isVegetarian,
    bool? isVegan,
    bool? isGlutenFree,
    bool? isSpicy,
    int? preparationTime,
    List<String>? ingredients,
    Map<String, double>? customizations,
  }) {
    return MenuItemEntity(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      allergens: allergens ?? this.allergens,
      calories: calories ?? this.calories,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isAvailable: isAvailable ?? this.isAvailable,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isSpicy: isSpicy ?? this.isSpicy,
      preparationTime: preparationTime ?? this.preparationTime,
      ingredients: ingredients ?? this.ingredients,
      customizations: customizations ?? this.customizations,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        name,
        description,
        imageUrl,
        price,
        category,
        allergens,
        calories,
        rating,
        reviewCount,
        isAvailable,
        isVegetarian,
        isVegan,
        isGlutenFree,
        isSpicy,
        preparationTime,
        ingredients,
        customizations,
      ];
}
