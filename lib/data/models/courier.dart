// Courier domain model powering courier/admin flows.
const _unset = Object();

class Courier {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String status; // online | busy | offline
  final double? lat;
  final double? lng;
  final int batteryLevel;
  final int deliveriesCompleted;
  final double rating;
  final DateTime lastActiveAt;
  final String? currentOrderId;

  const Courier({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.status,
    required this.batteryLevel,
    required this.deliveriesCompleted,
    required this.rating,
    required this.lastActiveAt,
    this.lat,
    this.lng,
    this.currentOrderId,
  });

  Courier copyWith({
    String? status,
    double? lat,
    double? lng,
    int? batteryLevel,
    int? deliveriesCompleted,
    double? rating,
    DateTime? lastActiveAt,
    Object? currentOrderId = _unset,
  }) {
    return Courier(
      id: id,
      name: name,
      phone: phone,
      vehicleType: vehicleType,
      status: status ?? this.status,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      deliveriesCompleted: deliveriesCompleted ?? this.deliveriesCompleted,
      rating: rating ?? this.rating,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      currentOrderId: currentOrderId == _unset ? this.currentOrderId : currentOrderId as String?,
    );
  }

  factory Courier.fromJson(Map<String, dynamic> json) => Courier(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        vehicleType: json['vehicleType'] as String,
        status: json['status'] as String,
        lat: (json['lat'] as num?)?.toDouble(),
        lng: (json['lng'] as num?)?.toDouble(),
        batteryLevel: (json['batteryLevel'] as num).toInt(),
        deliveriesCompleted: (json['deliveriesCompleted'] as num).toInt(),
        rating: (json['rating'] as num).toDouble(),
        lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
        currentOrderId: json['currentOrderId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'vehicleType': vehicleType,
        'status': status,
        'lat': lat,
        'lng': lng,
        'batteryLevel': batteryLevel,
        'deliveriesCompleted': deliveriesCompleted,
        'rating': rating,
        'lastActiveAt': lastActiveAt.toIso8601String(),
        'currentOrderId': currentOrderId,
      };
}
