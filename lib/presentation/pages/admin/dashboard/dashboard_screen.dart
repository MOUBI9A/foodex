import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/themes/app_theme.dart';
import 'dashboard_notifier.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/metric_card.dart';
import 'widgets/revenue_chart.dart';
import 'widgets/orders_table.dart';
import 'widgets/system_health_card.dart';
import 'dart:html' as html;

/// Admin Dashboard Screen (Web Only)
/// Displays real-time metrics, charts, and analytics
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // Header
          DashboardHeader(
            startDate: state.startDate,
            endDate: state.endDate,
            onDateRangePressed: () => _showDateRangePicker(context, ref),
            onRefreshPressed: () => notifier.refresh(),
            onExportPressed: () => _handleExport(context, notifier),
            isLoading: state.isLoading,
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Error message
                  if (state.error != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: AppColors.error),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: AppColors.error),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              state.error!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () => notifier.clearError(),
                            color: AppColors.error,
                          ),
                        ],
                      ),
                    ),

                  // Metric cards row
                  if (state.overview != null)
                    _buildMetricCards(state.overview!),

                  const SizedBox(height: AppSpacing.lg),

                  // Charts row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Revenue Chart
                      Expanded(
                        flex: 2,
                        child: RevenueChart(
                          data: state.revenueData,
                          granularity: state.revenueGranularity,
                          onGranularityChanged: (granularity) {
                            notifier.updateRevenueGranularity(granularity);
                          },
                        ),
                      ),

                      const SizedBox(width: AppSpacing.lg),

                      // System Health Card
                      Expanded(
                        flex: 1,
                        child: SystemHealthCard(health: state.systemHealth),
                      ),
                    ],
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Orders Table
                  if (state.ordersData != null)
                    OrdersTable(
                      orders: state.ordersData!['orders'] ?? [],
                      currentPage: state.currentPage,
                      totalPages: _calculateTotalPages(
                        state.ordersData!['total'] ?? 0,
                        20,
                      ),
                      selectedStatus: state.orderStatus,
                      searchQuery: state.searchQuery,
                      onPageChanged: (page) => notifier.goToPage(page),
                      onStatusChanged: (status) {
                        notifier.updateOrderFilters(status: status);
                      },
                      onSearchChanged: (query) {
                        notifier.updateOrderFilters(searchQuery: query);
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCards(overview) {
    return Row(
      children: [
        Expanded(
          child: MetricCard(
            title: 'Orders Today',
            value: '${overview.ordersToday}',
            subtitle: 'orders',
            icon: Icons.shopping_bag,
            iconColor: AppColors.primary,
            trend: overview.ordersTrend,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: MetricCard(
            title: 'Revenue Today',
            value: '\$${overview.revenueToday.toStringAsFixed(2)}',
            subtitle: 'total revenue',
            icon: Icons.attach_money,
            iconColor: AppColors.success,
            trend: overview.revenueTrend,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: MetricCard(
            title: 'Active Chefs',
            value: '${overview.activeChefs}',
            subtitle: 'online now',
            icon: Icons.restaurant,
            iconColor: AppColors.info,
            trend: overview.chefsTrend,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: MetricCard(
            title: 'Avg Prep Time',
            value: '${overview.avgPrepTime} min',
            subtitle: 'average',
            icon: Icons.timer,
            iconColor: AppColors.warning,
            trend: overview.prepTimeTrend,
          ),
        ),
      ],
    );
  }

  int _calculateTotalPages(int total, int pageSize) {
    return (total / pageSize).ceil();
  }

  Future<void> _showDateRangePicker(BuildContext context, WidgetRef ref) async {
    final state = ref.read(dashboardNotifierProvider);
    final notifier = ref.read(dashboardNotifierProvider.notifier);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: state.startDate,
        end: state.endDate,
      ),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      notifier.updateDateRange(picked.start, picked.end);
    }
  }

  Future<void> _handleExport(
      BuildContext context, DashboardNotifier notifier) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Export orders
      final csvData = await notifier.exportOrders();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Download CSV file (Web only)
      // Download functionality for web
      final blob = html.Blob([csvData], 'text/csv');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'dashboard_report.csv')
        ..click();
      html.Url.revokeObjectUrl(url);

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Orders exported successfully'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
