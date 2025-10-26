import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/order_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/order_model.dart';

class ChefOrdersScreen extends ConsumerWidget {
  const ChefOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderListProvider);
    final pending = orders.where((o) => o.status == OrderStatus.pending).toList();
    final preparing = orders.where((o) => o.status == OrderStatus.preparing).toList();
    final ready = orders.where((o) => o.status == OrderStatus.readyForPickup).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Commandes en direct'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ChefStatsRow(pending: pending.length, preparing: preparing.length, ready: ready.length),
            const SizedBox(height: AppSpacing.xl),
            _ChefOrderSection(
              title: 'Nouvelles commandes',
              orders: pending,
              emptyText: 'Aucune commande en attente pour l’instant.',
              actionBuilder: (order) => Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _accept(context, ref, order.id),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      child: const Text('Accepter'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _reject(context, ref, order.id),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                      ),
                      child: const Text('Refuser'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ChefOrderSection(
              title: 'En préparation',
              orders: preparing,
              emptyText: 'Préparez-vous, les nouvelles commandes arrivent.',
              actionBuilder: (order) => Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _markReady(context, ref, order.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: const Text('Marquer prêt'),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _ChefOrderSection(
              title: 'Prêtes (en attente de livreur)',
              orders: ready,
              emptyText: 'Toutes les commandes ont été récupérées 🎉',
              actionBuilder: (order) => Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  order.courierId == null ? 'Aucun livreur assigné pour l’instant' : 'Livreur: ${order.courierId}',
                  style: AppTextStyles.caption,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _accept(BuildContext context, WidgetRef ref, String orderId) async {
    await ref.read(orderListProvider.notifier).chefAcceptOrder(orderId);
    _toast(context, 'Commande acceptée 🧑‍🍳');
  }

  Future<void> _reject(BuildContext context, WidgetRef ref, String orderId) async {
    await ref.read(orderListProvider.notifier).chefRejectOrder(orderId);
    _toast(context, 'Commande refusée');
  }

  Future<void> _markReady(BuildContext context, WidgetRef ref, String orderId) async {
    await ref.read(orderListProvider.notifier).chefMarkReady(orderId);
    _toast(context, 'Commande prête à être récupérée');
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ChefStatsRow extends StatelessWidget {
  const _ChefStatsRow({required this.pending, required this.preparing, required this.ready});
  final int pending;
  final int preparing;
  final int ready;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _StatCard(label: 'Nouvelles', value: pending.toString(), color: AppColors.primary),
      _StatCard(label: 'En préparation', value: preparing.toString(), color: AppColors.warning),
      _StatCard(label: 'Prêtes', value: ready.toString(), color: AppColors.success),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        return isWide
            ? Row(
                children: cards
                    .map((card) => Expanded(child: Padding(padding: const EdgeInsets.only(right: AppSpacing.md), child: card)))
                    .toList(),
              )
            : Column(
                children: cards
                    .map((card) => Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: card,
                        ))
                    .toList(),
              );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.h2.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _ChefOrderSection extends StatelessWidget {
  const _ChefOrderSection({
    required this.title,
    required this.orders,
    required this.emptyText,
    required this.actionBuilder,
  });

  final String title;
  final List<Order> orders;
  final String emptyText;
  final Widget Function(Order) actionBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.h2),
            if (orders.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: Text('${orders.length} en file', style: AppTextStyles.caption),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (orders.isEmpty)
          Text(emptyText, style: AppTextStyles.caption)
        else
          Column(
            children: orders
                .map(
                  (order) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _ChefOrderCard(order: order, actionBuilder: actionBuilder),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _ChefOrderCard extends StatelessWidget {
  const _ChefOrderCard({required this.order, required this.actionBuilder});
  final Order order;
  final Widget Function(Order) actionBuilder;

  @override
  Widget build(BuildContext context) {
    final time = TimeOfDay.fromDateTime(order.createdAt);
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
            children: [
              Expanded(
                child: Text('Commande ${order.id}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              ),
              Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  Text('x${item.quantity}', style: AppTextStyles.caption),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(item.dishName, style: AppTextStyles.body)),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(order.deliveryAddress.street, style: AppTextStyles.caption),
          if (order.deliveryAddress.notes != null)
            Text('Note client: ${order.deliveryAddress.notes}', style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.md),
          actionBuilder(order),
        ],
      ),
    );
  }
}
