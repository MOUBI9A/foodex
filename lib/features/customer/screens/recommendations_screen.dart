import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../providers/recommendation_provider.dart';
import '../../chef/providers/dish_availability_provider.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dishes = ref.watch(customerDishFeedProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sélection du moment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: dishes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erreur: $error')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Aucun plat disponible pour le moment.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.xl),
            itemBuilder: (context, index) {
              final vm = items[index];
              return _DishCard(vm: vm);
            },
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.lg),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}

class _DishCard extends ConsumerWidget {
  const _DishCard({required this.vm});

  final CustomerDishViewModel vm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = _AvailabilityBadge(status: vm.availability.status);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  vm.dish.name,
                  style: AppTextStyles.h2,
                ),
              ),
              badge,
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            vm.chef != null
                ? '${vm.chef!.name} • ${vm.chef!.kitchenName}'
                : 'Chef partenaire FoodEx',
            style: AppTextStyles.subtitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Note ${vm.dish.rating.toStringAsFixed(1)} • ${vm.dish.prepTime} min de préparation',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Colors.green),
              const SizedBox(width: 6),
              Text(
                'Chez toi dans ~${vm.estimate.totalMinutes} min',
                style: AppTextStyles.body.copyWith(color: Colors.green[700]),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (vm.safety.isBlocked || vm.safety.isDiscouraged) _SafetyBanner(vm: vm),
          if (!vm.safety.isBlocked && !vm.safety.isDiscouraged)
            Text(
              'Sélection compatible avec tes préférences 🎉',
              style: AppTextStyles.caption.copyWith(color: AppColors.success),
            ),
          const SizedBox(height: AppSpacing.md),
          Text(
            vm.availability.reason,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: vm.canAddToCart ? () {} : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(vm.canAddToCart ? 'Ajouter à la commande' : 'Indisponible'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              OutlinedButton(
                onPressed: () => _showDetails(context, vm),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: const Text('Détails'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, CustomerDishViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vm.dish.name,
                        style: AppTextStyles.h1,
                      ),
                    ),
                    _AvailabilityBadge(status: vm.availability.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  vm.dish.description,
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Chef',
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  vm.chef != null ? '${vm.chef!.name} • ${vm.chef!.kitchenName}' : 'Chef invité',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Sécurité & allergies',
                  style: AppTextStyles.subtitle.copyWith(color: AppColors.error),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (vm.safety.warnings.isEmpty)
                  Text('Aucun allergène détecté 🎉', style: AppTextStyles.body)
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: vm.safety.warnings
                        .map(
                          (warning) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline, size: 18, color: vm.safety.isBlocked ? AppColors.error : AppColors.warning),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    warning,
                                    style: AppTextStyles.body.copyWith(
                                      color: vm.safety.isBlocked ? AppColors.error : AppColors.warning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: AppSpacing.lg),
                Text('Ingrédients', style: AppTextStyles.subtitle),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  children: vm.dish.ingredients
                      .map(
                        (ing) => Chip(
                          label: Text('${ing.ingredientId} (${ing.qty})'),
                          backgroundColor: AppColors.placeholder.withValues(alpha: 0.2),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text('Timeline', style: AppTextStyles.subtitle),
                const SizedBox(height: AppSpacing.sm),
                _Timeline(
                  steps: const [
                    _TimelineStep('Préparation', Icons.restaurant),
                    _TimelineStep('Prêt à être récupéré', Icons.check_circle),
                    _TimelineStep('En route', Icons.delivery_dining),
                    _TimelineStep('Livré', Icons.home_filled),
                  ],
                  currentStatus: vm.availability.status == DishAvailabilityStatus.unavailable ? 0 : 2,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case DishAvailabilityStatus.limited:
        color = AppColors.warning;
        label = '🟡 Dernières portions';
        break;
      case DishAvailabilityStatus.unavailable:
        color = AppColors.error;
        label = '🔴 Indisponible';
        break;
      default:
        color = AppColors.success;
        label = '🟢 Disponible';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _SafetyBanner extends StatelessWidget {
  const _SafetyBanner({required this.vm});

  final CustomerDishViewModel vm;

  @override
  Widget build(BuildContext context) {
    final color = vm.safety.isBlocked ? AppColors.error : AppColors.warning;
    final emoji = vm.safety.isBlocked ? '⚠️' : 'ℹ️';
    final title = vm.safety.isBlocked ? 'Allergène détecté' : 'À consommer avec prudence';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$emoji $title', style: AppTextStyles.body.copyWith(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          ...vm.safety.warnings.map(
            (warning) => Text(
              warning,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.steps, required this.currentStatus});

  final List<_TimelineStep> steps;
  final int currentStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              steps[i].icon,
              color: i <= currentStatus ? AppColors.primary : AppColors.placeholder,
            ),
            title: Text(
              steps[i].label,
              style: AppTextStyles.body.copyWith(
                color: i <= currentStatus ? AppColors.textPrimary : AppColors.placeholder,
              ),
            ),
          ),
      ],
    );
  }
}

class _TimelineStep {
  final String label;
  final IconData icon;
  const _TimelineStep(this.label, this.icon);
}
