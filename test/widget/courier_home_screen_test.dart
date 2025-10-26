import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/courier/screens/courier_home_screen.dart';
import 'package:food_delivery/core/providers/courier_providers.dart';
import 'package:food_delivery/core/providers/order_providers.dart';
import 'package:food_delivery/data/models/courier.dart';
import 'package:food_delivery/data/models/order_model.dart';
import 'package:food_delivery/data/repositories/courier_repository.dart';

class _StubOrderNotifier extends OrderListNotifier {
  _StubOrderNotifier({required super.ref, required List<Order> seed}) {
    state = seed;
  }
}

class _FakeCourierRepository implements CourierRepository {
  _FakeCourierRepository(this._seed);
  final List<Courier> _seed;

  @override
  Future<List<Courier>> fetchCouriers() async => _seed;
}

void main() {
  testWidgets('CourierHomeScreen shows active order', (tester) async {
    final courier = Courier(
      id: 'c1',
      name: 'Nabil',
      phone: '+2126',
      vehicleType: 'bike',
      status: 'online',
      batteryLevel: 80,
      deliveriesCompleted: 40,
      rating: 4.9,
      lastActiveAt: DateTime.now(),
    );
    final order = Order(
      id: 'order_test',
      customerId: 'customer_001',
      chefId: 'chef_1',
      courierId: 'c1',
      items: const [OrderedDish(dishId: 'dish', dishName: 'Wrap', quantity: 1)],
      deliveryAddress: const DeliveryAddress(
        street: '1 Rue Example',
        city: 'Casablanca',
        lat: 0,
        lng: 0,
        contactName: 'Aya',
        contactPhone: '0600000',
      ),
      status: OrderStatus.readyForPickup,
      createdAt: DateTime.now(),
      tracking: const TrackingInfo(etaMinutesRemaining: 20, distanceMetersRemaining: 1500),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          courierRepositoryProvider.overrideWithValue(_FakeCourierRepository([courier])),
          orderListProvider.overrideWith((ref) => _StubOrderNotifier(ref: ref, seed: [order])),
        ],
        child: const MaterialApp(home: CourierHomeScreen(courierId: 'c1')),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.textContaining('order_test'), findsOneWidget);
    expect(find.textContaining('Nabil'), findsOneWidget);
  });
}
