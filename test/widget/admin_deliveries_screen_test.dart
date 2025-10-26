import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/admin/screens/admin_deliveries_screen.dart';
import 'package:food_delivery/core/providers/order_providers.dart';
import 'package:food_delivery/core/providers/courier_providers.dart';
import 'package:food_delivery/data/models/order_model.dart';
import 'package:food_delivery/data/models/courier.dart';
import 'package:food_delivery/data/repositories/courier_repository.dart';

class _StubOrderNotifier extends OrderListNotifier {
  _StubOrderNotifier({required Ref ref, required List<Order> seed}) : super(ref: ref) {
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
  testWidgets('Admin deliveries table lists pending assignments', (tester) async {
    final order = Order(
      id: 'order_admin',
      customerId: 'cust',
      chefId: 'chefA',
      items: const [OrderedDish(dishId: 'dish', dishName: 'Pastilla', quantity: 1)],
      deliveryAddress: const DeliveryAddress(
        street: '10 Rue Atlas',
        city: 'Rabat',
        lat: 0,
        lng: 0,
        contactName: 'Karim',
        contactPhone: '0700000',
      ),
      status: OrderStatus.readyForPickup,
      createdAt: DateTime.now(),
      tracking: const TrackingInfo(etaMinutesRemaining: 18, distanceMetersRemaining: 2200),
    );
    final courier = Courier(
      id: 'courier_x',
      name: 'Laila',
      phone: '0600',
      vehicleType: 'moto',
      status: 'online',
      batteryLevel: 70,
      deliveriesCompleted: 90,
      rating: 4.7,
      lastActiveAt: DateTime.now(),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          orderListProvider.overrideWith((ref) => _StubOrderNotifier(ref: ref, seed: [order])),
          courierRepositoryProvider.overrideWithValue(_FakeCourierRepository([courier])),
        ],
        child: const MaterialApp(home: AdminDeliveriesScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('order_admin'), findsOneWidget);
    expect(find.textContaining('Rabat'), findsOneWidget);
    expect(find.text('Choisir'), findsOneWidget);
  });
}
