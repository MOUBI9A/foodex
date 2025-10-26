// AlertsBanner: shows summary of expiring/low/expired ingredients.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ingredient_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class AlertsBanner extends ConsumerWidget {
  const AlertsBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsAsync = ref.watch(ingredientListProvider);
    return ingredientsAsync.when(
      data: (ingredients) {
        final expired = ingredients.where((i) => i.isExpired).length;
        final expiring = ingredients.where((i) => !i.isExpired && i.freshness < 40).length;
        final low = ingredients.where((i) => i.isLowStock).length;
        return Row(
          children: [
            if (expired > 0)
              _AlertChip(label: 'Expired: $expired', color: AppColors.error),
            if (expiring > 0)
              _AlertChip(label: 'Expiring: $expiring', color: AppColors.warning),
            if (low > 0)
              _AlertChip(label: 'Low: $low', color: AppColors.warning),
            if (expired == 0 && expiring == 0 && low == 0)
              const Text('All ingredients healthy!'),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}

class _AlertChip extends StatelessWidget {
  final String label;
  final Color color;
  const _AlertChip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.md),
      child: Chip(
        label: Text(label),
        backgroundColor: color.withValues(alpha: 0.15),
        labelStyle: TextStyle(color: color),
      ),
    );
  }
}
