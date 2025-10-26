import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/providers/order_providers.dart';
import '../../../core/providers/courier_providers.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/courier.dart';

class OrderTrackingScreen extends ConsumerWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(orderListProvider);
    final activeOrder = _findActiveOrder(orders);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi de commande'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: activeOrder == null
          ? const _EmptyState()
          : _TrackingBody(order: activeOrder),
    );
  }

  Order? _findActiveOrder(List<Order> orders) {
    try {
      return orders.firstWhere(
        (o) =>
            o.customerId == 'customer_001' &&
            o.status != OrderStatus.delivered &&
            o.status != OrderStatus.cancelled,
      );
    } catch (_) {
      return orders.isNotEmpty ? orders.first : null;
    }
  }
}

class _TrackingBody extends ConsumerWidget {
  const _TrackingBody({required this.order});
  final Order order;

  static const _statusFlow = [
    OrderStatus.pending,
    OrderStatus.preparing,
    OrderStatus.readyForPickup,
    OrderStatus.onTheWay,
    OrderStatus.delivered,
  ];

  int get _currentIndex =>
      _statusFlow.indexOf(order.status).clamp(0, _statusFlow.length - 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courier = order.courierId == null
        ? null
        : ref
            .watch(courierListProvider)
            .where((c) => c.id == order.courierId)
            .firstOrNull;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MapPlaceholder(order: order),
          const SizedBox(height: AppSpacing.xl),
          _EtaCard(order: order),
          const SizedBox(height: AppSpacing.xl),
          Text('Timeline', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          _StatusTimeline(currentIndex: _currentIndex),
          const SizedBox(height: AppSpacing.xl),
          Text('Livreur', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          _CourierCard(order: order, courier: courier),
          const SizedBox(height: AppSpacing.xl),
          Text('Adresse de livraison', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          _AddressCard(order: order),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.15), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.map_rounded, size: 120, color: Colors.black12),
          ),
          Positioned(
            top: 32,
            left: 32,
            child: _MapPin(label: 'Cuisine', color: AppColors.primary),
          ),
          Positioned(
            bottom: 32,
            right: 32,
            child: _MapPin(label: order.deliveryAddress.city, color: AppColors.success),
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  const _MapPin({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.location_pin, color: color, size: 32),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption.copyWith(color: color)),
      ],
    );
  }
}

class _EtaCard extends StatelessWidget {
  const _EtaCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final tracking = order.tracking;
    final eta = tracking.etaMinutesRemaining;
    final distance = tracking.distanceMetersRemaining;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.timer, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ETA estimée', style: AppTextStyles.subtitle),
                const SizedBox(height: 4),
                Text(
                  eta != null ? '~$eta minutes restantes' : 'Calcul en cours…',
                  style: AppTextStyles.h2.copyWith(fontSize: 20),
                ),
                if (distance != null)
                  Text(
                    '${(distance / 1000).toStringAsFixed(1)} km restants',
                    style: AppTextStyles.caption,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.currentIndex});
  final int currentIndex;

  static const _labels = [
    'Commande reçue',
    'En préparation',
    'Prête à être récupérée',
    'En route',
    'Livrée',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(_labels.length, (index) {
        final isDone = index <= currentIndex;
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? AppColors.primary : AppColors.placeholder,
          ),
          title: Text(
            _labels[index],
            style: AppTextStyles.body.copyWith(
              color: isDone ? AppColors.textPrimary : AppColors.placeholder,
              fontWeight: isDone ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }),
    );
  }
}

class _CourierCard extends StatelessWidget {
  const _CourierCard({required this.order, required this.courier});
  final Order order;
  final Courier? courier;

  @override
  Widget build(BuildContext context) {
    if (courier == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          color: Colors.white,
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
        ),
        child:
            Text('En attente de l’assignation d’un livreur', style: AppTextStyles.body),
      );
    }
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: Text(
              courier!.name[0],
              style: AppTextStyles.h2.copyWith(color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(courier!.name,
                    style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                Text('${courier!.vehicleType.toUpperCase()} • ${courier!.phone}',
                    style: AppTextStyles.caption),
                Text('Statut: ${courier!.status}', style: AppTextStyles.caption),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.order});
  final Order order;

  @override
  Widget build(BuildContext context) {
    final address = order.deliveryAddress;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        color: Colors.white,
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
          Text(address.contactName,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: AppSpacing.xs),
          Text(address.street, style: AppTextStyles.body),
          Text(address.city, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.sm),
          Text('📞 ${address.contactPhone}', style: AppTextStyles.caption),
          if (address.notes != null)
            Text('Note: ${address.notes}', style: AppTextStyles.caption),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.fastfood, size: 64, color: AppColors.placeholder),
          const SizedBox(height: AppSpacing.md),
          Text('Aucune commande en cours', style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
