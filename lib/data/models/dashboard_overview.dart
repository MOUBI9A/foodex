// DashboardOverview model with Hive adapter.
import 'package:hive/hive.dart';

part 'dashboard_overview.g.dart';

@HiveType(typeId: 7)
class DashboardOverview {
  @HiveField(0)
  final int activeOrders;
  @HiveField(1)
  final int totalCustomers;
  @HiveField(2)
  final double revenueToday;
  @HiveField(3)
  final double revenueThisMonth;

  const DashboardOverview({
    required this.activeOrders,
    required this.totalCustomers,
    required this.revenueToday,
    required this.revenueThisMonth,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) =>
      DashboardOverview(
        activeOrders: (json['activeOrders'] as num).toInt(),
        totalCustomers: (json['totalCustomers'] as num).toInt(),
        revenueToday: (json['revenueToday'] as num).toDouble(),
        revenueThisMonth: (json['revenueThisMonth'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'activeOrders': activeOrders,
        'totalCustomers': totalCustomers,
        'revenueToday': revenueToday,
        'revenueThisMonth': revenueThisMonth,
      };
}
