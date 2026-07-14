import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../orders/models/customer_order_model.dart';
import '../../orders/riverpod/customer_orders_provider.dart';

/// Past Mart orders for the "Order again" strip. Mirrors
/// `pharmacyReorderProvider` — filters order history down to `mart`, auto-
/// hides if the API doesn't populate the shop category on the order.
final martReorderProvider =
    FutureProvider.autoDispose<List<CustomerOrderModel>>((ref) async {
      final orders = await ref.watch(customerOrdersProvider.future);
      return orders
          .where((o) => o.shopCategory?.toLowerCase() == 'mart')
          .toList();
    });
