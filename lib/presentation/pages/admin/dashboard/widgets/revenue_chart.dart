import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../../core/themes/app_theme.dart';
import '../../../../../data/models/revenue_point.dart';

/// Revenue chart widget using fl_chart
class RevenueChart extends StatelessWidget {
  final List<RevenuePoint> data;
  final String granularity;
  final Function(String) onGranularityChanged;

  const RevenueChart({
    super.key,
    required this.data,
    required this.granularity,
    required this.onGranularityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Revenue Trend',
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Granularity selector
                _buildGranularitySelector(),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Chart
            if (data.isEmpty)
              _buildEmptyState()
            else
              SizedBox(
                height: 300,
                child: LineChart(
                  _buildChartData(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGranularitySelector() {
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'day', label: Text('Day')),
        ButtonSegment(value: 'week', label: Text('Week')),
        ButtonSegment(value: 'month', label: Text('Month')),
      ],
      selected: {granularity},
      onSelectionChanged: (Set<String> selection) {
        onGranularityChanged(selection.first);
      },
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(AppTextStyles.bodySmall),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 64,
            color: AppColors.greyLight,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No revenue data available',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData() {
    final spots = data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    // Find min and max values for better scaling
    final maxY = data.map((p) => p.value).reduce((a, b) => a > b ? a : b);
    final minY = data.map((p) => p.value).reduce((a, b) => a < b ? a : b);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.border,
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: data.length > 7 ? (data.length / 7).ceilToDouble() : 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < data.length) {
                final point = data[value.toInt()];
                final label = _formatDate(point.date);
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
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
            reservedSize: 60,
            interval: (maxY - minY) / 5,
            getTitlesWidget: (value, meta) {
              return Text(
                '\$${_formatCurrency(value)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
          left: BorderSide(color: AppColors.border),
        ),
      ),
      minX: 0,
      maxX: (data.length - 1).toDouble(),
      minY: minY * 0.9, // Add 10% padding below
      maxY: maxY * 1.1, // Add 10% padding above
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppColors.primary,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withOpacity(0.1),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => AppColors.secondary,
          tooltipRoundedRadius: AppRadius.sm,
          tooltipPadding: const EdgeInsets.all(AppSpacing.sm),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final point = data[spot.x.toInt()];
              final label = _formatDate(point.date);
              return LineTooltipItem(
                '$label\n\$${_formatCurrency(point.value)}',
                AppTextStyles.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              );
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }
}
