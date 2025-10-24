import 'package:flutter/material.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Alerts Banner Widget - Displays inventory alert counts
class AlertsBanner extends StatelessWidget {
  final Map<String, int> alertCounts;
  final VoidCallback? onViewExpired;
  final VoidCallback? onViewExpiringSoon;
  final VoidCallback? onViewLowStock;

  const AlertsBanner({
    super.key,
    required this.alertCounts,
    this.onViewExpired,
    this.onViewExpiringSoon,
    this.onViewLowStock,
  });

  @override
  Widget build(BuildContext context) {
    final expiredCount = alertCounts['expired'] ?? 0;
    final expiringSoonCount = alertCounts['expiringSoon'] ?? 0;
    final lowStockCount = alertCounts['lowStock'] ?? 0;
    final totalAlerts = alertCounts['total'] ?? 0;

    // Don't show banner if no alerts
    if (totalAlerts == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TColorV2.error.withValues(alpha: 0.1),
            TColorV2.warning.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TColorV2.error.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: TColorV2.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: TColorV2.error,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Inventory Alerts',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: TColorV2.textPrimary,
                      ),
                    ),
                    Text(
                      '$totalAlerts items need attention',
                      style: TextStyle(
                        fontSize: 13,
                        color: TColorV2.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Alert Cards
          Row(
            children: [
              if (expiredCount > 0)
                Expanded(
                  child: _buildAlertCard(
                    icon: Icons.dangerous,
                    label: 'Expired',
                    count: expiredCount,
                    color: TColorV2.error,
                    onTap: onViewExpired,
                  ),
                ),
              if (expiredCount > 0 && expiringSoonCount > 0)
                const SizedBox(width: 8),
              if (expiringSoonCount > 0)
                Expanded(
                  child: _buildAlertCard(
                    icon: Icons.access_time,
                    label: 'Expiring',
                    count: expiringSoonCount,
                    color: TColorV2.warning,
                    onTap: onViewExpiringSoon,
                  ),
                ),
              if ((expiredCount > 0 || expiringSoonCount > 0) &&
                  lowStockCount > 0)
                const SizedBox(width: 8),
              if (lowStockCount > 0)
                Expanded(
                  child: _buildAlertCard(
                    icon: Icons.inventory_2_outlined,
                    label: 'Low Stock',
                    count: lowStockCount,
                    color: TColorV2.warning,
                    onTap: onViewLowStock,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: TColorV2.textSecondary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
