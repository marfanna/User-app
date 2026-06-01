import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../core/models/order_details_ui_model.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';

typedef ReOrderResult = ({int added, int skipped});

class ReOrderNotifier extends Notifier<AsyncValue<ReOrderResult?>> {
  @override
  AsyncValue<ReOrderResult?> build() => const AsyncData(null);

  Future<ReOrderResult> reOrder(OrderDetailsUIModel order) async {
    state = const AsyncLoading();
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('menu/shop/${order.shopId}');
      final data = response.data['data'] as Map<String, dynamic>;
      final menu = MenuData.fromJson(data);

      final itemMap = {
        for (final item in menu.categories.expand((c) => c.items)) item.id: item
      };

      final cart = ref.read(cartProvider.notifier);
      cart.clearCart();

      int added = 0;
      int skipped = 0;

      for (final orderItem in order.items) {
        final menuItem = itemMap[orderItem.itemId];
        if (menuItem == null || !menuItem.isAvailable) {
          skipped++;
          continue;
        }

        MenuItemVariant? variant;
        if (orderItem.portion.isNotEmpty) {
          variant = menuItem.variants
              .where((v) => v.name == orderItem.portion)
              .firstOrNull;
        }
        if (variant == null && menuItem.variants.isNotEmpty) {
          variant = menuItem.variants.firstWhere(
            (v) => v.isDefault,
            orElse: () => menuItem.variants.first,
          );
        }

        cart.addItem(
          item: menuItem,
          shopName: order.shopName,
          shopId: order.shopId,
          quantity: orderItem.qty,
          selectedVariant: variant,
          selectedChoices: {},
        );
        added++;
      }

      final result = (added: added, skipped: skipped);
      state = AsyncData(result);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }
}

final reOrderProvider =
    NotifierProvider<ReOrderNotifier, AsyncValue<ReOrderResult?>>(
  ReOrderNotifier.new,
);
