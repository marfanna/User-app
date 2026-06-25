import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../home/models/shop_data.dart';
import 'medicine_category_provider.dart';

/// Pharmacy shops near the user, scoped to the active franchise and the
/// dynamically-resolved medicine category.
///
/// Mirrors `restaurantsProvider` but pins `category` to the pharmacy value
/// instead of the global `selectedCategoryProvider`, so this works regardless
/// of which vertical the food screen last selected.
final medicinePharmaciesProvider = FutureProvider.autoDispose<List<ShopData>>((
  ref,
) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  final category = await ref.watch(medicinePharmacyCategoryProvider.future);

  final dio = ref.read(dioProvider);
  final response = await dio.get(
    'shops/public/get-all-shops',
    queryParameters: {
      'franchise': franchiseId,
      'category': category,
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
