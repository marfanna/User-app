import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../theme/theme.dart';
import '../text/typography.dart';

class UndoButton extends StatelessWidget {
  const UndoButton({
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
        padding: .symmetric(horizontal: context.dimensions.spacing.s10),
        decoration: BoxDecoration(
          color: context.color.background.surface,
          border: Border.all(color: context.color.border.focus),
          borderRadius: BorderRadius.circular(context.dimensions.radius.r20),
        ),
        child:
            content ??
            Row(
              spacing: context.dimensions.spacing.s8,
              children: [
                Center(
                  child: Transform.flip(
                    flipX: true,
                    child: Assets.icons.swipeLeft.svg(
                      width: context.dimensions.size.s10,
                      height: context.dimensions.size.s10,
                    ),
                  ),
                ),
                TitleText.mediumBrand(title),
              ],
            ),
      ),
    );
  }
}
