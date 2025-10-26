import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/core/providers/courier_providers.dart';

Future<void> _waitForCouriers(ProviderContainer container) async {
  for (var i = 0; i < 10; i++) {
    if (container.read(courierListProvider).isNotEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  test('Courier provider updates status and order linkage', () async {
    final container = ProviderContainer();
    await _waitForCouriers(container);
    final notifier = container.read(courierListProvider.notifier);

    notifier.setStatus('courier_001', 'busy');
    var courier = container.read(courierListProvider).firstWhere((c) => c.id == 'courier_001');
    expect(courier.status, 'busy');

    notifier.attachOrder('courier_001', 'order_x');
    courier = container.read(courierListProvider).firstWhere((c) => c.id == 'courier_001');
    expect(courier.currentOrderId, 'order_x');

    notifier.clearOrder('courier_001');
    courier = container.read(courierListProvider).firstWhere((c) => c.id == 'courier_001');
    expect(courier.currentOrderId, isNull);
    expect(courier.status, 'online');
  });
}
