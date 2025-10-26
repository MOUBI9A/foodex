import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/order_model.dart';
import '../../data/models/dish.dart';
import '../../data/models/chef_profile.dart';
import '../providers/dish_providers.dart';
import '../../features/chef/providers/ingredient_provider.dart';
import 'chef_directory_provider.dart';
import 'courier_providers.dart';
import 'service_providers.dart';

final orderListProvider = StateNotifierProvider<OrderListNotifier, List<Order>>((ref) {
  return OrderListNotifier(ref: ref);
});

class OrderListNotifier extends StateNotifier<List<Order>> {
  OrderListNotifier({required this.ref}) : super(const []) {
    _bootstrap();
  }

  final Ref ref;

  Future<void> _bootstrap() async {
    final directory = ref.read(chefDirectoryProvider);
    state = _seedOrders(directory);
  }

  Future<void> createOrder(
    String customerId, {
    required List<OrderedDish> items,
    required DeliveryAddress deliveryAddress,
    required String chefId,
  }) async {
    final now = DateTime.now();
    final newOrder = Order(
      id: 'order_${state.length + 1}',
      customerId: customerId,
      chefId: chefId,
      items: items,
      deliveryAddress: deliveryAddress,
      status: OrderStatus.pending,
      createdAt: now,
      tracking: TrackingInfo(
        etaMinutesRemaining: null,
        distanceMetersRemaining: null,
        lastUpdate: now,
      ),
    );
    state = [...state, newOrder];
  }

  Future<void> chefAcceptOrder(String orderId) async {
    final order = _getOrder(orderId);
    final now = DateTime.now();
    await _consumeIngredients(order);
    _persist(
      order.copyWith(
        status: OrderStatus.preparing,
        acceptedAt: now,
        cancellationReason: null,
      ),
    );
  }

  Future<void> chefMarkReady(String orderId) async {
    final order = _getOrder(orderId);
    final now = DateTime.now();
    final updatedTracking = _updateEta(order, now);
    _persist(
      order.copyWith(
        status: OrderStatus.readyForPickup,
        readyAt: now,
        tracking: updatedTracking,
        cancellationReason: null,
      ),
    );
  }

  Future<void> chefRejectOrder(String orderId, {String? reason}) async {
    final order = _getOrder(orderId);
    _persist(
      order.copyWith(
        status: OrderStatus.cancelled,
        cancellationReason: reason ?? 'Commande rejetée par le chef',
      ),
    );
  }

  Future<void> assignCourier(String orderId, String courierId) async {
    final order = _getOrder(orderId);
    ref.read(courierListProvider.notifier).attachOrder(courierId, orderId);
    final updatedTracking = order.tracking.copyWith(lastUpdate: DateTime.now());
    _persist(order.copyWith(courierId: courierId, tracking: updatedTracking));
  }

  Future<void> courierMarkPickedUp(String orderId) async {
    final order = _getOrder(orderId);
    if (order.courierId == null) return;
    final now = DateTime.now();
    final tracking = _updateEta(order, now).copyWith(lastUpdate: now);
    _persist(
      order.copyWith(
        status: OrderStatus.onTheWay,
        pickedUpAt: now,
        tracking: tracking,
      ),
    );
    ref.read(courierListProvider.notifier).setStatus(order.courierId!, 'busy');
  }

  Future<void> courierMarkDelivered(String orderId) async {
    final order = _getOrder(orderId);
    final now = DateTime.now();
    _persist(
      order.copyWith(
        status: OrderStatus.delivered,
        deliveredAt: now,
        tracking: order.tracking.copyWith(
          etaMinutesRemaining: 0,
          distanceMetersRemaining: 0,
          lastUpdate: now,
        ),
        cancellationReason: null,
      ),
    );
    if (order.courierId != null) {
      ref.read(courierListProvider.notifier).clearOrder(order.courierId!);
    }
  }

  Order _getOrder(String orderId) {
    return state.firstWhere((order) => order.id == orderId);
  }

  void _persist(Order updated) {
    state = [
      for (final order in state) if (order.id == updated.id) updated else order,
    ];
  }

  Future<void> _consumeIngredients(Order order) async {
    final dishes = await ref.read(dishListProvider.future);
    final usage = _calculateIngredientUsage(order, dishes);
    await ref.read(ingredientListProvider.notifier).consumeIngredients(usage);
  }

  Map<String, double> _calculateIngredientUsage(Order order, List<Dish> dishes) {
    final dishMap = {for (final dish in dishes) dish.id: dish};
    final usage = <String, double>{};
    for (final item in order.items) {
      final dish = dishMap[item.dishId];
      if (dish == null) continue;
      for (final ingredient in dish.ingredients) {
        usage.update(
          ingredient.ingredientId,
          (value) => value + ingredient.qty * item.quantity,
          ifAbsent: () => ingredient.qty * item.quantity,
        );
      }
    }
    return usage;
  }

