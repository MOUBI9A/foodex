import 'dart:math';

class DeliveryEstimate {
  final int prepMinutes;
  final int travelMinutes;

  const DeliveryEstimate({
    required this.prepMinutes,
    required this.travelMinutes,
  });

  int get totalMinutes => prepMinutes + travelMinutes;
}

class DeliveryEstimateService {
  DeliveryEstimate estimate({
    required int prepMinutes,
    required double chefLat,
    required double chefLng,
    required double destLat,
    required double destLng,
  }) {
    final travel = estimateTravelMinutes(chefLat, chefLng, destLat, destLng);
    return DeliveryEstimate(prepMinutes: prepMinutes, travelMinutes: travel);
  }

  int estimateTravelMinutes(
    double chefLat,
    double chefLng,
    double destLat,
    double destLng,
  ) {
    final distanceKm = _haversineKm(chefLat, chefLng, destLat, destLng);
    final minutes = max(5, (distanceKm * 4).round());
    return minutes;
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const earthRadiusKm = 6371.0;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180.0);
}
