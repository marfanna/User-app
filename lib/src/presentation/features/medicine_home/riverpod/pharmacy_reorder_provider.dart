import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../orders/models/customer_order_model.dart';
import '../../orders/riverpod/customer_orders_provider.dart';
import 'medicine_category_provider.dart';

/// Past pharmacy orders for the "Order again" strip.
///
/// Filters the user's order history down to the resolved medicine category so
/// the medicine homepage never shows food/laundry reorders. Requires the API
/// to populate the shop category on the order (see
/// [CustomerOrderModel.shopCategory]). If that field is absent the strip
/// resolves empty and the section auto-hides.
final pharmacyReorderProvider =
    FutureProvider.autoDispose<List<CustomerOrderModel>>((ref) async {
      final orders = await ref.watch(customerOrdersProvider.future);
      final category = await ref.watch(medicinePharmacyCategoryProvider.future);
      final target = category.toLowerCase();

      return orders.where((o) {
        final cat = o.shopCategory?.toLowerCase();
        if (cat == null) return false;
        return cat == target || cat.contains('pharmac') || cat == 'medicine';
      }).toList();
    });
