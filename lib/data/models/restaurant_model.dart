import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/restaurant_entity.dart';

part 'restaurant_model.g.dart';

@JsonSerializable()
class RestaurantModel extends RestaurantEntity {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.rating,
    required super.reviewCount,
    required super.cuisineType,
    required super.tags,
    required super.deliveryFee,
    required super.estimatedDeliveryTime,
    required super.minimumOrder,
    required super.status,
    super.isFeatured,
    super.isFavorite,
    super.phoneNumber,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);

  factory RestaurantModel.fromEntity(RestaurantEntity entity) {
    return RestaurantModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      cuisineType: entity.cuisineType,
      tags: entity.tags,
      deliveryFee: entity.deliveryFee,
      estimatedDeliveryTime: entity.estimatedDeliveryTime,
      minimumOrder: entity.minimumOrder,
      status: entity.status,
      isFeatured: entity.isFeatured,
      isFavorite: entity.isFavorite,
      phoneNumber: entity.phoneNumber,
    );
  }

  RestaurantEntity toEntity() => this;
}
