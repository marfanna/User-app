import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';

/// A single masked leaderboard winner for the monthly winners popup.
class MonthlyWinner {
  const MonthlyWinner({
    required this.rank,
    required this.name,
    required this.points,
    this.prizeAwarded,
  });

  factory MonthlyWinner.fromJson(Map<String, dynamic> json) => MonthlyWinner(
        rank: (json['rank'] as num?)?.toInt() ?? 0,
        name: json['name'] as String? ?? 'Customer',
        points: (json['points'] as num?) ?? 0,
        prizeAwarded: json['prizeAwarded'] as String?,
      );

  final int rank;
  final String name;
  final num points;
  final String? prizeAwarded;
}

class MonthlyWinnersData {
  const MonthlyWinnersData({required this.month, required this.winners});

  final String month; // "YYYY-MM"
  final List<MonthlyWinner> winners;
}

/// Fetches last month's top-3 masked winners for the selected franchise.
/// Returns null when there's no franchise or no snapshot yet (popup stays
/// hidden — never show an empty celebration).
final monthlyWinnersProvider =
    FutureProvider.autoDispose<MonthlyWinnersData?>((ref) async {
  final cache = ref.read(cacheServiceProvider);
  final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
  if (franchiseId == null || franchiseId.isEmpty) return null;

  final dio = ref.read(dioProvider);
  final res = await dio.get(
    'leaderboard/winners',
    queryParameters: {'franchiseId': franchiseId},
  );

  final data = res.data is Map
      ? res.data['data'] as Map<String, dynamic>?
      : null;
  if (data == null) return null;

  final winners = ((data['winners'] as List?) ?? const [])
      .whereType<Map<String, dynamic>>()
      .map(MonthlyWinner.fromJson)
      .toList();
  if (winners.isEmpty) return null;

  return MonthlyWinnersData(
    month: data['month'] as String? ?? '',
    winners: winners,
  );
});
