import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Bar Chart for Expired/Wasted Ingredients by Category
class BarChartWaste extends StatelessWidget {
  final Map<String, int> wasteByCategory;

  const BarChartWaste({
    super.key,
    required this.wasteByCategory,
  });

  @override
  Widget build(BuildContext context) {
    // Filter out categories with no waste
    final nonZeroWaste = Map<String, int>.fromEntries(
      wasteByCategory.entries.where((entry) => entry.value > 0),
    );

    if (nonZeroWaste.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 300,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: TColorV2.success,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No waste recorded! 🎉',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColorV2.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'All ingredients are well managed',
                  style: TextStyle(
                    fontSize: 14,
                    color: TColorV2.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Get top 8 categories with most waste
    final sortedEntries = nonZeroWaste.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topWaste = Map.fromEntries(sortedEntries.take(8));

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
                Icon(Icons.delete_outline, color: TColorV2.error, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Waste by Category',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColorV2.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: TColorV2.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Total: ${nonZeroWaste.values.fold<int>(0, (sum, count) => sum + count)} items',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: TColorV2.error,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(topWaste),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final category = topWaste.keys.elementAt(groupIndex);
                        final count = topWaste[category]!;
                        return BarTooltipItem(
                          '$category\n$count items wasted',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
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
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= topWaste.length) {
                            return const Text('');
                          }
                          final category = topWaste.keys.elementAt(index);
                          // Abbreviate long category names
                          final displayName = category.length > 8
                              ? '${category.substring(0, 7)}.'
                              : category;
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              displayName,
                              style: TextStyle(
                                color: TColorV2.textSecondary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                        reservedSize: 32,
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
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: TColorV2.neutral300),
                  ),
                  barGroups: topWaste.entries.map((entry) {
                    final index = topWaste.keys.toList().indexOf(entry.key);
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.toDouble(),
                          color: _getBarColor(entry.value, _getMaxY(topWaste)),
                          width: 24,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: _getMaxY(topWaste),
                            color: TColorV2.neutral200,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: TColorV2.neutral200,
                        strokeWidth: 1,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(Map<String, int> data) {
    if (data.isEmpty) return 10;
    final max = data.values.reduce((a, b) => a > b ? a : b);
    return (max * 1.2).ceilToDouble(); // Add 20% padding
  }

  Color _getBarColor(int value, double maxY) {
    final percentage = value / maxY;
    if (percentage > 0.7) {
      return TColorV2.error; // High waste - red
    } else if (percentage > 0.4) {
      return TColorV2.warning; // Medium waste - amber
    } else {
      return Colors.orange.shade300; // Low waste - light orange
    }
  }
}
