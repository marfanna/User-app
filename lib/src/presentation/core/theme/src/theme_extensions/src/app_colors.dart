import 'package:flutter/material.dart';

/// Static color constants for use without a BuildContext.
/// For theme-aware colors use `context.color.*` instead.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF0156A7);
  static const Color primaryDark = Color(0xFF2E3293);

  // Text
  static const Color textPrimary = Color(0xFF040707);
  static const Color textSecondary = Color(0xFF737780);
  static const Color textDisabled = Color(0xFFBABABD);

  // Semantic
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF12B757);

  // Surfaces
  static const Color background = Color(0xFFF5F7FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color skeleton = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFEBEBEB);
}
