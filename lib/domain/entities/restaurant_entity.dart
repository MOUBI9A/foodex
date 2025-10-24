import 'package:equatable/equatable.dart';

enum RestaurantStatus { open, closed, busy }

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final String cuisineType;
  final List<String> tags;
  final double deliveryFee;
  final int estimatedDeliveryTime; // in minutes
  final double minimumOrder;
  final RestaurantStatus status;
  final bool isFeatured;
  final bool isFavorite;
  final String? phoneNumber;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.cuisineType,
    required this.tags,
    required this.deliveryFee,
    required this.estimatedDeliveryTime,
    required this.minimumOrder,
    required this.status,
    this.isFeatured = false,
    this.isFavorite = false,
    this.phoneNumber,
  });

  RestaurantEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? address,
    double? latitude,
    double? longitude,
    double? rating,
    int? reviewCount,
    String? cuisineType,
    List<String>? tags,
    double? deliveryFee,
    int? estimatedDeliveryTime,
    double? minimumOrder,
    RestaurantStatus? status,
    bool? isFeatured,
    bool? isFavorite,
    String? phoneNumber,
  }) {
    return RestaurantEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      cuisineType: cuisineType ?? this.cuisineType,
      tags: tags ?? this.tags,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        address,
        latitude,
        longitude,
        rating,
        reviewCount,
        cuisineType,
        tags,
        deliveryFee,
        estimatedDeliveryTime,
        minimumOrder,
        status,
        isFeatured,
        isFavorite,
        phoneNumber,
      ];
}
