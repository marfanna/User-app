import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/mart_product.dart';
import 'mart_shops_provider.dart';

/// A product plus which shop sells it — `Product` items are embedded per
/// shop, the API never returns a shop name alongside an item.
class MartCatalogItem {
  const MartCatalogItem({
    required this.product,
    required this.shopId,
    required this.shopName,
  });

  final MartProduct product;
  final String shopId;
  final String shopName;
}

/// Every product across every Mart shop in the franchise, flattened.
///
/// `Product` has no franchise-wide or category-filtered endpoint (only
/// `GET /products/public/shop/:shopId`, whole container) — so this fans out
/// once across all Mart shops and everything else (categories, category
/// previews, listing) derives from this single fetch instead of calling the
/// API again per section.
final martProductsProvider = FutureProvider.autoDispose<List<MartCatalogItem>>(
  (ref) async {
    final shops = await ref.watch(martShopsProvider.future);
    if (shops.isEmpty) return [];

    final dio = ref.read(dioProvider);

    final results = await Future.wait(
      shops.map((shop) async {
        try {
          final response = await dio.get('products/public/shop/${shop.id}');
          final body = response.data as Map<String, dynamic>;
          final data = body['data'] as Map<String, dynamic>?;
          final items = data?['items'] as List<dynamic>?;
          if (items == null) return <MartCatalogItem>[];
          return items
              .whereType<Map<String, dynamic>>()
              .map(MartProduct.fromJson)
              .where((p) => p.name.isNotEmpty)
              .map(
                (p) => MartCatalogItem(
                  product: p,
                  shopId: shop.id,
                  shopName: shop.name,
                ),
              )
              .toList();
        } catch (_) {
          // One shop failing shouldn't blank the whole catalogue.
          return <MartCatalogItem>[];
        }
      }),
    );

    return results.expand((e) => e).toList();
  },
);

/// Shared with [MartCategorySection] so the meat/fish sort here and the
/// meat/fish visual framing there stay in sync off one definition.
bool isMeatCategory(String c) {
  final v = c.toLowerCase();
  return v.contains('meat') || v.contains('fish');
}

/// Real, data-driven `itemCategory` values across every Mart shop — never
/// hardcoded (admin types this field freely). "Fish & Meat"-like categories
/// are pinned first, ahead of alphabetical order — the stated business focus.
final martCategoriesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final items = await ref.watch(martProductsProvider.future);

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

  final meat = out.where(isMeatCategory).toList();
  final rest = out.where((c) => !isMeatCategory(c)).toList();
  return [...meat, ...rest];
});

/// Up to 6 products for one category's homepage strip.
final martCategoryPreviewProvider = FutureProvider.autoDispose
    .family<List<MartCatalogItem>, String>((ref, category) async {
      final items = await ref.watch(martProductsProvider.future);
      final key = category.trim().toLowerCase();
      return items
          .where((i) => i.product.itemCategory?.trim().toLowerCase() == key)
          .take(6)
          .toList();
    });

/// All products across the franchise for one category — "See all".
final martListingProvider = FutureProvider.autoDispose
    .family<List<MartCatalogItem>, String>((ref, category) async {
      final items = await ref.watch(martProductsProvider.future);
      final key = category.trim().toLowerCase();
      return items
          .where((i) => i.product.itemCategory?.trim().toLowerCase() == key)
          .toList();
    });
