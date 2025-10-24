import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/entities/menu_item_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';

// Logger
final _logger = Logger('RestaurantProvider');

// ============================================================================
// Restaurant State
// ============================================================================

class RestaurantState {
  final List<RestaurantEntity> restaurants;
  final List<RestaurantEntity> featuredRestaurants;
  final List<RestaurantEntity> nearbyRestaurants;
  final List<RestaurantEntity> favoriteRestaurants;
  final Map<String, List<MenuItemEntity>>
      menuItemsCache; // restaurantId -> menu items
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final String? searchQuery;
  final int currentPage;
  final bool hasMore;

  const RestaurantState({
    this.restaurants = const [],
    this.featuredRestaurants = const [],
    this.nearbyRestaurants = const [],
    this.favoriteRestaurants = const [],
    this.menuItemsCache = const {},
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.searchQuery,
    this.currentPage = 1,
    this.hasMore = true,
  });

  RestaurantState copyWith({
    List<RestaurantEntity>? restaurants,
    List<RestaurantEntity>? featuredRestaurants,
    List<RestaurantEntity>? nearbyRestaurants,
    List<RestaurantEntity>? favoriteRestaurants,
    Map<String, List<MenuItemEntity>>? menuItemsCache,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    String? searchQuery,
    int? currentPage,
    bool? hasMore,
  }) {
    return RestaurantState(
      restaurants: restaurants ?? this.restaurants,
      featuredRestaurants: featuredRestaurants ?? this.featuredRestaurants,
      nearbyRestaurants: nearbyRestaurants ?? this.nearbyRestaurants,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      menuItemsCache: menuItemsCache ?? this.menuItemsCache,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  RestaurantState clearError() {
    return copyWith(error: '');
  }
}

// ============================================================================
// Restaurant Notifier
// ============================================================================

class RestaurantNotifier extends StateNotifier<RestaurantState> {
  final RestaurantRepository _repository;

  RestaurantNotifier(this._repository) : super(const RestaurantState()) {
    // Load initial data
    loadRestaurants();
    loadFeaturedRestaurants();
  }

  // Load all restaurants with pagination
  Future<void> loadRestaurants({bool refresh = false}) async {
    if (state.isLoading || state.isLoadingMore) return;

    if (refresh) {
      state = const RestaurantState();
    }

    state = state.copyWith(
      isLoading: state.currentPage == 1,
      isLoadingMore: state.currentPage > 1,
    );

    _logger.info('Loading restaurants (page ${state.currentPage})...');

    final result = await _repository.getRestaurants(
      page: state.currentPage,
      limit: 20,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to load restaurants', error: failure);
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: failure.message,
        );
      },
      (restaurants) {
        _logger.info('Loaded ${restaurants.length} restaurants');
        state = state.copyWith(
          restaurants: state.currentPage == 1
              ? restaurants
              : [...state.restaurants, ...restaurants],
          isLoading: false,
          isLoadingMore: false,
          currentPage: state.currentPage + 1,
          hasMore: restaurants.length >= 20,
        );
      },
    );
  }

  // Load featured restaurants
  Future<void> loadFeaturedRestaurants() async {
    _logger.info('Loading featured restaurants...');

    final result = await _repository.getFeaturedRestaurants();

    result.fold(
      (failure) {
        _logger.error('Failed to load featured restaurants', error: failure);
      },
      (restaurants) {
        _logger.info('Loaded ${restaurants.length} featured restaurants');
        state = state.copyWith(featuredRestaurants: restaurants);
      },
    );
  }

  // Load nearby restaurants
  Future<void> loadNearbyRestaurants(
    double latitude,
    double longitude, {
    double radiusKm = 5.0,
  }) async {
    state = state.copyWith(isLoading: true);

    _logger.info('Loading nearby restaurants (radius: $radiusKm km)...');

    final result = await _repository.getNearbyRestaurants(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to load nearby restaurants', error: failure);
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (restaurants) {
        _logger.info('Loaded ${restaurants.length} nearby restaurants');
        state = state.copyWith(
          nearbyRestaurants: restaurants,
          isLoading: false,
        );
      },
    );
  }

