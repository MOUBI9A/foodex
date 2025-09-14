class Dish {
  final String id;
  final String chefId;
  final String name;
  final String description;
  final double price;
  final String currency;
  final List<String> images;
  final List<String> ingredients;
  final DishCategory category;
  final int preparationTime; // in minutes
  final bool isAvailable;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final double rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Dish({
    required this.id,
    required this.chefId,
    required this.name,
    required this.description,
    required this.price,
    this.currency = 'MAD',
    required this.images,
    required this.ingredients,
    required this.category,
    required this.preparationTime,
    this.isAvailable = true,
    this.isVegetarian = false,
    this.isVegan = false,
    this.isGlutenFree = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      chefId: json['chef_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      currency: json['currency'] ?? 'MAD',
      images: List<String>.from(json['images']),
      ingredients: List<String>.from(json['ingredients']),
      category: DishCategory.values.firstWhere(
        (e) => e.toString().split('.').last == json['category'],
      ),
      preparationTime: json['preparation_time'],
      isAvailable: json['is_available'] ?? true,
      isVegetarian: json['is_vegetarian'] ?? false,
      isVegan: json['is_vegan'] ?? false,
      isGlutenFree: json['is_gluten_free'] ?? false,
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chef_id': chefId,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'images': images,
      'ingredients': ingredients,
      'category': category.toString().split('.').last,
      'preparation_time': preparationTime,
      'is_available': isAvailable,
      'is_vegetarian': isVegetarian,
      'is_vegan': isVegan,
      'is_gluten_free': isGlutenFree,
      'rating': rating,
      'review_count': reviewCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

enum DishCategory {
  tagine,
  couscous,
  pastilla,
  soup,
  salad,
  dessert,
  bread,
  beverage,
  appetizer,
  main,
  snack,
}

class Chef {
  final String id;
  final String userId;
  final String bio;
  final List<String> specialties;
  final String kitchenAddress;
  final bool isKitchenOpen;
  final Map<String, String> workingHours; // day: "09:00-21:00"
  final double rating;
  final int reviewCount;
  final int totalOrders;
  final List<String> certifications;
  final DateTime joinedAt;

  Chef({
    required this.id,
    required this.userId,
    required this.bio,
    required this.specialties,
    required this.kitchenAddress,
    this.isKitchenOpen = false,
    required this.workingHours,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.totalOrders = 0,
    required this.certifications,
    required this.joinedAt,
  });

  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      id: json['id'],
      userId: json['user_id'],
      bio: json['bio'],
      specialties: List<String>.from(json['specialties']),
      kitchenAddress: json['kitchen_address'],
      isKitchenOpen: json['is_kitchen_open'] ?? false,
      workingHours: Map<String, String>.from(json['working_hours']),
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
      certifications: List<String>.from(json['certifications']),
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bio': bio,
      'specialties': specialties,
      'kitchen_address': kitchenAddress,
      'is_kitchen_open': isKitchenOpen,
      'working_hours': workingHours,
      'rating': rating,
      'review_count': reviewCount,
      'total_orders': totalOrders,
      'certifications': certifications,
      'joined_at': joinedAt.toIso8601String(),
    };
  }
}
