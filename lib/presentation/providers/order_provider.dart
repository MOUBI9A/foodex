import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';

// Logger
final _logger = Logger('OrderProvider');

// ============================================================================
// Order State
// ============================================================================

class OrderState {
  final List<OrderEntity> orders;
  final List<OrderEntity> activeOrders;
  final List<OrderEntity> pastOrders;
  final OrderEntity? currentTrackingOrder;
  final bool isLoading;
  final String? error;
  final StreamSubscription<OrderEntity>? trackingSubscription;

  const OrderState({
    this.orders = const [],
    this.activeOrders = const [],
    this.pastOrders = const [],
    this.currentTrackingOrder,
    this.isLoading = false,
    this.error,
    this.trackingSubscription,
  });

  OrderState copyWith({
    List<OrderEntity>? orders,
    List<OrderEntity>? activeOrders,
    List<OrderEntity>? pastOrders,
    OrderEntity? currentTrackingOrder,
    bool? isLoading,
    String? error,
    StreamSubscription<OrderEntity>? trackingSubscription,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      activeOrders: activeOrders ?? this.activeOrders,
      pastOrders: pastOrders ?? this.pastOrders,
      currentTrackingOrder: currentTrackingOrder ?? this.currentTrackingOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      trackingSubscription: trackingSubscription ?? this.trackingSubscription,
    );
  }

  OrderState clearError() {
    return copyWith(error: '');
  }

  OrderState clearTracking() {
    trackingSubscription?.cancel();
    return copyWith(
      currentTrackingOrder: null,
      trackingSubscription: null,
    );
  }
}

// ============================================================================
// Order Notifier
// ============================================================================

class OrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  OrderNotifier(this._repository) : super(const OrderState()) {
    // Load initial orders
    loadUserOrders();
  }

  @override
  void dispose() {
    state.trackingSubscription?.cancel();
    super.dispose();
  }

  // Create a new order
  Future<Either<Failure, OrderEntity>> createOrder({
    required String restaurantId,
    required List<OrderItemEntity> items,
    required String deliveryAddress,
    required double deliveryLatitude,
    required double deliveryLongitude,
    required PaymentMethod paymentMethod,
    String? deliveryInstructions,
    String? promoCode,
  }) async {
    state = state.copyWith(isLoading: true);

    _logger.info('Creating order for restaurant: $restaurantId');

    final result = await _repository.createOrder(
      restaurantId: restaurantId,
      items: items,
      deliveryAddress: deliveryAddress,
      deliveryLatitude: deliveryLatitude,
      deliveryLongitude: deliveryLongitude,
      paymentMethod: paymentMethod,
      deliveryInstructions: deliveryInstructions,
      promoCode: promoCode,
    );

    state = state.copyWith(isLoading: false);

    return result.fold(
      (failure) {
        _logger.error('Failed to create order', error: failure);
        state = state.copyWith(error: failure.message);
        return Left(failure);
      },
      (order) {
        _logger.info('Order created successfully: ${order.id}');
        // Refresh orders list
        loadUserOrders();
        // Start tracking the new order
        startTracking(order.id);
        return Right(order);
      },
    );
  }

  // Load user's orders
  Future<void> loadUserOrders() async {
    state = state.copyWith(isLoading: true);

    _logger.info('Loading user orders...');

    final result = await _repository.getUserOrders();

    result.fold(
      (failure) {
        _logger.error('Failed to load orders', error: failure);
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (orders) {
        _logger.info('Loaded ${orders.length} orders');

        // Separate active and past orders
        final active = orders.where((o) => _isActiveOrder(o.status)).toList();
        final past = orders.where((o) => !_isActiveOrder(o.status)).toList();

        state = state.copyWith(
          orders: orders,
          activeOrders: active,
          pastOrders: past,
          isLoading: false,
        );

        // If there's an active order, start tracking it
        if (active.isNotEmpty && state.currentTrackingOrder == null) {
          startTracking(active.first.id);
        }
      },
    );
  }

  // Get order by ID
  Future<OrderEntity?> getOrder(String orderId) async {
    _logger.info('Getting order: $orderId');

    final result = await _repository.getOrderById(orderId);

    return result.fold(
      (failure) {
        _logger.error('Failed to get order', error: failure);
        state = state.copyWith(error: failure.message);
        return null;
      },
      (order) {
        _logger.info('Order retrieved: $orderId');
        return order;
      },
    );
  }

  // Start real-time tracking for an order
  void startTracking(String orderId) {
    // Cancel existing tracking
    state.trackingSubscription?.cancel();

    _logger.info('Starting real-time tracking for order: $orderId');

    final trackingStream = _repository.trackOrder(orderId);

    final subscription = trackingStream.listen(
      (order) {
        _logger.info('Order update received: ${order.status}');
        state = state.copyWith(currentTrackingOrder: order);

        // Update the order in the lists
        _updateOrderInLists(order);
      },
      onError: (error) {
        _logger.error('Tracking error', error: error);
        state = state.copyWith(
          error: 'Failed to track order: $error',
        );
      },
    );

    state = state.copyWith(trackingSubscription: subscription);
  }

  // Stop tracking
  void stopTracking() {
    _logger.info('Stopping order tracking');
    state = state.clearTracking();
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId, String reason) async {
    _logger.info('Cancelling order: $orderId');

    final result = await _repository.cancelOrder(
      orderId: orderId,
      reason: reason,
    );

    return result.fold(
      (failure) {
        _logger.error('Failed to cancel order', error: failure);
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        _logger.info('Order cancelled successfully');
        loadUserOrders(); // Refresh orders
        return true;
      },
    );
  }

  // Rate order
  Future<bool> rateOrder({
    required String orderId,
    required double rating,
    String? review,
  }) async {
    _logger.info('Rating order: $orderId (rating: $rating)');

    final result = await _repository.rateOrder(
      orderId: orderId,
      rating: rating,
      review: review,
    );

    return result.fold(
      (failure) {
        _logger.error('Failed to rate order', error: failure);
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        _logger.info('Order rated successfully');
        loadUserOrders(); // Refresh orders
        return true;
      },
    );
  }

  // Reorder
  Future<Either<Failure, OrderEntity>> reorder(String orderId) async {
    state = state.copyWith(isLoading: true);

    _logger.info('Reordering: $orderId');

    final result = await _repository.reorder(orderId);

    state = state.copyWith(isLoading: false);

    return result.fold(
      (failure) {
        _logger.error('Failed to reorder', error: failure);
        state = state.copyWith(error: failure.message);
        return Left(failure);
      },
      (order) {
        _logger.info('Reorder successful: ${order.id}');
        loadUserOrders(); // Refresh orders
        startTracking(order.id); // Track new order
        return Right(order);
      },
    );
  }

  // Helper: Check if order status is active
  bool _isActiveOrder(OrderStatus status) {
    return status != OrderStatus.delivered && status != OrderStatus.cancelled;
  }

  // Helper: Update order in lists
  void _updateOrderInLists(OrderEntity updatedOrder) {
    final updatedOrders = state.orders.map((o) {
      return o.id == updatedOrder.id ? updatedOrder : o;
    }).toList();

    final active =
        updatedOrders.where((o) => _isActiveOrder(o.status)).toList();
    final past = updatedOrders.where((o) => !_isActiveOrder(o.status)).toList();

    state = state.copyWith(
      orders: updatedOrders,
      activeOrders: active,
      pastOrders: past,
    );
  }
}

