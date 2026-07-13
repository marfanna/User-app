import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../models/shop_data.dart';

const _darkHorseWindowDays = 90;

/// "Dark Horse" — new restaurants (joined within the last 90 days) that are
/// already racking up the most orders, ranked by total order count.
final darkHorseShopsProvider = FutureProvider.autoDispose<List<ShopData>>((
  ref,
) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  final since = DateTime.now().toUtc().subtract(
    const Duration(days: _darkHorseWindowDays),
  );

  final dio = ref.read(dioProvider);
  final response = await dio.get(
    'shops/public/get-all-shops',
    queryParameters: {
      'franchise': franchiseId,
      'category': 'restaurant',
      'createdAfter': since.toIso8601String(),
      'isActive': 'true',
      'status': 'active',
      'limit': '6',
      'sortBy': 'analytics.totalOrders',
      'sortOrder': 'desc',
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
