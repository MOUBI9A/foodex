import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/admin/providers/dashboard_provider.dart';

void main() {
  test('Dashboard overview provider returns mock data', () async {
    final container = ProviderContainer();
    final overview = await container.read(dashboardOverviewProvider.future);
    expect(overview.activeOrders, greaterThan(0));
    expect(overview.totalCustomers, greaterThan(0));
    expect(overview.revenueToday, greaterThan(0));
    expect(overview.revenueThisMonth, greaterThan(0));
  });
}
