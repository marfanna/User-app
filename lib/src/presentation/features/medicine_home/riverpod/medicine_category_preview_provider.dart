import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/medicine_product_detail.dart';
import 'medicine_listing_provider.dart';
import 'medicine_pharmacies_provider.dart';

/// Up to 6 products for one medicine category, for its homepage strip.
///
/// Fans out across the franchise's pharmacies asking each for 6 server-filtered
/// products (`?category=<label>&limit=6`), merges, trims to 6. autoDispose +
/// family so each section only fires when it scrolls into view, then frees.
final medicineCategoryPreviewProvider = FutureProvider.autoDispose
    .family<List<MedicineListingItem>, String>((ref, category) async {
      final shops = await ref.watch(medicinePharmaciesProvider.future);
      if (shops.isEmpty) return [];

      final dio = ref.read(dioProvider);

      final results = await Future.wait(
        shops.map((shop) async {
          try {
            final response = await dio.get(
              'medicine-products/shop/${shop.id}',
              queryParameters: {
                'page': '1',
                'limit': '6',
                'category': category,
                'sortBy': 'name',
                'sortOrder': 'asc',
              },
            );
            final body = response.data as Map<String, dynamic>;
            final raw = body['data'];
            final list = raw is List ? raw : const [];
            return list
                .whereType<Map<String, dynamic>>()
                .map(MedicineProductDetail.fromJson)
                .where((p) => p.name.isNotEmpty)
                .map(
                  (p) => MedicineListingItem(
                    product: p,
                    shopName: shop.name,
                  ),
                )
                .toList();
          } catch (_) {
            return <MedicineListingItem>[];
          }
        }),
      );

      final merged = results.expand((e) => e).toList();
      merged.sort((a, b) {
        final av = a.product.inStock ? 0 : 1;
        final bv = b.product.inStock ? 0 : 1;
        return av.compareTo(bv);
      });
      return merged.take(6).toList();
    });
