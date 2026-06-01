class ShopData {
  const ShopData({
    required this.id,
    required this.name,
    this.logo,
    this.banner,
    this.area,
    this.isOpen = true,
    this.isPaused = false,
    this.pauseReason,
  });

  final String id;
  final String name;
  final String? logo;
  final String? banner;
  final String? area;
  final bool isOpen;
  final bool isPaused;
  final String? pauseReason;

  factory ShopData.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;
    final address = json['address'] as Map<String, dynamic>?;
    final pause = json['emergencyPause'] as Map<String, dynamic>?;

    final rawHours = json['operatingHours'];
    List<Map<String, dynamic>>? hours;
    if (rawHours is List) {
      hours = rawHours.whereType<Map<String, dynamic>>().toList();
    }

    final isPaused = pause?['isPaused'] as bool? ?? false;
    final isOpen = isPaused ? false : _calcIsOpen(hours);

    return ShopData(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      logo: images?['logo'] as String? ?? json['logo'] as String?,
      banner:
          images?['banner'] as String? ??
          json['coverImage'] as String? ??
          json['image'] as String?,
      area: address?['area'] as String? ?? address?['district'] as String?,
      isOpen: isOpen,
      isPaused: isPaused,
      pauseReason: pause?['pauseReason'] as String?,
    );
  }

  static bool _calcIsOpen(List<Map<String, dynamic>>? hours) {
    if (hours == null || hours.isEmpty) return true;
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    final now = DateTime.now();
    final todayName = days[now.weekday % 7];

    Map<String, dynamic>? today;
    for (final h in hours) {
      final day = (h['day'] as String?)?.toLowerCase();
      if (day == todayName.toLowerCase()) {
        today = h;
        break;
      }
    }
    if (today == null) return true;
    if (today['isOpen'] == false) return false;

    final openMin = _parseTime(today['open'] as String?);
    final closeMin = _parseTime(today['close'] as String?);
    if (openMin == null || closeMin == null) return true;

    final nowMin = now.hour * 60 + now.minute;
    return nowMin >= openMin && nowMin < closeMin;
  }

  static int? _parseTime(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      final upper = s.trim().toUpperCase();
      final isPm = upper.contains('PM');
      final isAm = upper.contains('AM');
      final clean = upper.replaceAll(RegExp(r'[AMP\s]'), '');
      final parts = clean.split(':');
      int h = int.parse(parts[0]);
      final m = parts.length > 1 ? int.parse(parts[1]) : 0;
      if (isPm && h != 12) h += 12;
      if (isAm && h == 12) h = 0;
      return h * 60 + m;
    } catch (_) {
      return null;
    }
  }
}
