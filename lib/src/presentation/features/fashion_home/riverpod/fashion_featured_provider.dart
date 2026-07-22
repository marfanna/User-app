import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../home/models/featured_item.dart';
import 'fashion_shops_provider.dart';

/// Raw Fashion product feed for the homepage strips. Mirrors
/// `martProductFeedProvider` — reuses the generic `featured/public/<franchise>`
/// feed filtered to open Fashion shops.
final fashionProductFeedProvider =
    FutureProvider.autoDispose<List<FeaturedItem>>((ref) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  final shops = await ref.watch(fashionShopsProvider.future);
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
});

final fashionFeaturedProvider =
    FutureProvider.autoDispose<List<FeaturedItem>>((ref) async {
  final items = await ref.watch(fashionProductFeedProvider.future);
  return items.take(8).toList();
});

/// Best selling Fashion products — same honest price-desc proxy as Mart
/// until a real best-seller endpoint exists.
final fashionBestSellingProvider =
    FutureProvider.autoDispose<List<FeaturedItem>>((ref) async {
  final items = await ref.watch(fashionProductFeedProvider.future);
  final sorted = [...items]
    ..sort((a, b) => b.item.price.compareTo(a.item.price));
  return sorted.take(8).toList();
});
