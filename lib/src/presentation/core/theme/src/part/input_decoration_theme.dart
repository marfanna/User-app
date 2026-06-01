part of '../theme_data.dart';

class _InputDecorationLightTheme with ThemeExtensions {
  InputDecorationTheme call() {
    final BorderRadius borderRadius = BorderRadius.circular(
      dimensions.radius.r4,
    );

    return InputDecorationTheme(
      hintStyle: textStyle.bodyLarge.copyWith(color: colors.text.secondary),
      contentPadding: EdgeInsets.symmetric(
        vertical: dimensions.padding.p16,
        horizontal: dimensions.padding.p8,
      ),
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: colors.border.disabled,
          width: dimensions.spacing.s1,
        ),
      ),
      suffixIconColor: colors.icon.primary,
      disabledBorder: OutlineInputBorder(borderRadius: borderRadius),
    );
  }
}
