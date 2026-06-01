import 'package:flutter/material.dart';

import '../../gen/assets.gen.dart';
import '../../theme/theme.dart';
import '../text/typography.dart';

class RejectButton extends StatelessWidget {
  const RejectButton({super.key, required this.title, required this.onPressed});

  const RejectButton.circular({super.key, required this.onPressed})
    : title = null;

  final String? title;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    bool isCircular = title == null;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: context.dimensions.size.s40,
        padding: isCircular
            ? .all(context.dimensions.spacing.s10)
            : .symmetric(
                vertical: context.dimensions.spacing.s8,
                horizontal: context.dimensions.spacing.s10,
              ),
        decoration: BoxDecoration(
          shape: isCircular ? .circle : .rectangle,
          color: context.color.error.defaultValue,
          borderRadius: isCircular
              ? null
              : BorderRadius.circular(context.dimensions.radius.r20),
        ),
        child: Row(
          mainAxisAlignment: .start,
          spacing: context.dimensions.spacing.s8,
          children: [
            Padding(
              padding: .all(context.dimensions.padding.p4),
              child: Assets.icons.clear.svg(
                width: context.dimensions.size.s14,
                height: context.dimensions.size.s14,
                fit: .fitHeight,
              ),
            ),
            if (!isCircular) TitleText.mediumInverse(title!),
          ],
        ),
      ),
    );
  }
}
