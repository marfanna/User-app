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
    this.onItemTap,
  });

  final String title;
  final AsyncValue<List<FeaturedItem>> async;

  /// Override the default medicine-product-detail navigation per item —
  /// used by other verticals (e.g. Mart) reusing this strip.
  final void Function(FeaturedItem item)? onItemTap;

  // Was 250 — MedicineProductCard's content (image + name + shop + price row)
  // overflowed the bottom by ~7px at default text scale. Bumped with buffer
  // for larger accessibility text-scale settings too.
  static const double stripHeight = 268;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;

    // Leading gap lives here (not in the parent Column) so a collapsed
    // (empty/error) strip contributes zero space instead of leaving a dead
    // fixed gap behind it — see mart hero-banner gap fix.
    return async.when(
      loading: () => Padding(
        padding: EdgeInsets.only(top: dims.spacing.s24),
        child: _StripSkeleton(title: title),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.only(top: dims.spacing.s24),
          child: Column(
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
                  itemBuilder: (_, i) => MedicineProductCard(
                    item: items[i],
                    onTap: onItemTap == null
                        ? null
                        : () => onItemTap!(items[i]),
                  ),
                ),
              ),
            ],
          ),
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
