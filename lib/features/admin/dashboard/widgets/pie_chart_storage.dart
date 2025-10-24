import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../data/models/ingredient.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Pie Chart for Storage Type Distribution
class PieChartStorage extends StatelessWidget {
  final Map<StorageType, int> storageDistribution;

  const PieChartStorage({
    super.key,
    required this.storageDistribution,
  });

  @override
  Widget build(BuildContext context) {
    final totalItems =
        storageDistribution.values.fold<int>(0, (sum, count) => sum + count);

    if (totalItems == 0) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 350,
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No storage data available',
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
                Icon(Icons.pie_chart, color: TColorV2.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Storage Distribution',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColorV2.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Chart
            SizedBox(
              height: 250,
              child: Row(
                children: [
                  // Pie Chart
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sections: _buildSections(totalItems),
                        sectionsSpace: 2,
                        centerSpaceRadius: 60,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Legend
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: StorageType.values
                          .where((storage) => storageDistribution[storage]! > 0)
                          .map((storage) {
                        final count = storageDistribution[storage]!;
                        final percentage =
                            (count / totalItems * 100).toStringAsFixed(1);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getStorageColor(storage),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      storage.label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: TColorV2.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      '$count items ($percentage%)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: TColorV2.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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

  List<PieChartSectionData> _buildSections(int totalItems) {
    return StorageType.values
        .where((storage) => storageDistribution[storage]! > 0)
        .map((storage) {
      final count = storageDistribution[storage]!;
      final percentage = count / totalItems * 100;

      return PieChartSectionData(
        value: count.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        color: _getStorageColor(storage),
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color _getStorageColor(StorageType storage) {
    switch (storage) {
      case StorageType.fridge:
        return TColorV2.info;
      case StorageType.freezer:
        return Colors.lightBlue;
      case StorageType.pantry:
        return Colors.brown;
      case StorageType.countertop:
        return Colors.orange;
    }
  }
}
