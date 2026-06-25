import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';

/// Tap-to-search field for the medicine homepage. Routes to the shared search
/// screen, matching the restaurant home pattern.
class MedicineSearchBar extends StatelessWidget {
  const MedicineSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: () => context.push(Routes.search),
      child: Container(
        width: double.infinity,
        height: dims.size.s48,
        padding: EdgeInsets.symmetric(
          horizontal: dims.padding.p20,
          vertical: dims.padding.p12,
        ),
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r64),
          boxShadow: [
            BoxShadow(
              color: colors.elevation.elevationLow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              color: colors.icon.secondary,
              size: dims.size.s20,
            ),
            Gap(dims.spacing.s10),
            Expanded(
              child: Text(
                'Search medicines & pharmacies..',
                style: text.bodySmallCompactLoose.copyWith(
                  color: colors.text.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
