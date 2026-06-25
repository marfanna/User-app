import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../models/delivery_reward_model.dart';

final myRewardsProvider =
    FutureProvider.autoDispose<List<DeliveryReward>>((ref) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return [];

  final dio = ref.read(dioProvider);
  final response = await dio.get(
    'delivery-rewards/mine',
    queryParameters: {'franchiseId': franchiseId},
  );

  final body = response.data as Map<String, dynamic>;
  final raw = body['data'] as List<dynamic>? ?? [];
  return raw
      .whereType<Map<String, dynamic>>()
      .map(DeliveryReward.fromJson)
      .toList();
});
