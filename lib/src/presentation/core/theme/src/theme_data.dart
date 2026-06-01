import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_extensions/extensions.dart';

part 'part/input_decoration_theme.dart';

class $LightThemeData with ThemeExtensions {
  ThemeData call() {
    return ThemeData(
      brightness: Brightness.light,
      extensions: <ThemeExtension<dynamic>>[colors, textStyle, dimensions],
      colorScheme: ColorScheme.light(primary: colors.brand.defaultValue),
      scaffoldBackgroundColor: colors.background.surface,
      iconTheme: IconThemeData(color: colors.border.disabled),
      inputDecorationTheme: _InputDecorationLightTheme()(),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.background.surface,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(dimensions.radius.r16),
        ),
      ),
      textTheme: GoogleFonts.manropeTextTheme(),
    );
  }
}
