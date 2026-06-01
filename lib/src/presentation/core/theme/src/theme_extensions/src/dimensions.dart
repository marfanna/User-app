import 'package:flutter/material.dart';

class Dimensions extends ThemeExtension<Dimensions> {
  const Dimensions();

  final spacing = const _Spacing();
  final size = const _Size();
  final padding = const _Padding();
  final margin = const _Margin();
  final radius = const _Radius();

  /// Source of truth
  static const double _v0 = 0;
  static const double _v1 = 1;
  static const double _v1_25 = 1.25;
  static const double _v2 = 2;
  static const double _v4 = 4;
  static const double _v6 = 6;
  static const double _v8 = 8;
  static const double _v10 = 10;
  static const double _v12 = 12;
  static const double _v14 = 14;
  static const double _v16 = 16;
  static const double _v18 = 18;
  static const double _v20 = 20;
  static const double _v22 = 22;
  static const double _v24 = 24;
  static const double _v26 = 26;
  static const double _v28 = 28;
  static const double _v30 = 30;
  static const double _v32 = 32;
  static const double _v36 = 36;
  static const double _v40 = 40;
  static const double _v42 = 42;
  static const double _v44 = 44;
  static const double _v46 = 46;
  static const double _v48 = 48;
  static const double _v50 = 50;
  static const double _v52 = 52;
  static const double _v54 = 54;
  static const double _v56 = 56;
  static const double _v58 = 58;
  static const double _v60 = 60;
  static const double _v62 = 62;
  static const double _v64 = 64;
  static const double _v66 = 66;
  static const double _v68 = 68;
  static const double _v70 = 70;
  static const double _v72 = 72;
  static const double _v74 = 74;
  static const double _v76 = 76;
  static const double _v78 = 78;
  static const double _v80 = 80;
  static const double _v82 = 82;
  static const double _v84 = 84;
  static const double _v86 = 86;
  static const double _v88 = 88;
  static const double _v90 = 90;
  static const double _v92 = 92;
  static const double _v94 = 94;
  static const double _v96 = 96;
  static const double _v98 = 98;
  static const double _v100 = 100;
  static const double _v140 = 140;
  static const double _v200 = 200;
  static const double _v210 = 210;
  static const double _v260 = 260;

  @override
  ThemeExtension<Dimensions> lerp(
    covariant ThemeExtension<Dimensions>? other,
    double t,
  ) {
    if (other is! Dimensions) {
      return this;
    }
    // Constants don't really lerp, but we return 'this' (or other if t >= 0.5)
    // as per previous behavior. If we wanted to lerp, we'd need to lerp the
    // fields, but these are just buckets of constants.
    return t < 0.5 ? this : other;
  }

  @override
  ThemeExtension<Dimensions> copyWith() {
    return const Dimensions();
  }
}

class _Spacing {
  const _Spacing();

  final double s1 = Dimensions._v1;
  final double s1_25 = Dimensions._v1_25;
  final double s2 = Dimensions._v2;
  final double s4 = Dimensions._v4;
  final double s6 = Dimensions._v6;
  final double s8 = Dimensions._v8;
  final double s10 = Dimensions._v10;
  final double s12 = Dimensions._v12;
  final double s16 = Dimensions._v16;
  final double s24 = Dimensions._v24;
  final double s30 = Dimensions._v30;
  final double s32 = Dimensions._v32;
  final double s40 = Dimensions._v40;
  final double s44 = Dimensions._v44;
  final double s48 = Dimensions._v48;
  final double s64 = Dimensions._v64;
  final double s66 = Dimensions._v66;
  final double s80 = Dimensions._v80;
  final double s100 = Dimensions._v100;
  final double s200 = Dimensions._v200;
  final double s210 = Dimensions._v210;
}

class _Size {
  const _Size();

  final double s2 = Dimensions._v2;
  final double s4 = Dimensions._v4;
  final double s8 = Dimensions._v8;
  final double s10 = Dimensions._v10;
  final double s12 = Dimensions._v12;
  final double s14 = Dimensions._v14;
  final double s16 = Dimensions._v16;
  final double s18 = Dimensions._v18;
  final double s20 = Dimensions._v20;
  final double s22 = Dimensions._v22;
  final double s24 = Dimensions._v24;
  final double s26 = Dimensions._v26;
  final double s28 = Dimensions._v28;
  final double s30 = Dimensions._v30;
  final double s32 = Dimensions._v32;
  final double s36 = Dimensions._v36;
  final double s40 = Dimensions._v40;
  final double s44 = Dimensions._v44;
  final double s48 = Dimensions._v48;
  final double s56 = Dimensions._v56;
  final double s60 = Dimensions._v60;
  final double s64 = Dimensions._v64;
  final double s100 = Dimensions._v100;
  final double s140 = Dimensions._v140;
  final double s200 = Dimensions._v200;
  final double s260 = Dimensions._v260;
}

class _Padding {
  const _Padding();

  final double p0 = Dimensions._v0;
  final double p2 = Dimensions._v2;
  final double p4 = Dimensions._v4;
  final double p6 = Dimensions._v6;
  final double p8 = Dimensions._v8;
  final double p10 = Dimensions._v10;
  final double p12 = Dimensions._v12;
  final double p16 = Dimensions._v16;
  final double p20 = Dimensions._v20;
  final double p24 = Dimensions._v24;
  final double p26 = Dimensions._v26;
  final double p28 = Dimensions._v28;
  final double p32 = Dimensions._v32;
}

class _Margin {
  const _Margin();

  final double m6 = Dimensions._v6;
}

class _Radius {
  const _Radius();

  final double r4 = Dimensions._v4;
  final double r6 = Dimensions._v6;
  final double r8 = Dimensions._v8;
  final double r10 = Dimensions._v10;
  final double r12 = Dimensions._v12;
  final double r16 = Dimensions._v16;
  final double r20 = Dimensions._v20;
  final double r24 = Dimensions._v24;
  final double r30 = Dimensions._v30;
  final double r44 = Dimensions._v44;
  final double r64 = Dimensions._v64;
}
