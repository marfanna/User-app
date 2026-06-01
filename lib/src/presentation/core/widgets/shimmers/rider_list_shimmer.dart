import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

class RiderListShimmer extends StatelessWidget {
  const RiderListShimmer({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(context.dimensions.padding.p16),
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, _) =>
          SizedBox(height: context.dimensions.spacing.s8),
      itemBuilder: (_, _) => const _RiderTileShimmer(),
    );
  }
}

class _RiderTileShimmer extends StatelessWidget {
  const _RiderTileShimmer();

  @override
  Widget build(BuildContext context) {
    final dim = context.dimensions;
    final colors = context.color;

    return Container(
      padding: EdgeInsets.all(dim.padding.p16),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dim.radius.r10),
        border: Border.all(color: colors.border.disabled),
      ),
      child: Shimmer.fromColors(
        period: const Duration(seconds: 3),
        baseColor: colors.background.surfaceVariant,
        highlightColor: colors.background.surfaceVariant.withValues(
          alpha: 0.25,
        ),
        child: Row(
          children: [
            Container(
              width: dim.size.s44,
              height: dim.size.s44,
              decoration: BoxDecoration(
                color: colors.background.surface,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: dim.spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: dim.size.s16,
                    width: 120,
                    decoration: BoxDecoration(
                      color: colors.background.surface,
                      borderRadius: BorderRadius.circular(dim.radius.r4),
                    ),
                  ),
                  SizedBox(height: dim.spacing.s4),
                  Container(
                    height: dim.size.s12,
                    width: 80,
                    decoration: BoxDecoration(
                      color: colors.background.surface,
                      borderRadius: BorderRadius.circular(dim.radius.r4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors.background.surface,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
