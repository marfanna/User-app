import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleExtension extends ThemeExtension<TextStyleExtension> {
  const TextStyleExtension();

  // font-family: Manrope; w700; 41px; height 128%; -1px spacing;
  TextStyle get displayLarge {
    return GoogleFonts.manrope(
      fontSize: 41,
      fontWeight: FontWeight.w700,
      height: 1.28,
      letterSpacing: -1,
    );
  }

  // font-family: Manrope; w700; 32px; height 100%; -3.75% spacing (-1.2px);
  TextStyle get displayMedium {
    return GoogleFonts.manrope(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: -1.2,
    );
  }

  // font-family: Manrope; w700; 24px; height 128%; -1px spacing;
  TextStyle get displaySmall {
    return GoogleFonts.manrope(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.28,
      letterSpacing: -1,
    );
  }

  // font-family: Manrope; w700; 24px; height 100%; -0.5px spacing;
  TextStyle get displaySmallCompact {
    return GoogleFonts.manrope(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      height: 1.0,
      letterSpacing: -0.5,
    );
  }

  // font-family: Manrope; w700; 18px; height 128%; -1px spacing;
  TextStyle get titleLarge {
    return GoogleFonts.manrope(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      height: 1.28,
      letterSpacing: -1,
    );
  }

  // font-family: Manrope; w700; 16px; height 150% (24px); -0.5px spacing;
  TextStyle get titleMedium {
    return GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.50,
      letterSpacing: -0.5,
    );
  }

  // font-family: Manrope; w700; 16px; height 128%; 0px spacing;
  TextStyle get titleMediumCompact {
    return GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.28,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w600; 16px; height 128%; 0% spacing;
  TextStyle get titleSmall {
    return GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.28,
      letterSpacing: 0,
    );
  }

  // font-family: Nunito; w600; 16px; height 120%; 0% spacing;
  TextStyle get titleSmallNunito {
    return GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.20,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w400; 16px; height 150% (24px); -0.5px spacing;
  TextStyle get bodyLarge {
    return GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.50,
      letterSpacing: -0.5,
    );
  }

  // font-family: Manrope; w500; 16px; height 100%; 0% spacing;
  TextStyle get bodyLargeCompact {
    return GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w400; 14px; height 150%; 0px spacing;
  TextStyle get bodyMedium {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.50,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w400; 14px; height 171% (24px); -0.5px spacing;
  TextStyle get bodyMediumRelaxed {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 24 / 14,
      letterSpacing: -0.5,
    );
  }

  // font-family: Manrope; w500; 14px; height 150%; 0px spacing;
  TextStyle get bodySmall {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.50,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w500; 14px; height 128%; 0px spacing;
  TextStyle get bodySmallCompactLoose {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.28,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w500; 14px; height 128%; -1px spacing;
  TextStyle get bodySmallCompact {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.28,
      letterSpacing: -1,
    );
  }

  // font-family: Manrope; w600; 14px; height 128%; 0px spacing;
  TextStyle get labelLarge {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.28,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w500; 13px; height 150%; 0px spacing;
  TextStyle get labelMedium {
    return GoogleFonts.manrope(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.50,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w500; 13px; height 128%; -1px spacing;
  TextStyle get labelMediumCompact {
    return GoogleFonts.manrope(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.28,
      letterSpacing: -1,
    );
  }

  // font-family: Manrope; w400; 12px; height 100%; 0% spacing;
  TextStyle get labelSmall {
    return GoogleFonts.manrope(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      height: 1.0,
      letterSpacing: 0,
    );
  }

  // font-family: Manrope; w500; 12px; height 100%; 0% spacing;
  TextStyle get labelSmallSemiBold {
    return GoogleFonts.manrope(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.0,
      letterSpacing: 0,
    );
  }

  @override
  ThemeExtension<TextStyleExtension> copyWith() => const TextStyleExtension();

  @override
  ThemeExtension<TextStyleExtension> lerp(other, t) =>
      const TextStyleExtension();
}
