import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';
import 'package:food_delivery/features/admin/dashboard/data/dashboard_metrics_provider.dart';

/// Revenue Chart Widget
///
/// Interactive line chart showing weekly revenue, orders, or new users data.
/// Features smooth animations, hover tooltips, and data type toggle.
class RevenueChart extends ConsumerStatefulWidget {
  const RevenueChart({super.key});

  @override
  ConsumerState<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends ConsumerState<RevenueChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
    final selectedType = ref.watch(selectedChartTypeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with toggle buttons
            _buildHeader(context, selectedType, isDark),
            const SizedBox(height: 32),

            // Chart
            SizedBox(
              height: 300,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return LineChart(
                    _buildChartData(
                      metrics.weeklyRevenue,
                      selectedType,
                      isDark,
                    ),
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ChartDataType selectedType,
    bool isDark,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getChartTitle(selectedType),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Weekly Overview',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
              ),
            ),
          ],
        ),
        _buildToggleButtons(selectedType),
      ],
    );
  }

  Widget _buildToggleButtons(ChartDataType selectedType) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF3A3A3A)
            : AdminTheme.gray100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            'Revenue',
            ChartDataType.revenue,
            selectedType == ChartDataType.revenue,
          ),
          _buildToggleButton(
            'Orders',
            ChartDataType.orders,
            selectedType == ChartDataType.orders,
          ),
          _buildToggleButton(
            'New Users',
            ChartDataType.newUsers,
            selectedType == ChartDataType.newUsers,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    ChartDataType type,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        ref.read(selectedChartTypeProvider.notifier).state = type;
        _animationController.reset();
        _animationController.forward();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AdminTheme.primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (Theme.of(context).brightness == Brightness.dark
                    ? AdminTheme.gray400
                    : AdminTheme.gray600),
          ),
        ),
      ),
    );
  }

  String _getChartTitle(ChartDataType type) {
    switch (type) {
      case ChartDataType.revenue:
        return 'Revenue Analytics';
      case ChartDataType.orders:
        return 'Orders Analytics';
      case ChartDataType.newUsers:
        return 'User Growth Analytics';
    }
  }

  LineChartData _buildChartData(
    List<RevenueData> data,
    ChartDataType type,
    bool isDark,
  ) {
    final spots = data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final yValue = _getYValue(item, type) * _animation.value;
      return FlSpot(index.toDouble(), yValue);
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: _getGridInterval(type),
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: isDark
                ? AdminTheme.gray700.withOpacity(0.3)
                : AdminTheme.gray300.withOpacity(0.5),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < data.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    data[value.toInt()].day,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: _getGridInterval(type),
            reservedSize: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                _formatYAxisValue(value, type),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: 0,
      maxY: _getMaxY(data, type),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35,
          color: AdminTheme.primaryOrange,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: Colors.white,
                strokeWidth: 2,
                strokeColor: AdminTheme.primaryOrange,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                AdminTheme.primaryOrange.withOpacity(0.3),
                AdminTheme.primaryOrange.withOpacity(0.0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final dataIndex = spot.x.toInt();
              if (dataIndex >= 0 && dataIndex < data.length) {
                final item = data[dataIndex];
                return LineTooltipItem(
                  '${item.day}\n${_formatTooltipValue(_getYValue(item, type), type)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              }
              return null;
            }).toList();
          },
        ),
      ),
    );
  }

  double _getYValue(RevenueData data, ChartDataType type) {
    switch (type) {
      case ChartDataType.revenue:
        return data.revenue;
      case ChartDataType.orders:
        return data.orders.toDouble();
      case ChartDataType.newUsers:
        return data.newUsers.toDouble();
    }
  }

  double _getMaxY(List<RevenueData> data, ChartDataType type) {
    final values = data.map((d) => _getYValue(d, type)).toList();
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    return maxValue * 1.2; // Add 20% padding
  }

  double _getGridInterval(ChartDataType type) {
    switch (type) {
      case ChartDataType.revenue:
        return 10000;
      case ChartDataType.orders:
        return 500;
      case ChartDataType.newUsers:
        return 20;
    }
  }

  String _formatYAxisValue(double value, ChartDataType type) {
    switch (type) {
      case ChartDataType.revenue:
        if (value >= 1000) {
          return '\$${(value / 1000).toStringAsFixed(0)}k';
        }
        return '\$${value.toStringAsFixed(0)}';
      case ChartDataType.orders:
        return value.toInt().toString();
      case ChartDataType.newUsers:
        return value.toInt().toString();
    }
  }

  String _formatTooltipValue(double value, ChartDataType type) {
    switch (type) {
      case ChartDataType.revenue:
        return '\$${value.toStringAsFixed(0)}';
      case ChartDataType.orders:
        return '${value.toInt()} orders';
      case ChartDataType.newUsers:
        return '${value.toInt()} users';
    }
  }
}
