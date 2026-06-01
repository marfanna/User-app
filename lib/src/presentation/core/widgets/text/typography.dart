import 'package:flutter/material.dart';

import '../../theme/theme.dart';

abstract class _Typography extends StatelessWidget {
  const _Typography(
    this.text, {
    super.key,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.textDirection,
    this.semanticsLabel,
  });

  final String text;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDirection? textDirection;
  final String? semanticsLabel;

  // Abstract getter for the style, implemented by subclasses
  TextStyle resolveStyle(BuildContext context);

  // Hook for text transformation (e.g. Uppercase), defaults to identity
  String resolveText(String text) => text;

  @override
  Widget build(BuildContext context) {
    return Text(
      resolveText(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
      textDirection: textDirection,
      semanticsLabel: semanticsLabel,
      style: resolveStyle(context),
    );
  }
}

enum _DisplayVariant { large, medium, small, smallCompact }

class DisplayText extends _Typography {
  const DisplayText.large(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .large;

  const DisplayText.medium(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .medium;

  const DisplayText.small(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .small;

  const DisplayText.smallCompact(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallCompact;

  final _DisplayVariant _variant;

  @override
  TextStyle resolveStyle(BuildContext context) {
    final style = context.textStyle;
    final color = context.color.text;

    final (textStyle, textColor) = switch (_variant) {
      .large => (style.displayLarge, color.primary),
      .medium => (style.displayMedium, context.color.brand.primary),
      .small => (style.displaySmall, color.primary),
      .smallCompact => (style.displaySmallCompact, color.primary),
    };

    return textStyle.copyWith(color: textColor);
  }
}

enum _TitleVariant {
  large,
  medium,
  mediumBrand,
  mediumInverse,
  mediumCompact,
  mediumCompactDisable,
  small,
  smallSecondary,
  smallNunito,
}

class TitleText extends _Typography {
  const TitleText.large(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .large;

  const TitleText.medium(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .medium;

  const TitleText.mediumBrand(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumBrand;

  const TitleText.mediumInverse(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumInverse;

  const TitleText.mediumCompact(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumCompact;

  const TitleText.mediumCompactDisable(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumCompactDisable;

  const TitleText.small(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .small;

  const TitleText.smallSecondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallSecondary;

  const TitleText.smallNunito(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallNunito;

  final _TitleVariant _variant;

  @override
  TextStyle resolveStyle(BuildContext context) {
    final style = context.textStyle;
    final color = context.color.text;

    final (textStyle, textColor) = switch (_variant) {
      .large => (style.titleLarge, color.primary),
      .medium => (style.titleMedium, color.primary),
      .mediumBrand => (style.titleMedium, context.color.brand.defaultValue),
      .mediumInverse => (style.titleMedium, color.inverse),
      .mediumCompact => (style.titleMediumCompact, color.primary),
      .mediumCompactDisable => (style.titleMediumCompact, color.disabled),
      .small => (style.titleSmall, color.primary),
      .smallSecondary => (style.titleSmall, color.secondary),
      .smallNunito => (style.titleSmallNunito, color.primary),
    };

    return textStyle.copyWith(color: textColor);
  }
}

enum _BodyTextVariant {
  large,
  largeCompact,
  medium,
  mediumRelaxedSecondary,
  small,
  smallCompact,
  smallCompactLoose,
}

class BodyText extends _Typography {
  const BodyText.large(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .large;

  const BodyText.largeCompact(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .largeCompact;

  const BodyText.medium(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .medium;

  // (Confirmed)
  const BodyText.mediumRelaxedSecondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumRelaxedSecondary;

  const BodyText.small(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .small;

  const BodyText.smallCompact(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallCompact;

  const BodyText.smallCompactLooseSecondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallCompactLoose;

  final _BodyTextVariant _variant;

  @override
  TextStyle resolveStyle(BuildContext context) {
    final style = context.textStyle;
    final color = context.color.text;

    final (textStyle, textColor) = switch (_variant) {
      .large => (style.bodyLarge, color.secondary),
      .largeCompact => (style.bodyLargeCompact, color.primary),
      .medium => (style.bodyMedium, color.primary),
      .mediumRelaxedSecondary => (style.bodyMediumRelaxed, color.secondary),
      .small => (style.bodySmall, color.primary),
      .smallCompact => (style.bodySmallCompact, color.primary),
      .smallCompactLoose => (style.bodySmallCompactLoose, color.secondary),
    };
    return textStyle.copyWith(color: textColor);
  }
}

enum _LabelVariant {
  large,
  largeInverse,
  medium,
  mediumSecondary,
  mediumInverse,
  mediumCompact,
  smallRegularSecondary,
  smallSemiBold,
}

class LabelText extends _Typography {
  const LabelText.large(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .large;

  const LabelText.largeInverse(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .largeInverse;

  const LabelText.medium(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .medium;

  const LabelText.mediumSecondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumSecondary;

  const LabelText.mediumInverse(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumInverse;

  const LabelText.mediumCompact(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .mediumCompact;

  const LabelText.smallUpperCaseSecondary(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallRegularSecondary;

  const LabelText.smallSemiBold(
    super.text, {
    super.key,
    super.textAlign,
    super.maxLines,
    super.overflow,
    super.softWrap,
    super.textDirection,
    super.semanticsLabel,
  }) : _variant = .smallSemiBold;

  final _LabelVariant _variant;

  @override
  String resolveText(String text) {
    return switch (_variant) {
      .smallRegularSecondary => text.toUpperCase(),
      _ => text,
    };
  }

  @override
  TextStyle resolveStyle(BuildContext context) {
    final style = context.textStyle;
    final color = context.color.text;

    final (textStyle, textColor) = switch (_variant) {
      .large => (style.labelLarge, color.primary),
      .largeInverse => (style.labelLarge, color.inverse),
      .medium => (style.labelMedium, color.primary),
      .mediumSecondary => (style.labelMedium, color.secondary),
      .mediumInverse => (style.labelMedium, color.inverse),
      .mediumCompact => (style.labelMediumCompact, color.primary),
      .smallRegularSecondary => (style.labelSmall, color.secondary),
      .smallSemiBold => (style.labelSmallSemiBold, color.primary),
    };

    return textStyle.copyWith(color: textColor);
  }
}
