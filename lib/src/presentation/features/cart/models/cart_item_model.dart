import 'package:flutter/foundation.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';

class CartItemModel {

  CartItemModel({
    required this.id,
    required this.item,
    required this.shopName,
    required this.shopId,
    this.selectedVariant,
    required this.selectedChoices,
    required this.quantity,
  });
  final String id;
  final ApiMenuItemData item;
  final String shopName;
  final String shopId;
  final MenuItemVariant? selectedVariant;
  final Map<String, String> selectedChoices;
  final int quantity;

  double get basePrice => selectedVariant?.price ?? item.price;

  double get optionsTotal {
    double total = 0;
    for (final opt in item.options) {
      final choiceId = selectedChoices[opt.id];
      if (choiceId != null) {
        final choice = opt.choices.where((c) => c.id == choiceId).firstOrNull;
        if (choice != null) total += choice.price;
      }
    }
    return total;
  }

  double get unitPrice => basePrice + optionsTotal;
  double get totalPrice => unitPrice * quantity;

  CartItemModel copyWith({
    String? id,
    ApiMenuItemData? item,
    String? shopName,
    String? shopId,
    MenuItemVariant? selectedVariant,
    Map<String, String>? selectedChoices,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      item: item ?? this.item,
      shopName: shopName ?? this.shopName,
      shopId: shopId ?? this.shopId,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedChoices: selectedChoices ?? this.selectedChoices,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.id == id &&
        other.item.id == item.id &&
        other.quantity == quantity &&
        mapEquals(other.selectedChoices, selectedChoices);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        item.id.hashCode ^
        quantity.hashCode ^
        selectedChoices.hashCode;
  }
}