// ============================================================================
// Chef Order Notifier (for chef dashboard)
// ============================================================================

class ChefOrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  ChefOrderNotifier(this._repository) : super(const OrderState()) {
    loadChefOrders();
  }

  // Load chef's orders
  Future<void> loadChefOrders() async {
    state = state.copyWith(isLoading: true);

    _logger.info('Loading chef orders...');

    final result = await _repository.getChefOrders();

    result.fold(
      (failure) {
        _logger.error('Failed to load chef orders', error: failure);
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (orders) {
        _logger.info('Loaded ${orders.length} chef orders');
        state = state.copyWith(
          orders: orders,
          isLoading: false,
        );
      },
    );
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus status) async {
    _logger.info('Updating order status: $orderId -> $status');

    final result = await _repository.updateOrderStatus(
      orderId: orderId,
      status: status,
    );

    return result.fold(
      (failure) {
        _logger.error('Failed to update order status', error: failure);
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        _logger.info('Order status updated successfully');
        loadChefOrders(); // Refresh orders
        return true;
      },
    );
  }
}

// ============================================================================
// Driver Order Notifier (for driver dashboard)
// ============================================================================

class DriverOrderNotifier extends StateNotifier<OrderState> {
  final OrderRepository _repository;

  DriverOrderNotifier(this._repository) : super(const OrderState()) {
    loadAvailableOrders();
  }

  // Load available orders for drivers
  Future<void> loadAvailableOrders() async {
    state = state.copyWith(isLoading: true);

    _logger.info('Loading available orders (driver)...');

    final result = await _repository.getDriverOrders(
      status: OrderStatus.ready, // Only show ready-to-pickup orders
    );

    result.fold(
      (failure) {
        _logger.error('Failed to load available orders', error: failure);
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (orders) {
        _logger.info('Loaded ${orders.length} available orders');
        state = state.copyWith(
          orders: orders,
          isLoading: false,
        );
      },
    );
  }

  // Assign driver to order (driverId should come from auth context)
  Future<bool> assignToOrder(String orderId, String driverId) async {
    _logger.info('Assigning driver to order: $orderId');

    final result = await _repository.assignDriver(
      orderId: orderId,
      driverId: driverId,
    );

    return result.fold(
      (failure) {
        _logger.error('Failed to assign driver', error: failure);
        state = state.copyWith(error: failure.message);
        return false;
      },
      (_) {
        _logger.info('Driver assigned successfully');
        loadAvailableOrders(); // Refresh orders
        return true;
      },
    );
  }
}

// ============================================================================
// Providers
// ============================================================================

// TODO: Replace with actual repository implementation when ready
final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  throw UnimplementedError(
    'OrderRepository implementation not registered. '
    'Please implement OrderRepositoryImpl and register it in service_locator.dart',
  );
});

// Customer order provider
final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return OrderNotifier(repository);
});

// Chef order provider
final chefOrderProvider =
    StateNotifierProvider<ChefOrderNotifier, OrderState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return ChefOrderNotifier(repository);
});

// Driver order provider
final driverOrderProvider =
    StateNotifierProvider<DriverOrderNotifier, OrderState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return DriverOrderNotifier(repository);
});

// Convenience providers
final userOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(orderProvider).orders;
});

final activeOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(orderProvider).activeOrders;
});

final pastOrdersProvider = Provider<List<OrderEntity>>((ref) {
  return ref.watch(orderProvider).pastOrders;
});

final currentTrackingOrderProvider = Provider<OrderEntity?>((ref) {
  return ref.watch(orderProvider).currentTrackingOrder;
});

final isOrdersLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orderProvider).isLoading;
});
