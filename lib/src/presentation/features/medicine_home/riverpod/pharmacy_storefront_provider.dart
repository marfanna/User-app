import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/medicine_product_detail.dart';

/// Distinct item categories for a pharmacy
/// (`GET /medicine-products/shop/:shopId/categories`). Drives the filter chips.
/// Server returns the full distinct set regardless of catalogue size.
final pharmacyProductCategoriesProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, shopId) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        'medicine-products/shop/$shopId/categories',
      );
      final body = response.data as Map<String, dynamic>;
      final raw = body['data'];
      final list = raw is List ? raw : const [];
      return list.whereType<String>().where((c) => c.isNotEmpty).toList();
    });

/// One page of a pharmacy's products, filtered server-side.
///
/// A pharmacy can hold tens of thousands of products, so category + search
/// filtering and paging MUST happen on the server — fetching the first 100 and
/// filtering client-side showed almost nothing for any category past the start
/// of the alphabet. The storefront screen drives pagination and accumulates
/// pages; this just fetches one page.
typedef PharmacyPage = ({
  List<MedicineProductDetail> items,
  int totalPages,
  int total,
});

Future<PharmacyPage> fetchPharmacyProducts({
  required Dio dio,
  required String shopId,
  required int page,
  int limit = 30,
  String? category,
  String search = '',
}) async {
  final response = await dio.get(
    'medicine-products/shop/$shopId',
    queryParameters: {
      'page': '$page',
      'limit': '$limit',
      'category': ?category,
      if (search.trim().isNotEmpty) 'search': search.trim(),
      'sortBy': 'name',
      'sortOrder': 'asc',
    },
  );

  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  final items = (raw is List ? raw : const [])
      .whereType<Map<String, dynamic>>()
      .map(MedicineProductDetail.fromJson)
      .where((p) => p.name.isNotEmpty)
      .toList();

  final meta = body['meta'] as Map<String, dynamic>?;
  final totalPages = (meta?['totalPages'] as num?)?.toInt() ?? page;
  final total = (meta?['total'] as num?)?.toInt() ?? items.length;

  return (items: items, totalPages: totalPages, total: total);
}
