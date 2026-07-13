import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../models/shop_data.dart';

/// Restaurants under the "Homemade / Cloud Kitchen" delivery mode —
/// cooked to order, delivered next day (as opposed to instant delivery).
final homemadeShopsProvider = FutureProvider.autoDispose<List<ShopData>>((
  ref,
) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  final dio = ref.read(dioProvider);
  final response = await dio.get(
    'shops/public/get-all-shops',
    queryParameters: {
      'franchise': franchiseId,
      'category': 'restaurant',
      'deliveryMode': 'scheduled',
      'isActive': 'true',
      'status': 'active',
      'limit': '50',
      'sortBy': 'createdAt',
      'sortOrder': 'asc',
    },
  );

  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  List<dynamic> list;
  if (raw is List) {
    list = raw;
  } else if (raw is Map && raw['shops'] is List) {
    list = raw['shops'] as List;
  } else {
    list = [];
  }

  return list
      .whereType<Map<String, dynamic>>()
      .map(ShopData.fromJson)
      .where((s) => s.name.isNotEmpty)
      .toList();
});
