import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/courier.dart';
import '../../data/repositories/courier_repository.dart';

final courierRepositoryProvider = Provider<CourierRepository>((ref) {
  return MockCourierRepository();
});

final courierListProvider = StateNotifierProvider<CourierListNotifier, List<Courier>>((ref) {
  return CourierListNotifier(ref: ref);
});

class CourierListNotifier extends StateNotifier<List<Courier>> {
  CourierListNotifier({required this.ref}) : super(const []) {
    _bootstrap();
  }

  final Ref ref;

  Future<void> _bootstrap() async {
    final repo = ref.read(courierRepositoryProvider);
    final couriers = await repo.fetchCouriers();
    state = couriers;
  }

  void setStatus(String courierId, String status) {
    _updateCourier(
      courierId,
      (courier) => courier.copyWith(status: status, lastActiveAt: DateTime.now()),
    );
  }

  void updateLocation(String courierId, double lat, double lng) {
    _updateCourier(
      courierId,
      (courier) => courier.copyWith(
        lat: lat,
        lng: lng,
        lastActiveAt: DateTime.now(),
      ),
    );
  }

  void attachOrder(String courierId, String orderId) {
    _updateCourier(
      courierId,
      (courier) => courier.copyWith(
        status: 'busy',
        lastActiveAt: DateTime.now(),
        currentOrderId: orderId,
      ),
    );
  }

  void clearOrder(String courierId) {
    _updateCourier(
      courierId,
      (courier) => courier.copyWith(
        status: 'online',
        lastActiveAt: DateTime.now(),
        currentOrderId: null,
      ),
    );
  }

  void _updateCourier(String courierId, Courier Function(Courier) update) {
    state = [
      for (final courier in state)
        if (courier.id == courierId) update(courier) else courier,
    ];
  }
}
