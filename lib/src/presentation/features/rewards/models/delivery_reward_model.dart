class DeliveryReward {
  const DeliveryReward({
    required this.id,
    required this.type,
    required this.sourcePrizeRank,
    required this.sourceMonth,
    required this.status,
    this.validFrom,
    this.validUntil,
    this.remainingCount,
    this.initialCount,
  });

  factory DeliveryReward.fromJson(Map<String, dynamic> json) {
    return DeliveryReward(
      id:              json['_id'] as String? ?? '',
      type:            json['type'] as String? ?? 'period',
      sourcePrizeRank: (json['sourcePrizeRank'] as num?)?.toInt() ?? 0,
      sourceMonth:     json['sourceMonth'] as String? ?? '',
      status:          json['status'] as String? ?? 'active',
      validFrom: json['validFrom'] != null
          ? DateTime.tryParse(json['validFrom'] as String)
          : null,
      validUntil: json['validUntil'] != null
          ? DateTime.tryParse(json['validUntil'] as String)
          : null,
      remainingCount:  (json['remainingCount'] as num?)?.toInt(),
      initialCount:    (json['initialCount'] as num?)?.toInt(),
    );
  }

  final String id;
  final String type;      // 'period' | 'count'
  final int sourcePrizeRank;
  final String sourceMonth;
  final String status;
  final DateTime? validFrom;
  final DateTime? validUntil;
  final int? remainingCount;
  final int? initialCount;

  bool get isActive => status == 'active';

  /// True if this reward would waive a delivery fee right now. Mirrors the
  /// backend resolveDeliveryBenefit rule: an active period reward inside its
  /// window, or an active count reward with credits left.
  bool get grantsFreeDeliveryNow {
    if (!isActive) return false;
    if (type == 'period') {
      final now = DateTime.now();
      final fromOk = validFrom == null || !now.isBefore(validFrom!);
      final untilOk = validUntil == null || now.isBefore(validUntil!);
      return fromOk && untilOk;
    }
    if (type == 'count') {
      return (remainingCount ?? 0) > 0;
    }
    return false;
  }

  String get title {
    switch (sourcePrizeRank) {
      case 1: return '1st Place – 30-Day Free Delivery';
      case 2: return '2nd Place – 15-Day Free Delivery';
      case 3: return '3rd Place – 5 Free Deliveries';
      default: return 'Free Delivery Reward';
    }
  }

  String get description {
    if (type == 'period' && validUntil != null) {
      final d = validUntil!;
      return 'Valid until ${d.day} ${_monthName(d.month)} ${d.year}';
    }
    if (type == 'count') {
      return '${remainingCount ?? 0} of ${initialCount ?? 0} uses remaining';
    }
    return '';
  }

  static String _monthName(int m) => const [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec',
  ][m - 1];
}
