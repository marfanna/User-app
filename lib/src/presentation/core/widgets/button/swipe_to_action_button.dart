import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../theme/theme.dart';
import '../text/typography.dart';

class SwipeToActionButton extends StatelessWidget {
  const SwipeToActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.content,
  });

  final String title;
  final VoidCallback? onPressed;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: context.dimensions.size.s40,
        padding: EdgeInsets.fromLTRB(
          context.dimensions.padding.p4,
          context.dimensions.padding.p4,
          context.dimensions.padding.p16,
          context.dimensions.padding.p4,
        ),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.27, -0.27),
            radius: 2.0,
            colors: context.color.background.surfaceContainerGradient,
            stops: const [0.0, 1.0],
          ),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r20),
        ),
        child:
            content ??
            Row(
              mainAxisAlignment: .start,
              spacing: context.dimensions.spacing.s8,
              children: [
                Container(
                  width: context.dimensions.size.s30,
                  height: context.dimensions.size.s30,
                  decoration: BoxDecoration(
                    color: context.color.background.surface,
                    shape: .circle,
                  ),
                  child: Center(
                    child: Assets.icons.swipeLeft.svg(
                      width: context.dimensions.size.s10,
                      height: context.dimensions.size.s10,
                    ),
                  ),
                ),
                TitleText.mediumInverse(title),
              ],
            ),
      ),
    );
  }
}
