import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/delivery_estimate_service.dart';
import '../services/dish_safety_service.dart';

final dishSafetyServiceProvider = Provider<DishSafetyService>((ref) {
  return DishSafetyService();
});

final deliveryEstimateServiceProvider = Provider<DeliveryEstimateService>((ref) {
  return DeliveryEstimateService();
});
