import 'dart:convert';

class DeliveryLocation {
  final double latitude;
  final double longitude;
  final String label;
  final String formattedAddress;
  final bool isLiveLocation;
  final DateTime updatedAt;

  const DeliveryLocation({
    required this.latitude,
    required this.longitude,
    required this.label,
    required this.formattedAddress,
    required this.isLiveLocation,
    required this.updatedAt,
  });

  DeliveryLocation copyWith({
    double? latitude,
    double? longitude,
    String? label,
    String? formattedAddress,
    bool? isLiveLocation,
    DateTime? updatedAt,
  }) {
    return DeliveryLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      label: label ?? this.label,
      formattedAddress: formattedAddress ?? this.formattedAddress,
      isLiveLocation: isLiveLocation ?? this.isLiveLocation,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'label': label,
      'formattedAddress': formattedAddress,
      'isLiveLocation': isLiveLocation,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeliveryLocation.fromMap(Map<String, dynamic> map) {
    return DeliveryLocation(
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      label: map['label'] as String? ?? 'Current Location',
      formattedAddress: map['formattedAddress'] as String? ?? '',
      isLiveLocation: map['isLiveLocation'] as bool? ?? false,
      updatedAt: DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryLocation.fromJson(String source) =>
      DeliveryLocation.fromMap(json.decode(source) as Map<String, dynamic>);
}
