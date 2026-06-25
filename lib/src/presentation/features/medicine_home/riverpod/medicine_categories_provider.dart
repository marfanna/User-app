import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import 'medicine_pharmacies_provider.dart';

/// The real medicine categories available across the franchise's pharmacies.
///
/// Admin's `itemCategory` is free text (owner-typed), so there's no canonical
/// list — we aggregate each pharmacy's distinct categories
/// (`GET /medicine-products/shop/:id/categories`), dedupe case-insensitively,
/// and sort. This guarantees every homepage tile maps to real products.
final medicineAggregatedCategoriesProvider =
    FutureProvider.autoDispose<List<String>>((ref) async {
      // Include every pharmacy (open or closed) so the catalogue stays
      // complete — a shop being outside its hours shouldn't hide its
      // categories. Ordering availability is enforced later at checkout.
      final shops = await ref.watch(medicinePharmaciesProvider.future);
      if (shops.isEmpty) return [];

      final dio = ref.read(dioProvider);

      final lists = await Future.wait(
        shops.map((shop) async {
          try {
            final response = await dio.get(
              'medicine-products/shop/${shop.id}/categories',
            );
            final body = response.data as Map<String, dynamic>;
            final raw = body['data'];
            final list = raw is List ? raw : const [];
            return list.whereType<String>().toList();
          } catch (_) {
            return <String>[];
          }
        }),
      );

      // Dedupe case-insensitively, keep first-seen display form, sort A→Z.
      final seen = <String>{};
      final out = <String>[];
      for (final cat in lists.expand((e) => e)) {
        final key = cat.trim().toLowerCase();
        if (key.isEmpty || seen.contains(key)) continue;
        seen.add(key);
        out.add(cat.trim());
      }
      out.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      return out;
    });
