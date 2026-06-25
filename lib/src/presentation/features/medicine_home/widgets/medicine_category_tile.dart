import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Single icon tile in the medicine category grid.
///
/// Rounded surface chip with the category icon, label below. Selected state
/// uses a brand tint + border, mirroring the restaurant category selector but
/// fully tokenized. [label] is a real (owner-typed) `itemCategory` value.
class MedicineCategoryTile extends StatelessWidget {
  const MedicineCategoryTile({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: dims.size.s60,
            height: dims.size.s60,
            decoration: BoxDecoration(
              color: selected
                  ? colors.brand.primary.withValues(alpha: 0.1)
                  : colors.background.surface,
              borderRadius: BorderRadius.circular(dims.radius.r16),
              border: Border.all(
                color: selected
                    ? colors.brand.primary
                    : colors.border.divider,
                width: selected ? 2 : 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: dims.size.s28,
              color: selected ? colors.brand.primary : colors.icon.primary,
            ),
          ),
          Gap(dims.spacing.s6),
          Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmallSemiBold.copyWith(
              color: selected ? colors.brand.primary : colors.text.primary,
            ),
          ),
        ],
      ),
    );
  }
}
