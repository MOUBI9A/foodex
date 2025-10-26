import '../models/courier.dart';

abstract class CourierRepository {
  Future<List<Courier>> fetchCouriers();
}

class MockCourierRepository implements CourierRepository {
  @override
  Future<List<Courier>> fetchCouriers() async {
    final now = DateTime.now();
    return [
      Courier(
        id: 'courier_001',
        name: 'Youssef Benali',
        phone: '+2126000001',
        vehicleType: 'bike',
        status: 'online',
        lat: 33.5899,
        lng: -7.6039,
        batteryLevel: 78,
        deliveriesCompleted: 182,
        rating: 4.9,
        lastActiveAt: now.subtract(const Duration(minutes: 5)),
      ),
      Courier(
        id: 'courier_002',
        name: 'Sara Lahrichi',
        phone: '+2126000002',
        vehicleType: 'moto',
        status: 'busy',
        lat: 33.595,
        lng: -7.6201,
        batteryLevel: 56,
        deliveriesCompleted: 254,
        rating: 4.7,
        lastActiveAt: now.subtract(const Duration(minutes: 2)),
        currentOrderId: 'order_002',
      ),
      Courier(
        id: 'courier_003',
        name: 'Rachid Essafi',
        phone: '+2126000003',
        vehicleType: 'car',
        status: 'offline',
        batteryLevel: 34,
        deliveriesCompleted: 96,
        rating: 4.8,
        lastActiveAt: now.subtract(const Duration(hours: 2)),
      ),
    ];
  }
}
