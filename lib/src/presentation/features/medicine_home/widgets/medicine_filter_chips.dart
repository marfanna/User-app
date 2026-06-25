import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';

/// Horizontal selectable filter pills. `null` value = the leading "All" chip.
/// Shared by the pharmacy storefront and medicine listing pages.
class MedicineFilterChips extends StatelessWidget {
  const MedicineFilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.allLabel = 'All',
  });

  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;
    final items = <String?>[null, ...options];

    return SizedBox(
      height: dims.size.s36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: items.length,
        separatorBuilder: (_, _) => Gap(dims.spacing.s8),
        itemBuilder: (_, i) {
          final value = items[i];
          return _Chip(
            label: value ?? allLabel,
            selected: value == selected,
            onTap: () => onSelected(value),
          );
        },
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
        decoration: BoxDecoration(
          color: selected
              ? colors.brand.primary.withValues(alpha: 0.1)
              : colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r64),
          border: Border.all(
            color: selected ? colors.brand.primary : colors.border.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: text.labelMedium.copyWith(
            color: selected ? colors.brand.primary : colors.text.primary,
          ),
        ),
      ),
    );
  }
}
