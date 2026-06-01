import 'package:flutter/material.dart';

import '../../theme/src/theme_extensions/src/dimensions.dart';
import '../../theme/theme.dart';
import '../text/typography.dart';

part 'primary_button.dart';
part 'secondary_button.dart';

enum _ButtonSizeVariant {
  comfortable,
  compact,
  vanilla;

  bool get isComfortable => this == .comfortable;
  bool get isCompact => this == .compact;
  bool get isVanilla => this == .vanilla;

  final Dimensions _dimensions = const Dimensions();

  double get height {
    return switch (this) {
      .comfortable => _dimensions.size.s56,
      .compact => _dimensions.size.s40,
      .vanilla => _dimensions.size.s40,
    };
  }

  double get width => double.infinity;

  double get horizontalPadding {
    return switch (this) {
      .comfortable => _dimensions.padding.p26,
      .compact => _dimensions.padding.p26,
      .vanilla => _dimensions.padding.p0,
    };
  }

  double get radius {
    return switch (this) {
      .comfortable => _dimensions.radius.r4,
      .compact => _dimensions.radius.r44,
      .vanilla => _dimensions.radius.r44,
    };
  }
}
