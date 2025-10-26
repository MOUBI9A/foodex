// IngredientCard: displays ingredient info, freshness, and actions.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ingredient.dart';
import '../providers/ingredient_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import 'ingredient_form.dart';
import 'restock_modal.dart';

class IngredientCard extends ConsumerWidget {
  final Ingredient ingredient;
  const IngredientCard({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpired = ingredient.isExpired;
    final isLow = ingredient.isLowStock;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ingredient.name, style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text('${ingredient.quantity} ${ingredient.unit}', style: AppTextStyles.body),
                  if (ingredient.expiryDate != null)
                    Text('Expires: ${ingredient.expiryDate!.toLocal().toString().split(' ')[0]}', style: AppTextStyles.caption),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: ingredient.freshness / 100,
                    backgroundColor: AppColors.accent,
                    color: ingredient.freshness > 60 ? AppColors.success : (ingredient.freshness > 30 ? AppColors.warning : AppColors.error),
                  ),
                  Row(
                    children: [
                      if (isExpired)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(label: Text('Expired'), backgroundColor: AppColors.error.withValues(alpha: 0.2)),
                        ),
                      if (!isExpired && ingredient.freshness < 40)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Chip(label: Text('Expiring'), backgroundColor: AppColors.warning.withValues(alpha: 0.2)),
                        ),
                      if (isLow)
                        Chip(label: Text('Low Stock'), backgroundColor: AppColors.warning.withValues(alpha: 0.2)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => IngredientForm(
                        initial: ingredient,
                        onSubmit: (updated) async {
                          await ref.read(ingredientListProvider.notifier).updateIngredient(updated);
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => RestockModal(
                        onSubmit: (qty, expiry) async {
                          await ref.read(ingredientListProvider.notifier).restock(ingredient.id, qty, expiry: expiry);
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await ref.read(ingredientListProvider.notifier).discard(ingredient.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
