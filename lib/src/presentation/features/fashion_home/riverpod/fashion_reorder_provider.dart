import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../orders/models/customer_order_model.dart';
import '../../orders/riverpod/customer_orders_provider.dart';

/// Past Fashion orders for the "Order again" strip. Mirrors
/// `martReorderProvider` — filters order history down to `fashion`, auto-hides
/// if the API doesn't populate the shop category on the order.
final fashionReorderProvider =
    FutureProvider.autoDispose<List<CustomerOrderModel>>((ref) async {
  final orders = await ref.watch(customerOrdersProvider.future);
  return orders
      .where((o) => o.shopCategory?.toLowerCase() == 'fashion')
      .toList();
});
