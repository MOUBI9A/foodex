import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  pickedUp,
  onTheWay,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash,
  card,
  wallet,
  upi,
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

class OrderItemEntity extends Equatable {
  final String menuItemId;
  final String name;
  final int quantity;
  final double price;
  final Map<String, dynamic>? customizations;
  final String? specialInstructions;

  const OrderItemEntity({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.price,
    this.customizations,
    this.specialInstructions,
  });

  double get totalPrice => price * quantity;

  @override
  List<Object?> get props => [
        menuItemId,
        name,
        quantity,
        price,
        customizations,
        specialInstructions,
      ];
}

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItemEntity> items;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double tax;
  final double discount;
  final double total;
  final String deliveryAddress;
  final double deliveryLatitude;
  final double deliveryLongitude;
  final String? deliveryInstructions;
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? preparingAt;
  final DateTime? readyAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final int? estimatedDeliveryTime; // in minutes
  final String? promoCode;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.tax,
    required this.discount,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryLatitude,
    required this.deliveryLongitude,
    this.deliveryInstructions,
    this.driverId,
    this.driverName,
    this.driverPhone,
    required this.createdAt,
    this.confirmedAt,
    this.preparingAt,
    this.readyAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.estimatedDeliveryTime,
    this.promoCode,
  });

  OrderEntity copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    List<OrderItemEntity>? items,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    double? subtotal,
    double? deliveryFee,
    double? serviceFee,
    double? tax,
    double? discount,
    double? total,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    String? deliveryInstructions,
    String? driverId,
    String? driverName,
    String? driverPhone,
    DateTime? createdAt,
    DateTime? confirmedAt,
    DateTime? preparingAt,
    DateTime? readyAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    int? estimatedDeliveryTime,
    String? promoCode,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      serviceFee: serviceFee ?? this.serviceFee,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      driverId: driverId ?? this.driverId,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      preparingAt: preparingAt ?? this.preparingAt,
      readyAt: readyAt ?? this.readyAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        restaurantId,
        restaurantName,
        items,
        status,
        paymentMethod,
        paymentStatus,
        subtotal,
        deliveryFee,
        serviceFee,
        tax,
        discount,
        total,
        deliveryAddress,
        deliveryLatitude,
        deliveryLongitude,
        deliveryInstructions,
        driverId,
        driverName,
        driverPhone,
        createdAt,
        confirmedAt,
        preparingAt,
        readyAt,
        pickedUpAt,
        deliveredAt,
        cancelledAt,
        cancellationReason,
        estimatedDeliveryTime,
        promoCode,
      ];
}
