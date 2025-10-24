import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order_entity.dart';

@JsonSerializable()
class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.menuItemId,
    required super.name,
    required super.quantity,
    required super.price,
    super.customizations,
    super.specialInstructions,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      menuItemId: json['menuItemId'] as String,
      name: json['name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      customizations: json['customizations'] as Map<String, dynamic>?,
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'customizations': customizations,
      'specialInstructions': specialInstructions,
    };
  }

  factory OrderItemModel.fromEntity(OrderItemEntity entity) {
    return OrderItemModel(
      menuItemId: entity.menuItemId,
      name: entity.name,
      quantity: entity.quantity,
      price: entity.price,
      customizations: entity.customizations,
      specialInstructions: entity.specialInstructions,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.restaurantId,
    required super.restaurantName,
    required super.items,
    required super.status,
    required super.paymentMethod,
    required super.paymentStatus,
    required super.subtotal,
    required super.deliveryFee,
    required super.serviceFee,
    required super.tax,
    required super.discount,
    required super.total,
    required super.deliveryAddress,
    required super.deliveryLatitude,
    required super.deliveryLongitude,
    super.deliveryInstructions,
    super.driverId,
    super.driverName,
    super.driverPhone,
    required super.createdAt,
    super.confirmedAt,
    super.preparingAt,
    super.readyAt,
    super.pickedUpAt,
    super.deliveredAt,
    super.cancelledAt,
    super.cancellationReason,
    super.estimatedDeliveryTime,
    super.promoCode,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${json['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['paymentMethod']}',
        orElse: () => PaymentMethod.cash,
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['paymentStatus']}',
        orElse: () => PaymentStatus.pending,
      ),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String,
      deliveryLatitude: (json['deliveryLatitude'] as num).toDouble(),
      deliveryLongitude: (json['deliveryLongitude'] as num).toDouble(),
      deliveryInstructions: json['deliveryInstructions'] as String?,
      driverId: json['driverId'] as String?,
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'] as String)
          : null,
      preparingAt: json['preparingAt'] != null
          ? DateTime.parse(json['preparingAt'] as String)
          : null,
      readyAt: json['readyAt'] != null
          ? DateTime.parse(json['readyAt'] as String)
          : null,
      pickedUpAt: json['pickedUpAt'] != null
          ? DateTime.parse(json['pickedUpAt'] as String)
          : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'] as String)
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'] as String)
          : null,
      cancellationReason: json['cancellationReason'] as String?,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? (json['estimatedDeliveryTime'] as num).toInt()
          : null,
      promoCode: json['promoCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'serviceFee': serviceFee,
      'tax': tax,
      'discount': discount,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'deliveryLatitude': deliveryLatitude,
      'deliveryLongitude': deliveryLongitude,
      'deliveryInstructions': deliveryInstructions,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'preparingAt': preparingAt?.toIso8601String(),
      'readyAt': readyAt?.toIso8601String(),
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'promoCode': promoCode,
    };
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      restaurantId: entity.restaurantId,
      restaurantName: entity.restaurantName,
      items: entity.items,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
      subtotal: entity.subtotal,
      deliveryFee: entity.deliveryFee,
      serviceFee: entity.serviceFee,
      tax: entity.tax,
      discount: entity.discount,
      total: entity.total,
      deliveryAddress: entity.deliveryAddress,
      deliveryLatitude: entity.deliveryLatitude,
      deliveryLongitude: entity.deliveryLongitude,
      deliveryInstructions: entity.deliveryInstructions,
      driverId: entity.driverId,
      driverName: entity.driverName,
      driverPhone: entity.driverPhone,
      createdAt: entity.createdAt,
      confirmedAt: entity.confirmedAt,
      preparingAt: entity.preparingAt,
      readyAt: entity.readyAt,
      pickedUpAt: entity.pickedUpAt,
      deliveredAt: entity.deliveredAt,
      cancelledAt: entity.cancelledAt,
      cancellationReason: entity.cancellationReason,
      estimatedDeliveryTime: entity.estimatedDeliveryTime,
      promoCode: entity.promoCode,
    );
  }

  OrderEntity toEntity() => this;
}
