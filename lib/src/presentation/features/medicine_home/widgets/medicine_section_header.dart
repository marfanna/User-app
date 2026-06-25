import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Section heading for the medicine homepage with an optional "See all" action.
///
/// Tokenized title (`titleLarge`) + brand-coloured trailing link. Used by the
/// product strips, category grid, and nearby pharmacies section.
class MedicineSectionHeader extends StatelessWidget {
  const MedicineSectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = 'See all',
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleLarge,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  seeAllLabel,
                  style: text.labelLarge.copyWith(color: colors.brand.primary),
                ),
                Gap(dims.spacing.s2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: dims.size.s20,
                  color: colors.brand.primary,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
