import 'package:flutter/material.dart';
import '../../../../../core/themes/app_theme.dart';

/// Dashboard header with date range picker and quick actions
class DashboardHeader extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final VoidCallback onDateRangePressed;
  final VoidCallback onRefreshPressed;
  final VoidCallback onExportPressed;
  final bool isLoading;

  const DashboardHeader({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onDateRangePressed,
    required this.onRefreshPressed,
    required this.onExportPressed,
    this.isLoading = false,
  });

  String _formatDateRange() {
    final start = '${startDate.day}/${startDate.month}/${startDate.year}';
    final end = '${endDate.day}/${endDate.month}/${endDate.year}';
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: AppTextStyles.heading1.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Real-time insights and analytics',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Date Range Picker
          OutlinedButton.icon(
            onPressed: onDateRangePressed,
            icon: const Icon(Icons.calendar_today, size: 20),
            label: Text(_formatDateRange()),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              side: BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Refresh Button
          IconButton(
            onPressed: isLoading ? null : onRefreshPressed,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              foregroundColor: AppColors.primary,
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Export Button
          ElevatedButton.icon(
            onPressed: onExportPressed,
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
