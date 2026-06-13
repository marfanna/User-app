import 'package:flutter/material.dart';

abstract final class AppGradients {
  static const RadialGradient primaryRadial = RadialGradient(
    center: Alignment(-0.27, -0.27),
    radius: 1.5,
    colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
  );

  static const LinearGradient primaryLinear = LinearGradient(
    begin: Alignment(-0.24, -0.24),
    end: Alignment(0.99, 0.99),
    colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
  );
}
