class LeaderboardEntry {
  const LeaderboardEntry({
    required this.id,
    required this.rank,
    required this.score,
    required this.totalOrders,
    required this.name,
    this.profileImage,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>? ?? {};
    return LeaderboardEntry(
      id: (json['_id'] ?? '') as String,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toDouble() ?? 0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      name: customer['name'] as String? ?? 'Unknown',
      profileImage: customer['profileImage'] as String?,
    );
  }

  final String id;
  final int rank;
  final double score;
  final int totalOrders;
  final String name;
  final String? profileImage;
}

class LeaderboardData {
  const LeaderboardData({
    required this.theme,
    required this.currentMonth,
    required this.standings,
  });

  final String theme;
  final String currentMonth;
  final List<LeaderboardEntry> standings;
}
