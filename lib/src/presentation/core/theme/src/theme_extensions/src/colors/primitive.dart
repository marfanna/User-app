part of 'colors.dart';

/// Primitive color palette
class _Primitive {
  const _Primitive._();

  static const _Brand brand = _Brand();
  static const _Neutral neutral = _Neutral();
  static const _Semantic semantic = _Semantic();
  static const _Opacity opacity = _Opacity();
}

class _Brand {
  const _Brand();

  /// Color code 0xFFE8F2FF
  final Color blue50 = const Color(0xFFE8F2FF);

  /// Color code 0xFF036FFD
  final Color blue500 = const Color(0xFF036FFD);

  /// Color code 0xFF165BAA
  final Color blue600 = const Color(0xFF165BAA);

  /// Color code 0xFF0950A3
  final Color blue650 = const Color(0xFF0950A3);

  /// Color code 0xFF0156A7
  final Color blue700 = const Color(0xFF0156A7);

  /// Color code 0xFF2E3293
  final Color indigo800 = const Color(0xFF2E3293);

  /// Color code 0xFF031C34
  final Color blue950 = const Color(0xFF031C34);
}

class _Neutral {
  const _Neutral();

  /// Color code 0xFFFFFFFF
  final Color white = const Color(0xFFFFFFFF);

  /// Color code 0xFFF7F7F7 (Previous grey98)
  final Color grey50 = const Color(0xFFF7F7F7);

  /// Color code 0xFFEBEBEB (Previous grey95)
  final Color grey100 = const Color(0xFFEBEBEB);

  /// Color code 0xFF646464
  final Color grey500 = const Color(0xFF646464);

  /// Color code 0xFF040707
  final Color grey950 = const Color(0xFF040707);

  /// Color code 0xFF000000
  final Color black = const Color(0xFF000000);

  /// Color code 0xFFD2D3D6
  final Color slate200 = const Color(0xFFD2D3D6);

  /// Color code 0xFFA0A4AD
  final Color slate300 = const Color(0xFFA0A4AD);

  /// Color code 0xFF737780
  final Color slate500 = const Color(0xFF737780);

  /// Color code 0xFF585C67
  final Color slate600 = const Color(0xFF585C67);
}

class _Semantic {
  const _Semantic();

  /// Color code 0xFF12B757
  final Color success = const Color(0xFF12B757);

  /// Color code 0xFFF6220E
  final Color red500 = const Color(0xFFF6220E);
}

class _Opacity {
  const _Opacity();

  /// Color code 0x00000000
  final Color transparent = const Color(0x00000000);

  /// Color code 0x1AE8F2FF
  final Color blue50_10 = const Color(0x1AE8F2FF);

  /// Color code 0x1A036FFD
  final Color blue500_10 = const Color(0x1A036FFD);

  /// Color code 0x1A0950A3
  final Color blue650_10 = const Color(0x1A0950A3);

  /// Color code 0x402E3293
  final Color indigo800_25 = const Color(0x402E3293);
}
