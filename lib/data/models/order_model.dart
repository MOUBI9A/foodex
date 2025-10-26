// Rich order domain model with tracking metadata for FoodEx.

enum OrderStatus {
  pending,
  preparing,
  readyForPickup,
  onTheWay,
  delivered,
  cancelled,
}

class Order {
  final String id;
  final String customerId;
  final String chefId;
  final String? courierId;
  final List<OrderedDish> items;
  final DeliveryAddress deliveryAddress;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? readyAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final String? cancellationReason;
  final TrackingInfo tracking;

  const Order({
    required this.id,
    required this.customerId,
    required this.chefId,
    required this.items,
    required this.deliveryAddress,
    required this.status,
    required this.createdAt,
    required this.tracking,
    this.courierId,
    this.acceptedAt,
    this.readyAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancellationReason,
  });

  Order copyWith({
    String? id,
    String? customerId,
    String? chefId,
    String? courierId,
    List<OrderedDish>? items,
    DeliveryAddress? deliveryAddress,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? readyAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    String? cancellationReason,
    TrackingInfo? tracking,
  }) {
    return Order(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      chefId: chefId ?? this.chefId,
      courierId: courierId ?? this.courierId,
      items: items ?? this.items,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      readyAt: readyAt ?? this.readyAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      tracking: tracking ?? this.tracking,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      chefId: json['chefId'] as String,
      courierId: json['courierId'] as String?,
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderedDish.fromJson(item as Map<String, dynamic>))
          .toList(),
      deliveryAddress:
          DeliveryAddress.fromJson(json['deliveryAddress'] as Map<String, dynamic>),
      status: OrderStatus.values.firstWhere(
        (value) => value.name == (json['status'] as String? ?? OrderStatus.pending.name),
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt'] as String) : null,
      readyAt: json['readyAt'] != null ? DateTime.parse(json['readyAt'] as String) : null,
      pickedUpAt: json['pickedUpAt'] != null ? DateTime.parse(json['pickedUpAt'] as String) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt'] as String) : null,
      cancellationReason: json['cancellationReason'] as String?,
      tracking: TrackingInfo.fromJson(json['tracking'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerId': customerId,
        'chefId': chefId,
        'courierId': courierId,
        'items': items.map((item) => item.toJson()).toList(),
        'deliveryAddress': deliveryAddress.toJson(),
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'acceptedAt': acceptedAt?.toIso8601String(),
        'readyAt': readyAt?.toIso8601String(),
        'pickedUpAt': pickedUpAt?.toIso8601String(),
        'deliveredAt': deliveredAt?.toIso8601String(),
        'cancellationReason': cancellationReason,
        'tracking': tracking.toJson(),
      };
}

class OrderedDish {
  final String dishId;
  final String dishName;
  final int quantity;
  final List<String> customNotes;

  const OrderedDish({
    required this.dishId,
    required this.dishName,
    required this.quantity,
    this.customNotes = const [],
  });

  factory OrderedDish.fromJson(Map<String, dynamic> json) => OrderedDish(
        dishId: json['dishId'] as String,
        dishName: json['dishName'] as String,
        quantity: json['quantity'] as int,
        customNotes: (json['customNotes'] as List<dynamic>?)
                ?.map((note) => note.toString())
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'dishId': dishId,
        'dishName': dishName,
        'quantity': quantity,
        'customNotes': customNotes,
      };
}

class DeliveryAddress {
  final String street;
  final String city;
  final double lat;
  final double lng;
  final String contactName;
  final String contactPhone;
  final String? notes;

  const DeliveryAddress({
    required this.street,
    required this.city,
    required this.lat,
    required this.lng,
    required this.contactName,
    required this.contactPhone,
    this.notes,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        street: json['street'] as String,
        city: json['city'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        contactName: json['contactName'] as String,
        contactPhone: json['contactPhone'] as String,
        notes: json['notes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'lat': lat,
        'lng': lng,
        'contactName': contactName,
        'contactPhone': contactPhone,
        'notes': notes,
      };
}

class TrackingInfo {
  final double? courierLat;
  final double? courierLng;
  final int? etaMinutesRemaining;
  final double? distanceMetersRemaining;
  final DateTime? lastUpdate;

  const TrackingInfo({
    this.courierLat,
    this.courierLng,
    this.etaMinutesRemaining,
    this.distanceMetersRemaining,
    this.lastUpdate,
  });

  TrackingInfo copyWith({
    double? courierLat,
    double? courierLng,
    int? etaMinutesRemaining,
    double? distanceMetersRemaining,
    DateTime? lastUpdate,
  }) {
    return TrackingInfo(
      courierLat: courierLat ?? this.courierLat,
      courierLng: courierLng ?? this.courierLng,
      etaMinutesRemaining: etaMinutesRemaining ?? this.etaMinutesRemaining,
      distanceMetersRemaining: distanceMetersRemaining ?? this.distanceMetersRemaining,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  factory TrackingInfo.fromJson(Map<String, dynamic> json) => TrackingInfo(
        courierLat: (json['courierLat'] as num?)?.toDouble(),
        courierLng: (json['courierLng'] as num?)?.toDouble(),
        etaMinutesRemaining: json['etaMinutesRemaining'] as int?,
        distanceMetersRemaining: (json['distanceMetersRemaining'] as num?)?.toDouble(),
        lastUpdate:
            json['lastUpdate'] != null ? DateTime.parse(json['lastUpdate'] as String) : null,
      );

  Map<String, dynamic> toJson() => {
        'courierLat': courierLat,
        'courierLng': courierLng,
        'etaMinutesRemaining': etaMinutesRemaining,
        'distanceMetersRemaining': distanceMetersRemaining,
        'lastUpdate': lastUpdate?.toIso8601String(),
      };
}
