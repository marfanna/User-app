import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/fashion_product.dart';
import 'fashion_shops_provider.dart';

/// A product plus which shop sells it — `Product` items are embedded per
/// shop, the API never returns a shop name alongside an item.
class FashionCatalogItem {
  const FashionCatalogItem({
    required this.product,
    required this.shopId,
    required this.shopName,
  });

  final FashionProduct product;
  final String shopId;
  final String shopName;
}

/// Every product across every Fashion shop in the franchise, flattened.
///
/// `Product` has no franchise-wide or category-filtered endpoint (only
/// `GET /products/public/shop/:shopId`, whole container) — so this fans out
/// once across all Fashion shops and everything else (categories, previews,
/// listing) derives from this single fetch, same shape as Mart.
final fashionProductsProvider =
    FutureProvider.autoDispose<List<FashionCatalogItem>>((ref) async {
      final shops = await ref.watch(fashionShopsProvider.future);
      if (shops.isEmpty) return [];

      final dio = ref.read(dioProvider);

      final results = await Future.wait(
        shops.map((shop) async {
          try {
            final response = await dio.get('products/public/shop/${shop.id}');
            final body = response.data as Map<String, dynamic>;
            final data = body['data'] as Map<String, dynamic>?;
            final items = data?['items'] as List<dynamic>?;
            if (items == null) return <FashionCatalogItem>[];
            return items
                .whereType<Map<String, dynamic>>()
                .map(FashionProduct.fromJson)
                .where((p) => p.name.isNotEmpty)
                .map(
                  (p) => FashionCatalogItem(
                    product: p,
                    shopId: shop.id,
                    shopName: shop.name,
                  ),
                )
                .toList();
          } catch (_) {
            // One shop failing shouldn't blank the whole catalogue.
            return <FashionCatalogItem>[];
          }
        }),
      );

      return results.expand((e) => e).toList();
    });

/// Real, data-driven `itemCategory` values across every Fashion shop — never
/// hardcoded (admin types this field freely). Alpha sorted.
final fashionCategoriesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final items = await ref.watch(fashionProductsProvider.future);

  final seen = <String>{};
  final out = <String>[];
  for (final item in items) {
    final cat = item.product.itemCategory?.trim();
    if (cat == null || cat.isEmpty) continue;
    final key = cat.toLowerCase();
    if (seen.contains(key)) continue;
    seen.add(key);
    out.add(cat);
  }
  out.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return out;
});

/// Up to 6 products for one category's homepage strip.
final fashionCategoryPreviewProvider = FutureProvider.autoDispose
    .family<List<FashionCatalogItem>, String>((ref, category) async {
      final items = await ref.watch(fashionProductsProvider.future);
      final key = category.trim().toLowerCase();
      return items
          .where((i) => i.product.itemCategory?.trim().toLowerCase() == key)
          .take(6)
          .toList();
    });

/// All products across the franchise for one category — "See all".
final fashionListingProvider = FutureProvider.autoDispose
    .family<List<FashionCatalogItem>, String>((ref, category) async {
      final items = await ref.watch(fashionProductsProvider.future);
      final key = category.trim().toLowerCase();
      return items
          .where((i) => i.product.itemCategory?.trim().toLowerCase() == key)
          .toList();
    });
