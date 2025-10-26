import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/dashboard_overview.dart';

final dashboardOverviewProvider = FutureProvider<DashboardOverview>((ref) async {
  // Mocked admin overview; replace with repository call later.
  await Future<void>.delayed(const Duration(milliseconds: 200));
  return const DashboardOverview(
    activeOrders: 42,
    totalCustomers: 1280,
    revenueToday: 256.75,
    revenueThisMonth: 9325.40,
  );
});
