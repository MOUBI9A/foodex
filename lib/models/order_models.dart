class Order {
  final String id;
  final String customerId;
  final String chefId;
  final String? courierId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double total;
  final String currency;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String deliveryAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? readyAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final int estimatedPreparationTime;
  final String? cancellationReason;

  Order({
    required this.id,
    required this.customerId,
    required this.chefId,
    this.courierId,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.total,
    this.currency = 'MAD',
    required this.status,
    required this.paymentStatus,
    required this.deliveryAddress,
    this.notes,
    required this.createdAt,
    this.acceptedAt,
    this.readyAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.estimatedPreparationTime = 30,
    this.cancellationReason,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerId: json['customer_id'],
      chefId: json['chef_id'],
      courierId: json['courier_id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['delivery_fee'].toDouble(),
      serviceFee: json['service_fee'].toDouble(),
      total: json['total'].toDouble(),
      currency: json['currency'] ?? 'MAD',
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['payment_status'],
      ),
      deliveryAddress: json['delivery_address'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['created_at']),
      acceptedAt: json['accepted_at'] != null
          ? DateTime.parse(json['accepted_at'])
          : null,
      readyAt:
          json['ready_at'] != null ? DateTime.parse(json['ready_at']) : null,
      pickedUpAt: json['picked_up_at'] != null
          ? DateTime.parse(json['picked_up_at'])
          : null,
      deliveredAt: json['delivered_at'] != null
          ? DateTime.parse(json['delivered_at'])
          : null,
      estimatedPreparationTime: json['estimated_preparation_time'] ?? 30,
      cancellationReason: json['cancellation_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'chef_id': chefId,
      'courier_id': courierId,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'delivery_fee': deliveryFee,
      'service_fee': serviceFee,
      'total': total,
      'currency': currency,
      'status': status.toString().split('.').last,
      'payment_status': paymentStatus.toString().split('.').last,
      'delivery_address': deliveryAddress,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'accepted_at': acceptedAt?.toIso8601String(),
      'ready_at': readyAt?.toIso8601String(),
      'picked_up_at': pickedUpAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'estimated_preparation_time': estimatedPreparationTime,
      'cancellation_reason': cancellationReason,
    };
  }
}

class OrderItem {
  final String dishId;
  final String dishName;
  final double price;
  final int quantity;
  final String? specialInstructions;

  OrderItem({
    required this.dishId,
    required this.dishName,
    required this.price,
    required this.quantity,
    this.specialInstructions,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      dishId: json['dish_id'],
      dishName: json['dish_name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      specialInstructions: json['special_instructions'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish_id': dishId,
      'dish_name': dishName,
      'price': price,
      'quantity': quantity,
      'special_instructions': specialInstructions,
    };
  }

  double get total => price * quantity;
}

enum OrderStatus {
  pending, // Waiting for chef acceptance
  accepted, // Chef accepted, preparing
  preparing, // Chef is cooking
  ready, // Food is ready for pickup
  pickedUp, // Courier picked up
  onTheWay, // Courier delivering
  delivered, // Order completed
  cancelled, // Order cancelled
  rejected, // Chef rejected
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}

class Courier {
  final String id;
  final String userId;
  final String vehicleType;
  final String vehicleNumber;
  final String licenseNumber;
  final bool isOnline;
  final bool isAvailable;
  final double rating;
  final int reviewCount;
  final int totalDeliveries;
  final DateTime joinedAt;
  final CourierLocation? currentLocation;

  Courier({
    required this.id,
    required this.userId,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.licenseNumber,
    this.isOnline = false,
    this.isAvailable = false,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.totalDeliveries = 0,
    required this.joinedAt,
    this.currentLocation,
  });

  factory Courier.fromJson(Map<String, dynamic> json) {
    return Courier(
      id: json['id'],
      userId: json['user_id'],
      vehicleType: json['vehicle_type'],
      vehicleNumber: json['vehicle_number'],
      licenseNumber: json['license_number'],
      isOnline: json['is_online'] ?? false,
      isAvailable: json['is_available'] ?? false,
      rating: json['rating'].toDouble(),
      reviewCount: json['review_count'] ?? 0,
      totalDeliveries: json['total_deliveries'] ?? 0,
      joinedAt: DateTime.parse(json['joined_at']),
      currentLocation: json['current_location'] != null
          ? CourierLocation.fromJson(json['current_location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'vehicle_type': vehicleType,
      'vehicle_number': vehicleNumber,
      'license_number': licenseNumber,
      'is_online': isOnline,
      'is_available': isAvailable,
      'rating': rating,
      'review_count': reviewCount,
      'total_deliveries': totalDeliveries,
      'joined_at': joinedAt.toIso8601String(),
      'current_location': currentLocation?.toJson(),
    };
  }
}

class CourierLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  CourierLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  factory CourierLocation.fromJson(Map<String, dynamic> json) {
    return CourierLocation(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
