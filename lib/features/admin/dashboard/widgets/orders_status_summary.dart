import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';
import 'package:food_delivery/features/admin/dashboard/data/dashboard_metrics_provider.dart';

/// Orders Status Summary Widget
///
/// Displays order status distribution as an animated donut chart
/// with interactive legend and percentage breakdowns.
class OrdersStatusSummary extends ConsumerStatefulWidget {
  const OrdersStatusSummary({super.key});

  @override
  ConsumerState<OrdersStatusSummary> createState() =>
      _OrdersStatusSummaryState();
}

class _OrdersStatusSummaryState extends ConsumerState<OrdersStatusSummary>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(dashboardMetricsProvider);
    final ordersStatus = metrics.ordersStatus;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Orders Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Real-time order distribution',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
              ),
            ),
            const SizedBox(height: 32),

            // Chart and Legend
            Row(
              children: [
                // Donut Chart
                Expanded(
                  flex: 3,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return PieChart(
                          _buildPieChartData(ordersStatus),
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 32),

                // Legend
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem(
                        'Pending',
                        ordersStatus.pending,
                        ordersStatus.pendingPercentage,
                        AdminTheme.warningYellow,
                        0,
                      ),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                        'In Progress',
                        ordersStatus.inProgress,
                        ordersStatus.inProgressPercentage,
                        AdminTheme.infoBlue,
                        1,
                      ),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                        'Delivered',
                        ordersStatus.delivered,
                        ordersStatus.deliveredPercentage,
                        AdminTheme.successGreen,
                        2,
                      ),
                      const SizedBox(height: 16),
                      _buildLegendItem(
                        'Cancelled',
                        ordersStatus.cancelled,
                        ordersStatus.cancelledPercentage,
                        AdminTheme.errorRed,
                        3,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Total Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? AdminTheme.gray800.withOpacity(0.5)
                    : AdminTheme.gray100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Orders',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    ordersStatus.total.toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AdminTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PieChartData _buildPieChartData(OrdersStatusData ordersStatus) {
    final animatedValue = _animation.value;

    return PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              _touchedIndex = -1;
              return;
            }
            _touchedIndex =
                pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),
      borderData: FlBorderData(show: false),
      sectionsSpace: 2,
      centerSpaceRadius: 60,
      sections: [
        _buildPieChartSection(
          value: ordersStatus.pending * animatedValue,
          color: AdminTheme.warningYellow,
          title: '${ordersStatus.pendingPercentage.toStringAsFixed(1)}%',
          index: 0,
        ),
        _buildPieChartSection(
          value: ordersStatus.inProgress * animatedValue,
          color: AdminTheme.infoBlue,
          title: '${ordersStatus.inProgressPercentage.toStringAsFixed(1)}%',
          index: 1,
        ),
        _buildPieChartSection(
          value: ordersStatus.delivered * animatedValue,
          color: AdminTheme.successGreen,
          title: '${ordersStatus.deliveredPercentage.toStringAsFixed(1)}%',
          index: 2,
        ),
        _buildPieChartSection(
          value: ordersStatus.cancelled * animatedValue,
          color: AdminTheme.errorRed,
          title: '${ordersStatus.cancelledPercentage.toStringAsFixed(1)}%',
          index: 3,
        ),
      ],
    );
  }

  PieChartSectionData _buildPieChartSection({
    required double value,
    required Color color,
    required String title,
    required int index,
  }) {
    final isTouched = index == _touchedIndex;
    final radius = isTouched ? 70.0 : 60.0;
    final fontSize = isTouched ? 16.0 : 14.0;

    return PieChartSectionData(
      color: color,
      value: value,
      title: title,
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      badgeWidget: isTouched
          ? Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: AdminTheme.cardShadow,
              ),
              child: Icon(
                _getStatusIcon(index),
                color: color,
                size: 20,
              ),
            )
          : null,
      badgePositionPercentageOffset: 1.3,
    );
  }

  IconData _getStatusIcon(int index) {
    switch (index) {
      case 0:
        return Icons.pending;
      case 1:
        return Icons.delivery_dining;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.cancel;
      default:
        return Icons.circle;
    }
  }

  Widget _buildLegendItem(
    String label,
    int count,
    double percentage,
    Color color,
    int index,
  ) {
    final isTouched = index == _touchedIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _touchedIndex = index),
      onExit: (_) => setState(() => _touchedIndex = -1),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isTouched ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isTouched ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isTouched
                          ? color
                          : (isDark ? Colors.white : AdminTheme.darkGray),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count orders',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
