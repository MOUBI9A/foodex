import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/order_providers.dart';
import '../../../core/providers/courier_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/order_model.dart';
import '../../../data/models/courier.dart';

class AdminDeliveriesScreen extends ConsumerStatefulWidget {
  const AdminDeliveriesScreen({super.key});

  @override
  ConsumerState<AdminDeliveriesScreen> createState() => _AdminDeliveriesScreenState();
}

class _AdminDeliveriesScreenState extends ConsumerState<AdminDeliveriesScreen> {
  final Map<String, String?> _selections = {};

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(orderListProvider);
    final assignable = orders
        .where((order) =>
            order.status == OrderStatus.readyForPickup &&
            (order.courierId == null || order.courierId!.isEmpty))
        .toList();
    final couriers = ref.watch(courierListProvider);
    final availableCouriers =
        couriers.where((c) => c.status == 'online' && c.currentOrderId == null).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assignation des livreurs'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: assignable.isEmpty
          ? const _NoDeliveries()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStatePropertyAll(AppColors.primary.withValues(alpha: 0.1)),
                  columns: const [
                    DataColumn(label: Text('Commande')),
                    DataColumn(label: Text('Chef / Pickup')),
                    DataColumn(label: Text('Client / Adresse')),
                    DataColumn(label: Text('ETA')),
                    DataColumn(label: Text('Livreur')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: assignable
                      .map(
                        (order) => DataRow(
                          cells: [
                            DataCell(Text(order.id)),
                            DataCell(Text('${order.chefId}\n${order.deliveryAddress.city}')),
                            DataCell(Text(
                                '${order.deliveryAddress.contactName}\n${order.deliveryAddress.street}')),
                            DataCell(Text(order.tracking.etaMinutesRemaining != null
                                ? '~${order.tracking.etaMinutesRemaining} min'
                                : '—')),
                            DataCell(_CourierDropdown(
                              orderId: order.id,
                              available: availableCouriers,
                              value: _selections[order.id],
                              onChanged: (value) => setState(() => _selections[order.id] = value),
                            )),
                            DataCell(
                              ElevatedButton(
                                onPressed: _selections[order.id] == null
                                    ? null
                                    : () => _assign(order.id, _selections[order.id]!),
                                child: const Text('Assigner'),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }

  Future<void> _assign(String orderId, String courierId) async {
    await ref.read(orderListProvider.notifier).assignCourier(orderId, courierId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Livreur assigné à $orderId')),
      );
    }
    setState(() {
      _selections.remove(orderId);
    });
  }
}

class _CourierDropdown extends StatelessWidget {
  const _CourierDropdown({
    required this.orderId,
    required this.available,
    required this.value,
    required this.onChanged,
  });

  final String orderId;
  final List<Courier> available;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (available.isEmpty) {
      return Text('Aucun livreur libre', style: AppTextStyles.caption.copyWith(color: AppColors.error));
    }
    return DropdownButton<String>(
      value: value,
      hint: const Text('Choisir'),
      onChanged: onChanged,
      items: available
          .map(
            (courier) => DropdownMenuItem(
              value: courier.id,
              child: Text('${courier.name} (${courier.vehicleType})'),
            ),
          )
          .toList(),
    );
  }
}

class _NoDeliveries extends StatelessWidget {
  const _NoDeliveries();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_shipping_outlined, size: 72, color: AppColors.placeholder),
          const SizedBox(height: AppSpacing.md),
          Text('Aucune commande en attente de livreur', style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}
