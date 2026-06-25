import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/medicine_product_detail.dart';
import 'medicine_pharmacies_provider.dart';

/// A listing row: the product plus the name of the pharmacy that sells it
/// (the grid tile needs it — the product API returns `shop` as a bare id).
class MedicineListingItem {
  const MedicineListingItem({required this.product, required this.shopName});

  final MedicineProductDetail product;
  final String shopName;
}

/// Cross-pharmacy products for one medicine category (e.g. "Antibiotic").
///
/// No franchise-wide medicine endpoint exists — only shop-scoped ones. So this
/// fans out across the franchise's pharmacies, asking each
/// `GET /medicine-products/shop/:shopId?category=<label>` so the **server**
/// filters by `itemCategory`. This is essential at scale: a pharmacy can hold
/// tens of thousands of products, so fetching a page and filtering client-side
/// would miss everything past the first page. [categoryLabel] is the exact
/// value from `/categories` (what the homepage tiles are built from), so the
/// server's exact match hits.
final medicineListingProvider = FutureProvider.autoDispose
    .family<List<MedicineListingItem>, String>((ref, categoryLabel) async {
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
                'limit': '50',
                'category': categoryLabel,
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
                  (p) =>
                      MedicineListingItem(product: p, shopName: shop.name),
                )
                .toList();
          } catch (_) {
            // One pharmacy failing shouldn't blank the whole listing.
            return <MedicineListingItem>[];
          }
        }),
      );

      final merged = results.expand((e) => e).toList();
      // In-stock first; out-of-stock (greyed) sink to the bottom.
      merged.sort((a, b) {
        final av = a.product.inStock ? 0 : 1;
        final bv = b.product.inStock ? 0 : 1;
        return av.compareTo(bv);
      });
      return merged;
    });
