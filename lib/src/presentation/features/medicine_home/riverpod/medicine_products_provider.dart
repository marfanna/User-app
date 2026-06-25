import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../home/models/featured_item.dart';
import 'medicine_pharmacies_provider.dart';

/// Raw medicine product feed for the homepage strips.
///
/// Reuses the existing `featured/public/<franchise>` endpoint (the only public
/// product feed available) and filters it down to items belonging to the
/// franchise's open pharmacy shops. Featured and Best Selling strips both
/// derive their lists from this single fetch to avoid duplicate network calls.
final medicineProductsProvider = FutureProvider.autoDispose<List<FeaturedItem>>(
  (ref) async {
    final cache = ref.read(cacheServiceProvider);
    final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
    if (franchiseId == null || franchiseId.isEmpty) return [];

    final shops = await ref.watch(medicinePharmaciesProvider.future);
    final openShopIds = shops.where((s) => s.isOpen).map((s) => s.id).toSet();
    if (openShopIds.isEmpty) return [];

    final dio = ref.read(dioProvider);
    final response = await dio.get('featured/public/$franchiseId');

    final body = response.data;
    List<dynamic> list;
    if (body is List) {
      list = body;
    } else if (body is Map && body['data'] is List) {
      list = body['data'] as List;
    } else {
      list = [];
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(FeaturedItem.fromJson)
        .where((f) => f.item.name.isNotEmpty)
        .where((f) {
          final id = f.shopId.isNotEmpty ? f.shopId : f.shop.id;
          return openShopIds.contains(id);
        })
        .toList();
  },
);

/// Featured medicines — top slice of the medicine product feed.
final medicineFeaturedProvider = FutureProvider.autoDispose<List<FeaturedItem>>(
  (ref) async {
    final items = await ref.watch(medicineProductsProvider.future);
    return items.take(8).toList();
  },
);

/// Best selling medicines.
///
/// TODO(api): bind to a real best-seller endpoint (e.g. sorted by units sold)
/// once available. Until then we derive a stable "popular" ordering from the
/// same medicine feed by price descending and take the tail so it visibly
/// differs from the Featured strip.
final medicineBestSellingProvider =
    FutureProvider.autoDispose<List<FeaturedItem>>((ref) async {
      final items = await ref.watch(medicineProductsProvider.future);
      final sorted = [...items]
        ..sort((a, b) => b.item.price.compareTo(a.item.price));
      return sorted.take(8).toList();
    });
