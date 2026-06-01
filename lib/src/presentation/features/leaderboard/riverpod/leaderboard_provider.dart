import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../models/leaderboard_models.dart';

final leaderboardProvider =
    FutureProvider.autoDispose<LeaderboardData>((ref) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) {
    return const LeaderboardData(
      theme: 'order_volume',
      currentMonth: '',
      standings: [],
    );
  }

  final dio = ref.read(dioProvider);
  final response = await dio.get(
    'leaderboard/live',
    queryParameters: {'franchiseId': franchiseId},
  );

  final body = response.data as Map<String, dynamic>;
  final data = body['data'] as Map<String, dynamic>? ?? {};
  final config = data['config'] as Map<String, dynamic>? ?? {};
  final rawStandings = data['standings'] as List<dynamic>? ?? [];

  return LeaderboardData(
    theme: config['theme'] as String? ?? 'order_volume',
    currentMonth: config['currentMonth'] as String? ?? '',
    standings: rawStandings
        .whereType<Map<String, dynamic>>()
        .map(LeaderboardEntry.fromJson)
        .toList(),
  );
});
