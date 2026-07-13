import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../home/models/featured_item.dart';

/// Alternative-brand medicines for a product — same generic, different
/// company, from `GET /medicine-products/:id/alternatives`.
final medicineAlternativesProvider = FutureProvider.autoDispose
    .family<List<FeaturedItem>, String>((ref, productId) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get('medicine-products/$productId/alternatives');

      final body = response.data as Map<String, dynamic>;
      final raw = body['data'];
      final list = raw is List ? raw : const [];

      return list
          .whereType<Map<String, dynamic>>()
          .map(FeaturedItem.fromJson)
          .where((f) => f.item.name.isNotEmpty)
          .toList();
    });
