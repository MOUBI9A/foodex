import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/courier_providers.dart';
import '../../../core/providers/order_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/courier.dart';

class CourierHomeScreen extends ConsumerWidget {
  const CourierHomeScreen({super.key, this.courierId = 'courier_001'});

  final String courierId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couriers = ref.watch(courierListProvider);
    if (couriers.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final courier = couriers.firstWhere((c) => c.id == courierId, orElse: () => couriers.first);
    final orders = ref.watch(orderListProvider);
    final activeOrder = _currentOrder(orders, courier.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Panel Livreurs'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CourierProfileCard(
              courier: courier,
              onStatusChanged: (status) => ref.read(courierListProvider.notifier).setStatus(courier.id, status),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Commande en cours', style: AppTextStyles.h2),
            const SizedBox(height: AppSpacing.md),
            if (activeOrder == null)
              _EmptyOrderState(onRefresh: () => ref.refresh(orderListProvider))
            else
              _ActiveOrderCard(
                order: activeOrder,
                onNavigate: () => _toast(context, 'Navigation simulée 🚴‍♂️'),
                onPickedUp: activeOrder.status == OrderStatus.readyForPickup
                    ? () => ref.read(orderListProvider.notifier).courierMarkPickedUp(activeOrder.id)
                    : null,
                onDelivered: activeOrder.status == OrderStatus.onTheWay
                    ? () => ref.read(orderListProvider.notifier).courierMarkDelivered(activeOrder.id)
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Order? _currentOrder(List<Order> orders, String courierId) {
    try {
      return orders.firstWhere((order) =>
          order.courierId == courierId &&
          order.status != OrderStatus.delivered &&
          order.status != OrderStatus.cancelled);
    } catch (_) {
      return null;
    }
  }

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CourierProfileCard extends StatelessWidget {
  const _CourierProfileCard({required this.courier, required this.onStatusChanged});
  final Courier courier;
  final void Function(String status) onStatusChanged;

  @override
  Widget build(BuildContext context) {
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
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(courier.name[0], style: AppTextStyles.h2.copyWith(color: AppColors.primary)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(courier.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                    Text('${courier.vehicleType.toUpperCase()} • ${courier.phone}', style: AppTextStyles.caption),
                  ],
                ),
              ),
              DropdownButton<String>(
                value: courier.status,
                onChanged: (value) {
                  if (value != null) onStatusChanged(value);
                },
                items: const [
                  DropdownMenuItem(value: 'online', child: Text('En ligne')),
                  DropdownMenuItem(value: 'busy', child: Text('Occupé')),
                  DropdownMenuItem(value: 'offline', child: Text('Hors ligne')),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _MetricTile(label: 'Batterie', value: '${courier.batteryLevel} %')),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _MetricTile(label: 'Livraisons', value: courier.deliveriesCompleted.toString())),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _MetricTile(label: 'Note', value: courier.rating.toStringAsFixed(1))),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        color: AppColors.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTextStyles.h2.copyWith(fontSize: 18)),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({
    required this.order,
    required this.onNavigate,
    this.onPickedUp,
    this.onDelivered,
  });

  final Order order;
  final VoidCallback onNavigate;
  final VoidCallback? onPickedUp;
  final VoidCallback? onDelivered;

  @override
  Widget build(BuildContext context) {
    final address = order.deliveryAddress;
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
          Text('Commande ${order.id}', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.sm),
          Text('Client: ${address.contactName}', style: AppTextStyles.caption),
          Text(address.street, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm),
          _MiniRouteMap(order: order),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              if (onPickedUp != null)
                ElevatedButton.icon(
                  onPressed: onPickedUp,
                  icon: const Icon(Icons.check),
                  label: const Text('Récupéré'),
                ),
              if (onDelivered != null)
                ElevatedButton.icon(
                  onPressed: onDelivered,
                  icon: const Icon(Icons.flag),
                  label: const Text('Livré'),
                ),
              OutlinedButton.icon(
                onPressed: onNavigate,
                icon: const Icon(Icons.navigation),
                label: const Text('Naviguer'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniRouteMap extends StatelessWidget {
  const _MiniRouteMap({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final tracking = order.tracking;
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.md),
        gradient: LinearGradient(
          colors: [AppColors.secondary.withValues(alpha: 0.15), Colors.white],
        ),
      ),
      child: Stack(
        children: [
          const Center(child: Icon(Icons.map, color: Colors.black12, size: 96)),
          Positioned(
            top: 20,
            left: 20,
            child: Chip(label: Text('Chef ${order.chefId}')),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Chip(label: Text(order.deliveryAddress.city)),
          ),
          if (tracking.courierLat != null && tracking.courierLng != null)
            Align(
              alignment: Alignment.center,
              child: Chip(
                avatar: const Icon(Icons.pedal_bike, size: 16),
                label: Text(tracking.etaMinutesRemaining != null
                    ? '~${tracking.etaMinutesRemaining} min'
                    : 'En route'),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyOrderState extends StatelessWidget {
  const _EmptyOrderState({required this.onRefresh});
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          Icon(Icons.motorcycle, size: 64, color: AppColors.placeholder),
          const SizedBox(height: AppSpacing.md),
          Text('En attente d’une livraison', style: AppTextStyles.subtitle),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualiser'),
          ),
        ],
      ),
    );
  }
}
