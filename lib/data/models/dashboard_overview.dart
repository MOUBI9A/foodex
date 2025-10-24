/// Dashboard overview model containing key metrics
/// Used for displaying high-level statistics in admin dashboard
class DashboardOverview {
  final int ordersToday;
  final double revenueToday;
  final int activeChefs;
  final double avgPrepTime;
  final double ordersTrend; // Percentage change from yesterday
  final double revenueTrend; // Percentage change from yesterday
  final int activeChefsTrend; // Change count from yesterday
  final double prepTimeTrend; // Percentage change from yesterday

  const DashboardOverview({
    required this.ordersToday,
    required this.revenueToday,
    required this.activeChefs,
    required this.avgPrepTime,
    this.ordersTrend = 0,
    this.revenueTrend = 0,
    this.activeChefsTrend = 0,
    this.prepTimeTrend = 0,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      ordersToday: json['ordersToday'] ?? 0,
      revenueToday: (json['revenueToday'] ?? 0).toDouble(),
      activeChefs: json['activeChefs'] ?? 0,
      avgPrepTime: (json['avgPrepTime'] ?? 0).toDouble(),
      ordersTrend: (json['ordersTrend'] ?? 0).toDouble(),
      revenueTrend: (json['revenueTrend'] ?? 0).toDouble(),
      activeChefsTrend: json['activeChefsTrend'] ?? 0,
      prepTimeTrend: (json['prepTimeTrend'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ordersToday': ordersToday,
      'revenueToday': revenueToday,
      'activeChefs': activeChefs,
      'avgPrepTime': avgPrepTime,
      'ordersTrend': ordersTrend,
      'revenueTrend': revenueTrend,
      'activeChefsTrend': activeChefsTrend,
      'prepTimeTrend': prepTimeTrend,
    };
  }

  factory DashboardOverview.empty() => const DashboardOverview(
        ordersToday: 0,
        revenueToday: 0,
        activeChefs: 0,
        avgPrepTime: 0,
      );

  DashboardOverview copyWith({
    int? ordersToday,
    double? revenueToday,
    int? activeChefs,
    double? avgPrepTime,
    double? ordersTrend,
    double? revenueTrend,
    int? activeChefsTrend,
    double? prepTimeTrend,
  }) {
    return DashboardOverview(
      ordersToday: ordersToday ?? this.ordersToday,
      revenueToday: revenueToday ?? this.revenueToday,
      activeChefs: activeChefs ?? this.activeChefs,
      avgPrepTime: avgPrepTime ?? this.avgPrepTime,
      ordersTrend: ordersTrend ?? this.ordersTrend,
      revenueTrend: revenueTrend ?? this.revenueTrend,
      activeChefsTrend: activeChefsTrend ?? this.activeChefsTrend,
      prepTimeTrend: prepTimeTrend ?? this.prepTimeTrend,
    );
  }
}
