import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/restaurant_entity.dart';
import '../entities/menu_item_entity.dart';

abstract class RestaurantRepository {
  /// Get all restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurants({
    int page = 1,
    int limit = 20,
    String? searchQuery,
    String? cuisineType,
    bool? isFeatured,
  });

  /// Get restaurant by ID
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id);

  /// Get featured restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getFeaturedRestaurants();

  /// Get nearby restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  });

  /// Search restaurants
  Future<Either<Failure, List<RestaurantEntity>>> searchRestaurants({
    required String query,
    int page = 1,
    int limit = 20,
  });

  /// Get menu items for a restaurant
  Future<Either<Failure, List<MenuItemEntity>>> getMenuItems({
    required String restaurantId,
    MenuItemCategory? category,
  });

  /// Get menu item by ID
  Future<Either<Failure, MenuItemEntity>> getMenuItemById(String id);

  /// Toggle restaurant favorite
  Future<Either<Failure, bool>> toggleFavorite(String restaurantId);

  /// Get favorite restaurants
  Future<Either<Failure, List<RestaurantEntity>>> getFavoriteRestaurants();

  /// Get restaurants by cuisine type
  Future<Either<Failure, List<RestaurantEntity>>> getRestaurantsByCuisine(
    String cuisineType,
  );

  /// Get restaurant ratings and reviews
  Future<Either<Failure, List<dynamic>>> getRestaurantReviews({
    required String restaurantId,
    int page = 1,
    int limit = 20,
  });

  /// Add restaurant review
  Future<Either<Failure, void>> addRestaurantReview({
    required String restaurantId,
    required double rating,
    required String comment,
  });
}
