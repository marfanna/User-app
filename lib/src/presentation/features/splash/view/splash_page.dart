import 'package:flutter/material.dart';

import '../../../core/gen/assets.gen.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Assets.logo.duareLogo.image(
            width: context.dimensions.size.s200,
          ),
        ),
      ),
    );
  }
}
