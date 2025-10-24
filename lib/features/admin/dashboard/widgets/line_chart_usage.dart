import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../data/admin_analytics_provider.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Line Chart for Ingredient Usage Over Time
class LineChartUsage extends StatelessWidget {
  final List<IngredientUsageTrend> usageTrends;

  const LineChartUsage({
    super.key,
    required this.usageTrends,
  });

  @override
  Widget build(BuildContext context) {
    if (usageTrends.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No usage data available',
              style: TextStyle(
                fontSize: 16,
                color: TColorV2.textSecondary,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(Icons.show_chart, color: TColorV2.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Ingredient Usage Trends (Last 7 Days)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColorV2.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Legend
            Wrap(
              spacing: 24,
              runSpacing: 8,
              children: [
                _buildLegendItem('Added', TColorV2.success),
                _buildLegendItem('Used', TColorV2.primary),
                _buildLegendItem('Expired', TColorV2.error),
                _buildLegendItem('Discarded', TColorV2.warning),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: TColorV2.neutral200,
                        strokeWidth: 1,
                      );
                    },
                    getDrawingVerticalLine: (value) {
                      return FlLine(
                        color: TColorV2.neutral200,
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
                          final index = value.toInt();
                          if (index < 0 || index >= usageTrends.length) {
                            return const Text('');
                          }
                          final date = usageTrends[index].date;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: TextStyle(
                                color: TColorV2.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: TColorV2.textSecondary,
                              fontSize: 12,
                            ),
                          );
                        },
                        reservedSize: 42,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: TColorV2.neutral300),
                  ),
                  minX: 0,
                  maxX: (usageTrends.length - 1).toDouble(),
                  minY: 0,
                  maxY: _getMaxY(),
                  lineBarsData: [
                    _buildLineChartBarData(
                      'Added',
                      TColorV2.success,
                      (trend) => trend.added.toDouble(),
                    ),
                    _buildLineChartBarData(
                      'Used',
                      TColorV2.primary,
                      (trend) => trend.used.toDouble(),
                    ),
                    _buildLineChartBarData(
                      'Expired',
                      TColorV2.error,
                      (trend) => trend.expired.toDouble(),
                    ),
                    _buildLineChartBarData(
                      'Discarded',
                      TColorV2.warning,
                      (trend) => trend.discarded.toDouble(),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final trend = usageTrends[spot.x.toInt()];
                          final dateStr =
                              DateFormat('MMM dd').format(trend.date);
                          String label;
                          switch (spot.barIndex) {
                            case 0:
                              label = 'Added: ${trend.added}';
                              break;
                            case 1:
                              label = 'Used: ${trend.used}';
                              break;
                            case 2:
                              label = 'Expired: ${trend.expired}';
                              break;
                            case 3:
                              label = 'Discarded: ${trend.discarded}';
                              break;
                            default:
                              label = '';
                          }
                          return LineTooltipItem(
                            '$dateStr\n$label',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: TColorV2.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  LineChartBarData _buildLineChartBarData(
    String label,
    Color color,
    double Function(IngredientUsageTrend) getValue,
  ) {
    return LineChartBarData(
      spots: usageTrends.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), getValue(entry.value));
      }).toList(),
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: color,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        color: color.withValues(alpha: 0.1),
      ),
    );
  }

  double _getMaxY() {
    double max = 0;
    for (final trend in usageTrends) {
      final values = [
        trend.added.toDouble(),
        trend.used.toDouble(),
        trend.expired.toDouble(),
        trend.discarded.toDouble(),
      ];
      final trendMax = values.reduce((a, b) => a > b ? a : b);
      if (trendMax > max) max = trendMax;
    }
    return (max * 1.2).ceilToDouble(); // Add 20% padding
  }
}
