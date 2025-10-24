import 'package:flutter/material.dart';
import '../../../../../core/themes/app_theme.dart';
import '../../../../../data/models/system_health.dart';

/// System health status card
class SystemHealthCard extends StatelessWidget {
  final SystemHealth? health;

  const SystemHealthCard({
    super.key,
    this.health,
  });

  @override
  Widget build(BuildContext context) {
    if (health == null) {
      return _buildLoadingState();
    }

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
              children: [
                Text(
                  'System Health',
                  style: AppTextStyles.heading3.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildOverallStatus(),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Health metrics
            _buildHealthMetric(
              'CPU Usage',
              '${health!.cpuUsage.toStringAsFixed(1)}%',
              health!.cpuUsage < 80.0,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildHealthMetric(
              'Memory Usage',
              '${health!.memoryUsage.toStringAsFixed(1)}%',
              health!.memoryUsage < 80.0,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildHealthMetric(
              'Active Connections',
              '${health!.activeConnections}',
              health!.activeConnections < 1000,
            ),
            const SizedBox(height: AppSpacing.md),
            _buildHealthMetric(
              'Errors (Last Hour)',
              '${health!.errorsLastHour}',
              health!.errorsLastHour < 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallStatus() {
    final isHealthy = health!.status.toLowerCase() == 'ok';
    final color = isHealthy
        ? AppColors.success
        : (health!.status.toLowerCase() == 'warning'
            ? AppColors.warning
            : AppColors.error);
    final text = health!.status;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(String label, String value, bool isGood) {
    final color = isGood ? AppColors.success : AppColors.warning;

    return Row(
      children: [
        Icon(
          isGood ? Icons.check_circle : Icons.warning,
          color: color,
          size: 20,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Text(
              'System Health',
              style: AppTextStyles.heading3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Loading health status...',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
