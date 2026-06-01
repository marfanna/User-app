import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/cart_item_model.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import 'package:flutter/foundation.dart';

part 'cart_provider.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItemModel> build() {
    return [];
  }

  void addItem({
    required ApiMenuItemData item,
    required String shopName,
    required String shopId,
    required int quantity,
    MenuItemVariant? selectedVariant,
    required Map<String, String> selectedChoices,
  }) {
    final existingIndex = state.indexWhere((c) =>
        c.item.id == item.id &&
        c.selectedVariant?.id == selectedVariant?.id &&
        mapEquals(c.selectedChoices, selectedChoices));

    if (existingIndex != -1) {
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      final newItem = CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        item: item,
        shopName: shopName,
        shopId: shopId,
        quantity: quantity,
        selectedVariant: selectedVariant,
        selectedChoices: Map.from(selectedChoices),
      );
      state = [...state, newItem];
    }
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cartItemId);
      return;
    }
    
    state = state.map((c) {
      if (c.id == cartItemId) {
        return c.copyWith(quantity: newQuantity);
      }
      return c;
    }).toList();
  }

  void removeItem(String cartItemId) {
    state = state.where((c) => c.id != cartItemId).toList();
  }

  void clearCart() {
    state = [];
  }

  double get subtotal {
    return state.fold(0, (total, item) => total + item.totalPrice);
  }
  
  double get total {
    // Could add delivery charge logic here if needed
    return subtotal;
  }
}