  TrackingInfo _updateEta(Order order, DateTime reference) {
    final directory = ref.read(chefDirectoryProvider);
    final chef = directory[order.chefId];
    final estimateService = ref.read(deliveryEstimateServiceProvider);
    final estimate = estimateService.estimate(
      prepMinutes: _inferPrepMinutes(order),
      chefLat: chef?.lat ?? 33.5899,
      chefLng: chef?.lng ?? -7.6039,
      destLat: order.deliveryAddress.lat,
      destLng: order.deliveryAddress.lng,
    );
    return order.tracking.copyWith(
      etaMinutesRemaining: estimate.totalMinutes,
      distanceMetersRemaining: estimate.travelMinutes * 250.0,
      lastUpdate: reference,
    );
  }

  int _inferPrepMinutes(Order order) {
    final dishesAsync = ref.read(dishListProvider);
    return dishesAsync.maybeWhen(
      data: (dishes) {
        if (dishes.isEmpty) return 20;
        final durations = <int>[];
        for (final item in order.items) {
          final dish = dishes.firstWhere(
            (d) => d.id == item.dishId,
            orElse: () => dishes.first,
          );
          durations.add(dish.prepTime);
        }
        final avg = durations.isEmpty ? 20 : durations.reduce((a, b) => a + b) ~/ durations.length;
        return avg;
      },
      orElse: () => 20,
    );
  }

  List<Order> _seedOrders(Map<String, ChefProfile> directory) {
    final now = DateTime.now();
    return [
      Order(
        id: 'order_001',
        customerId: 'customer_001',
        chefId: 'chef_001',
        items: const [
          OrderedDish(dishId: 'dish-001', dishName: 'Chicken Tagine', quantity: 2, customNotes: ['Peu salé']),
        ],
        deliveryAddress: const DeliveryAddress(
          street: '12 Rue des Oudayas',
          city: 'Casablanca',
          lat: 33.5731,
          lng: -7.5898,
          contactName: 'Nadia',
          contactPhone: '+212611112222',
          notes: 'Interphone 24',
        ),
        status: OrderStatus.readyForPickup,
        createdAt: now.subtract(const Duration(minutes: 40)),
        acceptedAt: now.subtract(const Duration(minutes: 30)),
        readyAt: now.subtract(const Duration(minutes: 5)),
        tracking: TrackingInfo(
          etaMinutesRemaining: 24,
          distanceMetersRemaining: 3200,
          lastUpdate: now.subtract(const Duration(minutes: 1)),
          courierLat: directory['chef_001']?.lat,
          courierLng: directory['chef_001']?.lng,
        ),
      ),
      Order(
        id: 'order_002',
        customerId: 'customer_002',
        chefId: 'chef_002',
        courierId: 'courier_002',
        items: const [
          OrderedDish(dishId: 'dish-002', dishName: 'Moroccan Salad', quantity: 1),
          OrderedDish(dishId: 'dish-003', dishName: 'Veg Couscous', quantity: 1),
        ],
        deliveryAddress: const DeliveryAddress(
          street: '33 Avenue Hassan II',
          city: 'Casablanca',
          lat: 33.5902,
          lng: -7.6202,
          contactName: 'Hassan',
          contactPhone: '+212633334444',
          notes: 'Bureau 8e étage',
        ),
        status: OrderStatus.onTheWay,
        createdAt: now.subtract(const Duration(minutes: 55)),
        acceptedAt: now.subtract(const Duration(minutes: 40)),
        readyAt: now.subtract(const Duration(minutes: 25)),
        pickedUpAt: now.subtract(const Duration(minutes: 10)),
        tracking: TrackingInfo(
          etaMinutesRemaining: 12,
          distanceMetersRemaining: 1800,
          courierLat: 33.586,
          courierLng: -7.612,
          lastUpdate: now.subtract(const Duration(minutes: 2)),
        ),
      ),
      Order(
        id: 'order_003',
        customerId: 'customer_003',
        chefId: 'chef_003',
        items: const [
          OrderedDish(dishId: 'dish-003', dishName: 'Veg Couscous', quantity: 1),
        ],
        deliveryAddress: const DeliveryAddress(
          street: '2 Rue Oum Errabia',
          city: 'Casablanca',
          lat: 33.5981,
          lng: -7.6401,
          contactName: 'Zineb',
          contactPhone: '+212655556666',
          notes: null,
        ),
        status: OrderStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 10)),
        tracking: const TrackingInfo(),
      ),
    ];
  }
}
