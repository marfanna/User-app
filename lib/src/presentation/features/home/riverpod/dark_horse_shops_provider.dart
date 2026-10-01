import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../models/shop_data.dart';

const _darkHorseWindowDays = 90;

/// (shops to show, whether they were hand-picked rather than algorithmic) —
/// the widget needs the flag to pick the right subtitle copy.
typedef DarkHorseResult = ({List<ShopData> shops, bool isHandPicked});

/// "Dark Horse" strip. An admin can hand-pick up to 6 restaurants per
/// franchise (Shop.isSpotlighted, ordered by Shop.spotlightOrder) — when any
/// are set, they replace the algorithmic pick entirely. With none set, this
/// falls back to the original behaviour: new restaurants (joined within the
/// last 90 days) already racking up the most orders, ranked by order count.
/// Reusing this section (rather than adding a new one) keeps the homepage
/// layout unchanged either way.
final darkHorseShopsProvider = FutureProvider.autoDispose<DarkHorseResult>((
  ref,
) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) {
    return (shops: <ShopData>[], isHandPicked: false);
  }

  final dio = ref.read(dioProvider);

  final spotlighted = await _fetchShops(
    dio,
    franchiseId: franchiseId,
    extraParams: {
      'isSpotlighted': 'true',
      'sortBy': 'spotlightOrder',
      'sortOrder': 'asc',
    },
  );
  if (spotlighted.isNotEmpty) {
    return (shops: spotlighted, isHandPicked: true);
  }

  final since = DateTime.now().toUtc().subtract(
    const Duration(days: _darkHorseWindowDays),
  );
  final algorithmic = await _fetchShops(
    dio,
    franchiseId: franchiseId,
    extraParams: {
      'createdAfter': since.toIso8601String(),
      'sortBy': 'analytics.totalOrders',
      'sortOrder': 'desc',
    },
  );
  // A shop with zero orders isn't "topping the charts" — exclude it rather
  // than let a plain new-but-unordered shop fill the section. Doesn't apply
  // to the hand-picked list above: an admin's choice stands regardless.
  return (
    shops: algorithmic.where((s) => s.totalOrders > 0).toList(),
    isHandPicked: false,
  );
});

Future<List<ShopData>> _fetchShops(
  Dio dio, {
  required String franchiseId,
  required Map<String, String> extraParams,
}) async {
  final response = await dio.get(
    'shops/public/get-all-shops',
    queryParameters: {
      'franchise': franchiseId,
      'category': 'restaurant',
      'isActive': 'true',
      'status': 'active',
      'limit': '6',
      ...extraParams,
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
}
