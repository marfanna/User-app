import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../models/featured_item.dart';
import 'restaurants_provider.dart';

final bestDealsProvider = FutureProvider.autoDispose<List<FeaturedItem>>((
  ref,
) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  // Watch the shops to filter featured items by shop status (active and open)
  final shopsAsync = ref.watch(restaurantsProvider);
  final shops = shopsAsync.value ?? [];
  final openShopIds = shops.where((s) => s.isOpen).map((s) => s.id).toSet();

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

  final items = list
      .whereType<Map<String, dynamic>>()
      .map(FeaturedItem.fromJson)
      .where((f) => f.item.name.isNotEmpty)
      .where((f) {
        final id = f.shopId.isNotEmpty ? f.shopId : f.shop.id;
        return openShopIds.contains(id);
      })
      .toList();

  // Shuffle so the spotlight shows items in a different order each visit
  // (provider is autoDispose → re-shuffles whenever home reloads).
  items.shuffle();
  return items;
});
