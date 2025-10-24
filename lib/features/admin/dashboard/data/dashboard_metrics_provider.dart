import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dashboard Metrics Data Models
class DashboardMetrics {
  final int totalOrders;
  final double totalRevenue;
  final int activeChefs;
  final int activeCouriers;
  final double dailyGrowth;
  final double ordersGrowth;
  final double revenueGrowth;
  final double chefsGrowth;
  final double couriersGrowth;
  final List<RevenueData> weeklyRevenue;
  final List<ChefData> topChefs;
  final OrdersStatusData ordersStatus;

  DashboardMetrics({
    required this.totalOrders,
    required this.totalRevenue,
    required this.activeChefs,
    required this.activeCouriers,
    required this.dailyGrowth,
    required this.ordersGrowth,
    required this.revenueGrowth,
    required this.chefsGrowth,
    required this.couriersGrowth,
    required this.weeklyRevenue,
    required this.topChefs,
    required this.ordersStatus,
  });
}

class RevenueData {
  final String day;
  final double revenue;
  final int orders;
  final int newUsers;

  RevenueData({
    required this.day,
    required this.revenue,
    required this.orders,
    required this.newUsers,
  });
}

class ChefData {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final int completedOrders;
  final double totalRevenue;

  ChefData({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.completedOrders,
    required this.totalRevenue,
  });
}

class OrdersStatusData {
  final int pending;
  final int inProgress;
  final int delivered;
  final int cancelled;

  OrdersStatusData({
    required this.pending,
    required this.inProgress,
    required this.delivered,
    required this.cancelled,
  });

  int get total => pending + inProgress + delivered + cancelled;

  double get pendingPercentage => total > 0 ? (pending / total) * 100 : 0;
  double get inProgressPercentage => total > 0 ? (inProgress / total) * 100 : 0;
  double get deliveredPercentage => total > 0 ? (delivered / total) * 100 : 0;
  double get cancelledPercentage => total > 0 ? (cancelled / total) * 100 : 0;
}

/// Dashboard Metrics Provider
///
/// Provides mock data for the admin dashboard.
/// In Phase 4.3, this will be replaced with real API calls.
final dashboardMetricsProvider = Provider<DashboardMetrics>((ref) {
  return _getMockDashboardData();
});

/// Chart Data Type (Revenue, Orders, or New Users)
enum ChartDataType { revenue, orders, newUsers }

/// Selected Chart Data Type Provider
final selectedChartTypeProvider = StateProvider<ChartDataType>((ref) {
  return ChartDataType.revenue;
});

/// Get mock dashboard data
/// TODO: Replace with API call in Phase 4.3
DashboardMetrics _getMockDashboardData() {
  return DashboardMetrics(
    totalOrders: 12847,
    totalRevenue: 284950.50,
    activeChefs: 156,
    activeCouriers: 89,
    dailyGrowth: 12.5,
    ordersGrowth: 8.3,
    revenueGrowth: 15.7,
    chefsGrowth: 5.2,
    couriersGrowth: 3.8,
    weeklyRevenue: [
      RevenueData(day: 'Mon', revenue: 38500, orders: 1820, newUsers: 45),
      RevenueData(day: 'Tue', revenue: 42300, orders: 1950, newUsers: 52),
      RevenueData(day: 'Wed', revenue: 39800, orders: 1890, newUsers: 48),
      RevenueData(day: 'Thu', revenue: 45200, orders: 2100, newUsers: 61),
      RevenueData(day: 'Fri', revenue: 48900, orders: 2280, newUsers: 68),
      RevenueData(day: 'Sat', revenue: 52400, orders: 2450, newUsers: 74),
      RevenueData(day: 'Sun', revenue: 47850, orders: 2200, newUsers: 58),
    ],
    topChefs: [
      ChefData(
        id: '1',
        name: 'Chef Marco Rossi',
        imageUrl: 'https://i.pravatar.cc/150?img=12',
        rating: 4.9,
        completedOrders: 1847,
        totalRevenue: 45820.50,
      ),
      ChefData(
        id: '2',
        name: 'Chef Sofia Chen',
        imageUrl: 'https://i.pravatar.cc/150?img=45',
        rating: 4.8,
        completedOrders: 1652,
        totalRevenue: 42100.00,
      ),
      ChefData(
        id: '3',
        name: 'Chef Ahmed Hassan',
        imageUrl: 'https://i.pravatar.cc/150?img=33',
        rating: 4.8,
        completedOrders: 1589,
        totalRevenue: 39750.25,
      ),
      ChefData(
        id: '4',
        name: 'Chef Emma Johnson',
        imageUrl: 'https://i.pravatar.cc/150?img=24',
        rating: 4.7,
        completedOrders: 1423,
        totalRevenue: 37200.00,
      ),
      ChefData(
        id: '5',
        name: 'Chef Hiroshi Tanaka',
        imageUrl: 'https://i.pravatar.cc/150?img=51',
        rating: 4.7,
        completedOrders: 1398,
        totalRevenue: 36500.75,
      ),
      ChefData(
        id: '6',
        name: 'Chef Isabella Garcia',
        imageUrl: 'https://i.pravatar.cc/150?img=47',
        rating: 4.6,
        completedOrders: 1276,
        totalRevenue: 34100.00,
      ),
      ChefData(
        id: '7',
        name: 'Chef Lucas Schmidt',
        imageUrl: 'https://i.pravatar.cc/150?img=68',
        rating: 4.6,
        completedOrders: 1189,
        totalRevenue: 31800.50,
      ),
      ChefData(
        id: '8',
        name: 'Chef Priya Patel',
        imageUrl: 'https://i.pravatar.cc/150?img=29',
        rating: 4.5,
        completedOrders: 1145,
        totalRevenue: 29900.00,
      ),
      ChefData(
        id: '9',
        name: 'Chef Jean-Pierre Dubois',
        imageUrl: 'https://i.pravatar.cc/150?img=56',
        rating: 4.5,
        completedOrders: 1098,
        totalRevenue: 28400.25,
      ),
      ChefData(
        id: '10',
        name: 'Chef Maria Santos',
        imageUrl: 'https://i.pravatar.cc/150?img=38',
        rating: 4.4,
        completedOrders: 1034,
        totalRevenue: 26750.00,
      ),
    ],
    ordersStatus: OrdersStatusData(
      pending: 245,
      inProgress: 389,
      delivered: 11847,
      cancelled: 366,
    ),
  );
}
