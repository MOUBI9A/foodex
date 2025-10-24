import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/menu_item_entity.dart';

/// Cart item with quantity
class CartItem {
  final MenuItemEntity menuItem;
  final int quantity;
  final Map<String, dynamic>? customizations;
  final String? specialInstructions;

  const CartItem({
    required this.menuItem,
    required this.quantity,
    this.customizations,
    this.specialInstructions,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItem copyWith({
    MenuItemEntity? menuItem,
    int? quantity,
    Map<String, dynamic>? customizations,
    String? specialInstructions,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      customizations: customizations ?? this.customizations,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

/// Cart state
class CartState {
  final List<CartItem> items;
  final String? restaurantId;
  final String? restaurantName;
  final String? promoCode;
  final double discount;

  const CartState({
    this.items = const [],
    this.restaurantId,
    this.restaurantName,
    this.promoCode,
    this.discount = 0.0,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => subtotal > 50 ? 0 : 5.0; // Free delivery over $50

  double get serviceFee => subtotal * 0.05; // 5% service fee

  double get tax => subtotal * 0.08; // 8% tax

  double get total => subtotal + deliveryFee + serviceFee + tax - discount;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    List<CartItem>? items,
    String? restaurantId,
    String? restaurantName,
    String? promoCode,
    double? discount,
  }) {
    return CartState(
      items: items ?? this.items,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
    );
  }
}

/// Cart provider
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(
    MenuItemEntity menuItem, {
    Map<String, dynamic>? customizations,
    String? specialInstructions,
  }) {
    // Check if adding from different restaurant
    if (state.restaurantId != null &&
        state.restaurantId != menuItem.restaurantId &&
        state.items.isNotEmpty) {
      // Clear cart if switching restaurants
      clearCart();
    }

    final existingIndex = state.items.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    List<CartItem> updatedItems;

    if (existingIndex >= 0) {
      // Update quantity of existing item
      updatedItems = List.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
    } else {
      // Add new item
      updatedItems = [
        ...state.items,
        CartItem(
          menuItem: menuItem,
          quantity: 1,
          customizations: customizations,
          specialInstructions: specialInstructions,
        ),
      ];
    }

    state = state.copyWith(
      items: updatedItems,
      restaurantId: menuItem.restaurantId,
    );
  }

  void removeItem(String menuItemId) {
    final updatedItems =
        state.items.where((item) => item.menuItem.id != menuItemId).toList();

    state = state.copyWith(
      items: updatedItems,
      restaurantId: updatedItems.isEmpty ? null : state.restaurantId,
      restaurantName: updatedItems.isEmpty ? null : state.restaurantName,
    );
  }

  void updateQuantity(String menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.menuItem.id == menuItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = state.copyWith(items: updatedItems);
  }

  void incrementQuantity(String menuItemId) {
    final item = state.items.firstWhere(
      (item) => item.menuItem.id == menuItemId,
    );
    updateQuantity(menuItemId, item.quantity + 1);
  }

  void decrementQuantity(String menuItemId) {
    final item = state.items.firstWhere(
      (item) => item.menuItem.id == menuItemId,
    );
    updateQuantity(menuItemId, item.quantity - 1);
  }

  void clearCart() {
    state = const CartState();
  }

  void applyPromoCode(String code) {
    // This would typically validate the promo code with backend
    // For now, apply a fixed 10% discount
    final discount = state.subtotal * 0.1;
    state = state.copyWith(
      promoCode: code,
      discount: discount,
    );
  }

  void removePromoCode() {
    state = state.copyWith(
      promoCode: null,
      discount: 0.0,
    );
  }

  void setRestaurantInfo(String restaurantId, String restaurantName) {
    state = state.copyWith(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
    );
  }
}

/// Cart state provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

/// Convenience providers
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).total;
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).subtotal;
});

final isCartEmptyProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isEmpty;
});
