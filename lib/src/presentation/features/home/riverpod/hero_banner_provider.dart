import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../../core/router/routes.dart';

/// One hero banner: image plus an optional tap target set in admin.
class HeroBanner {
  const HeroBanner({required this.imageUrl, this.link = ''});

  final String imageUrl;

  /// Admin "link". Either a vertical slug ("laundry", "mart") — the same
  /// value the webapp turns into `/{franchise}/{slug}` — or an app path
  /// starting with "/".
  final String link;
}

/// Fetches the franchise's hero banners for a vertical category
/// (e.g. 'restaurant', 'pharmacy'). The backend applies the general fallback:
/// if the category has no banners of its own, it returns the franchise's
/// general banners instead. autoDispose so it refreshes when a screen reloads.
///
/// Returns an empty list when no franchise is selected or on any failure —
/// callers fall back to their placeholder imagery.
final heroBannersProvider = FutureProvider.autoDispose
    .family<List<HeroBanner>, String>((ref, category) async {
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
          .map(
            (b) => HeroBanner(
              imageUrl: (b['imageUrl'] ?? '').toString(),
              link: (b['link'] ?? '').toString().trim(),
            ),
          )
          .where((b) => b.imageUrl.isNotEmpty)
          .toList();
    });

/// Image URLs only — kept for screens that don't handle taps.
final heroBannerProvider = FutureProvider.autoDispose
    .family<List<String>, String>((ref, category) async {
      final banners = await ref.watch(heroBannersProvider(category).future);
      return banners.map((b) => b.imageUrl).toList();
    });

/// Vertical slugs used by the webapp → app routes.
const _slugRoutes = {
  'restaurant': Routes.restaurants,
  'restaurants': Routes.restaurants,
  'mart': Routes.mart,
  'grocery': Routes.mart,
  'pharmacy': Routes.medicine,
  'medicine': Routes.medicine,
  'fashion': Routes.fashion,
  'laundry': Routes.laundry,
};

/// Opens a banner's link. Unknown or empty links do nothing.
void openHeroBannerLink(BuildContext context, String link) {
  final value = link.trim();
  if (value.isEmpty) return;
  final route = value.startsWith('/')
      ? value
      : _slugRoutes[value.toLowerCase().split('?').first];
  if (route == null) return;
  context.push(route);
}
