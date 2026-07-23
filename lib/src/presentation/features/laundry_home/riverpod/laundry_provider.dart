import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../home/models/shop_data.dart';
import '../models/laundry_service_item.dart';

class LaundryCatalogItem {
  const LaundryCatalogItem({
    required this.service,
    required this.shopId,
    required this.shopName,
  });

  final LaundryServiceItem service;
  final String shopId;
  final String shopName;
}

final laundryShopsProvider = FutureProvider.autoDispose<List<ShopData>>((
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
      'category': 'laundry',
      'isActive': 'true',
      'status': 'active',
      'limit': '10',
      'sortBy': 'createdAt',
      'sortOrder': 'asc',
    },
  );

  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  final List<dynamic> list;
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
      .where((shop) => shop.name.isNotEmpty)
      .toList();
});

final laundryShopProvider = FutureProvider.autoDispose<ShopData?>((ref) async {
  final shops = await ref.watch(laundryShopsProvider.future);
  if (shops.isEmpty) return null;
  return shops.first;
});

final laundryServicesProvider =
    FutureProvider.autoDispose<List<LaundryCatalogItem>>((ref) async {
      final shop = await ref.watch(laundryShopProvider.future);
      if (shop == null) return [];

      final dio = ref.read(dioProvider);
      final response = await dio.get('products/public/shop/${shop.id}');
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final items = data?['items'] as List<dynamic>?;
      if (items == null) return [];

      return items
          .whereType<Map<String, dynamic>>()
          .map(LaundryServiceItem.fromJson)
          .where((service) => service.name.isNotEmpty)
          .map(
            (service) => LaundryCatalogItem(
              service: service,
              shopId: shop.id,
              shopName: shop.name,
            ),
          )
          .toList();
    });

final laundryCategoriesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final items = await ref.watch(laundryServicesProvider.future);
  final seen = <String>{};
  final out = <String>[];
  for (final item in items) {
    final category = item.service.itemCategory?.trim();
    if (category == null || category.isEmpty) continue;
    final key = category.toLowerCase();
    if (seen.add(key)) out.add(category);
  }

  const preferred = [
    'Wash & Fold',
    'Wash + Iron',
    'Iron / Press',
    'Dry Cleaning',
    'Blanket / Bedsheet / Curtain',
  ];

  int rank(String value) {
    final lower = value.toLowerCase();
    final index = preferred.indexWhere((p) => p.toLowerCase() == lower);
    return index == -1 ? 999 : index;
  }

  out.sort((a, b) {
    final rankCompare = rank(a).compareTo(rank(b));
    if (rankCompare != 0) return rankCompare;
    return a.toLowerCase().compareTo(b.toLowerCase());
  });
  return out;
});

final laundryCategoryPreviewProvider = FutureProvider.autoDispose
    .family<List<LaundryCatalogItem>, String>((ref, category) async {
      final items = await ref.watch(laundryServicesProvider.future);
      final key = category.trim().toLowerCase();
      return items
          .where(
            (item) => item.service.itemCategory?.trim().toLowerCase() == key,
          )
          .take(8)
          .toList();
    });

final laundryListingProvider = FutureProvider.autoDispose
    .family<List<LaundryCatalogItem>, String>((ref, category) async {
      final items = await ref.watch(laundryServicesProvider.future);
      final key = category.trim().toLowerCase();
      return items
          .where(
            (item) => item.service.itemCategory?.trim().toLowerCase() == key,
          )
          .toList();
    });
