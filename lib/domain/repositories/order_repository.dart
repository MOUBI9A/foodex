import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  /// Create a new order
  Future<Either<Failure, OrderEntity>> createOrder({
    required String restaurantId,
    required List<OrderItemEntity> items,
    required PaymentMethod paymentMethod,
    required String deliveryAddress,
    required double deliveryLatitude,
    required double deliveryLongitude,
    String? deliveryInstructions,
    String? promoCode,
  });

  /// Get order by ID
  Future<Either<Failure, OrderEntity>> getOrderById(String orderId);

  /// Get user orders
  Future<Either<Failure, List<OrderEntity>>> getUserOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  });

  /// Get active orders for user
  Future<Either<Failure, List<OrderEntity>>> getActiveOrders();

  /// Get order history
  Future<Either<Failure, List<OrderEntity>>> getOrderHistory({
    int page = 1,
    int limit = 20,
  });

  /// Cancel order
  Future<Either<Failure, OrderEntity>> cancelOrder({
    required String orderId,
    required String reason,
  });

  /// Track order in real-time
  Stream<OrderEntity> trackOrder(String orderId);

  /// Get chef orders (for chef dashboard)
  Future<Either<Failure, List<OrderEntity>>> getChefOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Update order status (for chef)
  Future<Either<Failure, OrderEntity>> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  /// Get driver orders (for driver dashboard)
  Future<Either<Failure, List<OrderEntity>>> getDriverOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 20,
  });

  /// Assign driver to order
  Future<Either<Failure, OrderEntity>> assignDriver({
    required String orderId,
    required String driverId,
  });

  /// Update delivery status
  Future<Either<Failure, OrderEntity>> updateDeliveryStatus({
    required String orderId,
    required OrderStatus status,
  });

  /// Rate order
  Future<Either<Failure, void>> rateOrder({
    required String orderId,
    required double rating,
    String? review,
  });

  /// Reorder (create new order from previous order)
  Future<Either<Failure, OrderEntity>> reorder(String orderId);
}
