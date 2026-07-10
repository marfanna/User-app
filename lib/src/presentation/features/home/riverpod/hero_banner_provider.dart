import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';

/// Fetches the franchise's hero banner image URLs for a given vertical category
/// (e.g. 'restaurant', 'pharmacy'). The backend applies the general fallback:
/// if the category has no banners of its own, it returns the franchise's
/// general banners instead. autoDispose so it refreshes when a screen reloads.
///
/// Returns an empty list when no franchise is selected or on any failure —
/// callers fall back to their placeholder imagery.
final heroBannerProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, category) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  final dio = ref.read(dioProvider);
  final response = await dio.get(
    'banners/public',
    queryParameters: {
      'franchiseId': franchiseId,
      'type': 'hero',
      'category': category,
    },
  );

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
      .map((b) => (b['imageUrl'] ?? '').toString())
      .where((url) => url.isNotEmpty)
      .toList();
});
