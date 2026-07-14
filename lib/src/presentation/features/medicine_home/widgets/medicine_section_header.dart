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
    this.leadingIcon,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;

  /// Optional icon badge before the title — used to give a specific section
  /// (e.g. Mart's Meat & Fish) a distinct visual identity beyond ordering.
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Container(
            width: dims.size.s32,
            height: dims.size.s32,
            decoration: BoxDecoration(
              color: colors.brand.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(dims.radius.r10),
            ),
            child: Icon(
              leadingIcon,
              size: dims.size.s18,
              color: colors.brand.primary,
            ),
          ),
          Gap(dims.spacing.s8),
        ],
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
