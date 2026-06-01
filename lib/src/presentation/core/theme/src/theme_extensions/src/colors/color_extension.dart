part of 'colors.dart';

class ColorExtension extends ThemeExtension<ColorExtension> {
  const ColorExtension();

  final brand = const _BrandSemantic();
  final icon = const _IconSemantic();
  final text = const _TextSemantic();
  final border = const _BorderSemantic();
  final error = const _ErrorSemantic();
  final success = const _SuccessSemantic();
  final background = const _BackgroundSemantic();
  final elevation = const _ElevationSemantic();

  @override
  ThemeExtension<ColorExtension> copyWith() => const ColorExtension();

  @override
  ThemeExtension<ColorExtension> lerp(
    covariant ThemeExtension<ColorExtension>? other,
    double t,
  ) => const ColorExtension();
}

class _BrandSemantic {
  const _BrandSemantic();

  /// Color code 0xFF0950A3
  Color get defaultValue => _Primitive.brand.indigo800;

  /// Color code 0xFF0156A7
  Color get secondary => _Primitive.brand.blue700;

  /// Color code 0xFF165BAA
  Color get primary => _Primitive.brand.blue600;
}

class _IconSemantic {
  const _IconSemantic();

  /// Color code 0xFF040707
  Color get primary => _Primitive.neutral.grey950;

  /// Color code 0xFF737780
  Color get secondary => _Primitive.neutral.slate300;

  /// Color code 0xFFFFFFFF
  Color get inverse => _Primitive.neutral.white;
}

class _TextSemantic {
  const _TextSemantic();

  /// Color code 0xFF040707
  Color get primary => _Primitive.neutral.grey950;

  /// Color code 0xFF737780
  Color get secondary => _Primitive.neutral.slate500;

  /// Color code 0xFFBABABD
  Color get disabled => _Primitive.neutral.slate200;

  /// Color code 0xFFFFFFFF
  Color get inverse => _Primitive.neutral.white;
}

class _BorderSemantic {
  const _BorderSemantic();

  Color get disabled => _Primitive.neutral.slate200;

  Color get divider => _Primitive.neutral.grey100;

  Color get focus => _Primitive.brand.indigo800;
}

class _ErrorSemantic {
  const _ErrorSemantic();

  /// Color code 0xFFF6220E
  Color get defaultValue => _Primitive.semantic.red500;
}

class _SuccessSemantic {
  const _SuccessSemantic();

  /// Color code 0xFF12B757
  Color get defaultValue => _Primitive.semantic.success;
}

class _BackgroundSemantic {
  const _BackgroundSemantic();

  List<Color> get surfaceGradient => [
    _Primitive.opacity.blue500_10,
    _Primitive.opacity.blue50_10,
  ];

  List<Color> get surfaceContainerGradient => [
    _Primitive.brand.blue700,
    _Primitive.brand.indigo800,
  ];

  /// Color code 0x00000000
  Color get transparent => _Primitive.opacity.transparent;

  /// Color code 0xFFFFFFFF
  Color get surface => _Primitive.neutral.white;

  /// Color code 0xFFFFFFFF
  Color get surfaceContainer => _Primitive.neutral.white;

  /// Color code 0xFFF7F7F7
  Color get surfaceContainerHigh => _Primitive.neutral.grey50;

  /// Color code 0xFFEBEBEB
  Color get surfaceContainerHighDim => _Primitive.neutral.grey100;

  /// Color code 0xFF031C34
  Color get surfaceContainerHighest => _Primitive.brand.blue950;

  /// Color code 0xFFD2D3D6
  Color get surfaceVariant => _Primitive.neutral.slate200;
}

class _ElevationSemantic {
  const _ElevationSemantic();

  /// Color code 0x00000000
  Color get transparent => _Primitive.opacity.transparent;

  /// Color code 0x1A0950A3
  Color get elevationLow => _Primitive.opacity.blue650_10;

  /// Color code 0x402E3293
  Color get elevationMedium => _Primitive.opacity.indigo800_25;
}
