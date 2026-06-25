import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../home/models/featured_item.dart';
import 'medicine_product_card.dart';
import 'medicine_section_header.dart';

/// Reusable horizontal medicine product strip used by the Featured and
/// Best Selling sections. Handles loading (skeleton), empty (auto-hide), and
/// error (auto-hide) states so callers stay declarative.
class MedicineProductStrip extends StatelessWidget {
  const MedicineProductStrip({
    super.key,
    required this.title,
    required this.async,
  });

  final String title;
  final AsyncValue<List<FeaturedItem>> async;

  static const double stripHeight = 250;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => _StripSkeleton(title: title),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        final dims = context.dimensions;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicineSectionHeader(title: title),
            Gap(dims.spacing.s16),
            SizedBox(
              height: stripHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: items.length,
                separatorBuilder: (_, _) => Gap(dims.spacing.s16),
                itemBuilder: (_, i) => MedicineProductCard(item: items[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StripSkeleton extends StatelessWidget {
  const _StripSkeleton({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    Widget bar(double w, double h) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighDim,
        borderRadius: BorderRadius.circular(dims.radius.r4),
      ),
    );

    Widget card() => Container(
      width: MedicineProductCard.cardWidth,
      padding: EdgeInsets.all(dims.padding.p10),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r12),
        boxShadow: [
          BoxShadow(
            color: colors.elevation.elevationLow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(dims.radius.r8),
            child: bar(
              MedicineProductCard.imageWidth,
              MedicineProductCard.imageHeight,
            ),
          ),
          Gap(dims.spacing.s10),
          bar(140, 16),
          Gap(dims.spacing.s8),
          bar(90, 14),
          Gap(dims.spacing.s8),
          bar(70, 18),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(160, 22),
        Gap(dims.spacing.s16),
        SizedBox(
          height: MedicineProductStrip.stripHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 3,
            separatorBuilder: (_, _) => Gap(dims.spacing.s16),
            itemBuilder: (_, _) => card(),
          ),
        ),
      ],
    );
  }
}
