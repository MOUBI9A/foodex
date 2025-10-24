import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/color_system_v2.dart';
import 'data/admin_analytics_provider.dart';
import 'widgets/overview_card.dart';
import 'widgets/pie_chart_storage.dart';
import 'widgets/line_chart_usage.dart';
import 'widgets/bar_chart_waste.dart';
import 'widgets/ingredient_analytics_table.dart';

/// Admin Dashboard Screen with Analytics and Charts
class AdminDashboardScreen extends ConsumerWidget {
  final String chefId;

  const AdminDashboardScreen({
    super.key,
    required this.chefId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(adminAnalyticsProvider(chefId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: TColorV2.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(adminAnalyticsProvider(chefId));
            },
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: analyticsAsync.when(
        data: (analytics) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Header
              Row(
                children: [
                  Icon(
                    Icons.dashboard,
                    size: 32,
                    color: TColorV2.primary,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory Analytics',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: TColorV2.textPrimary,
                        ),
                      ),
                      Text(
                        'Real-time insights and performance metrics',
                        style: TextStyle(
                          fontSize: 14,
                          color: TColorV2.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // KPI Overview Cards
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  OverviewCard(
                    title: 'Total Ingredients',
                    value: analytics.totalIngredients.toString(),
                    icon: Icons.inventory_2,
                    color: TColorV2.primary,
                    subtitle:
                        '${analytics.healthyStockCount} in good condition',
                  ),
                  OverviewCard(
                    title: 'Low Stock',
                    value: analytics.lowStockCount.toString(),
                    icon: Icons.warning_amber,
                    color: TColorV2.warning,
                    subtitle: 'Need restocking',
                  ),
                  OverviewCard(
                    title: 'Expiring Soon',
                    value: analytics.expiringSoonCount.toString(),
                    icon: Icons.access_time,
                    color: Colors.orange,
                    subtitle: 'Within 2 days',
                  ),
                  OverviewCard(
                    title: 'Expired',
                    value: analytics.expiredCount.toString(),
                    icon: Icons.dangerous,
                    color: TColorV2.error,
                    subtitle: 'Requires attention',
                  ),
                  OverviewCard(
                    title: 'Inventory Value',
                    value:
                        '\$${analytics.totalInventoryValue.toStringAsFixed(0)}',
                    icon: Icons.attach_money,
                    color: TColorV2.success,
                    subtitle: 'Total asset value',
                  ),
                  OverviewCard(
                    title: 'Avg Freshness',
                    value: '${analytics.averageFreshness.toStringAsFixed(0)}%',
                    icon: Icons.eco,
                    color: _getFreshnessColor(analytics.averageFreshness),
                    subtitle: 'Overall quality',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Charts Section
              Text(
                'Trend Analysis',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TColorV2.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Line Chart and Bar Chart
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1200) {
                    // Desktop: Side by side
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LineChartUsage(
                            usageTrends: analytics.usageTrends,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: BarChartWaste(
                            wasteByCategory: analytics.wasteByCategory,
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Mobile/Tablet: Stacked
                    return Column(
                      children: [
                        LineChartUsage(
                          usageTrends: analytics.usageTrends,
                        ),
                        const SizedBox(height: 16),
                        BarChartWaste(
                          wasteByCategory: analytics.wasteByCategory,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 32),

              // Pie Chart
              PieChartStorage(
                storageDistribution: analytics.storageDistribution,
              ),
              const SizedBox(height: 32),

              // Ingredient Table
              Text(
                'Detailed Inventory',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: TColorV2.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              IngredientAnalyticsTable(
                ingredients: analytics.ingredients,
              ),
            ],
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: TColorV2.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: TColorV2.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: TColorV2.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(adminAnalyticsProvider(chefId));
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColorV2.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getFreshnessColor(double freshness) {
    if (freshness >= 70) return TColorV2.success;
    if (freshness >= 40) return TColorV2.warning;
    return TColorV2.error;
  }
}
