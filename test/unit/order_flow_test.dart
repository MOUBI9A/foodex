import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/providers/order_providers.dart';
import 'package:food_delivery/core/providers/courier_providers.dart';
import 'package:food_delivery/data/models/order_model.dart';
import '../test_helpers/mock_path_provider.dart';

Future<void> _waitForCouriers(ProviderContainer container) async {
  for (var i = 0; i < 10; i++) {
    if (container.read(courierListProvider).isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  test('Order lifecycle transitions through chef and courier actions', () async {
    await setUpMockPathProvider();
    final container = ProviderContainer();
    await _waitForCouriers(container);
    final notifier = container.read(orderListProvider.notifier);
    const orderId = 'order_003';

    await notifier.chefAcceptOrder(orderId);
    var order = container.read(orderListProvider).firstWhere((o) => o.id == orderId);
    expect(order.status, OrderStatus.preparing);

    await notifier.chefMarkReady(orderId);
    order = container.read(orderListProvider).firstWhere((o) => o.id == orderId);
    expect(order.status, OrderStatus.readyForPickup);

    await notifier.assignCourier(orderId, 'courier_001');
    order = container.read(orderListProvider).firstWhere((o) => o.id == orderId);
    expect(order.courierId, 'courier_001');

    await notifier.courierMarkPickedUp(orderId);
    order = container.read(orderListProvider).firstWhere((o) => o.id == orderId);
    expect(order.status, OrderStatus.onTheWay);

    await notifier.courierMarkDelivered(orderId);
    order = container.read(orderListProvider).firstWhere((o) => o.id == orderId);
    expect(order.status, OrderStatus.delivered);
  });
}