  // Search restaurants
  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      state = state.copyWith(
        searchQuery: '',
        restaurants: const [],
        currentPage: 1,
      );
      await loadRestaurants();
      return;
    }

    state = state.copyWith(
      isLoading: true,
      searchQuery: query,
      currentPage: 1,
    );

    _logger.info('Searching restaurants: $query');

    final result = await _repository.searchRestaurants(
      query: query,
      page: 1,
      limit: 20,
    );

    result.fold(
      (failure) {
        _logger.error('Search failed', error: failure);
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (restaurants) {
        _logger.info('Found ${restaurants.length} restaurants');
        state = state.copyWith(
          restaurants: restaurants,
          isLoading: false,
          hasMore: restaurants.length >= 20,
        );
      },
    );
  }

  // Toggle favorite
  Future<void> toggleFavorite(String restaurantId) async {
    _logger.info('Toggling favorite for restaurant: $restaurantId');

    // Optimistic update
    final updatedRestaurants = state.restaurants.map((r) {
      if (r.id == restaurantId) {
        return RestaurantEntity(
          id: r.id,
          name: r.name,
          description: r.description,
          imageUrl: r.imageUrl,
          address: r.address,
          latitude: r.latitude,
          longitude: r.longitude,
          cuisineType: r.cuisineType,
          rating: r.rating,
          reviewCount: r.reviewCount,
          deliveryFee: r.deliveryFee,
          estimatedDeliveryTime: r.estimatedDeliveryTime,
          minimumOrder: r.minimumOrder,
          isFeatured: r.isFeatured,
          isFavorite: !r.isFavorite,
          status: r.status,
          tags: r.tags,
          phoneNumber: r.phoneNumber,
        );
      }
      return r;
    }).toList();

    state = state.copyWith(restaurants: updatedRestaurants);

    final result = await _repository.toggleFavorite(restaurantId);

    result.fold(
      (failure) {
        _logger.error('Failed to toggle favorite', error: failure);
        // Revert optimistic update
        state = state.copyWith(restaurants: state.restaurants);
      },
      (_) {
        _logger.info('Favorite toggled successfully');
        // Update favorites list
        loadFavoriteRestaurants();
      },
    );
  }

  // Load favorite restaurants
  Future<void> loadFavoriteRestaurants() async {
    _logger.info('Loading favorite restaurants...');

    final result = await _repository.getFavoriteRestaurants();

    result.fold(
      (failure) {
        _logger.error('Failed to load favorites', error: failure);
      },
      (restaurants) {
        _logger.info('Loaded ${restaurants.length} favorite restaurants');
        state = state.copyWith(favoriteRestaurants: restaurants);
      },
    );
  }

  // Load menu items for a restaurant
  Future<void> loadMenuItems(String restaurantId) async {
    // Check cache first
    if (state.menuItemsCache.containsKey(restaurantId)) {
      _logger.info('Using cached menu items for restaurant: $restaurantId');
      return;
    }

    _logger.info('Loading menu items for restaurant: $restaurantId');

    final result = await _repository.getMenuItems(
      restaurantId: restaurantId,
    );

    result.fold(
      (failure) {
        _logger.error('Failed to load menu items', error: failure);
      },
      (menuItems) {
        _logger.info('Loaded ${menuItems.length} menu items');
        final updatedCache = Map<String, List<MenuItemEntity>>.from(
          state.menuItemsCache,
        );
        updatedCache[restaurantId] = menuItems;
        state = state.copyWith(menuItemsCache: updatedCache);
      },
    );
  }

  // Get menu items from cache
  List<MenuItemEntity> getMenuItems(String restaurantId) {
    return state.menuItemsCache[restaurantId] ?? [];
  }

  // Clear search
  void clearSearch() {
    state = state.copyWith(
      searchQuery: '',
      currentPage: 1,
    );
    loadRestaurants(refresh: true);
  }
}

// ============================================================================
// Providers
// ============================================================================

// TODO: Replace with actual repository implementation when ready
final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  throw UnimplementedError(
    'RestaurantRepository implementation not registered. '
    'Please implement RestaurantRepositoryImpl and register it in service_locator.dart',
  );
});

// Restaurant provider
final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantState>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  return RestaurantNotifier(repository);
});

// Convenience providers
final restaurantsProvider = Provider<List<RestaurantEntity>>((ref) {
  return ref.watch(restaurantProvider).restaurants;
});

final featuredRestaurantsProvider = Provider<List<RestaurantEntity>>((ref) {
  return ref.watch(restaurantProvider).featuredRestaurants;
});

final nearbyRestaurantsProvider = Provider<List<RestaurantEntity>>((ref) {
  return ref.watch(restaurantProvider).nearbyRestaurants;
});

final favoriteRestaurantsProvider = Provider<List<RestaurantEntity>>((ref) {
  return ref.watch(restaurantProvider).favoriteRestaurants;
});

final isRestaurantsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(restaurantProvider).isLoading;
});

final restaurantSearchQueryProvider = Provider<String?>((ref) {
  return ref.watch(restaurantProvider).searchQuery;
});
