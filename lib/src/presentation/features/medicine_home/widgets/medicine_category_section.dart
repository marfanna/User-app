import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../models/medicine_listing_args.dart';
import '../riverpod/medicine_category_preview_provider.dart';
import 'medicine_product_grid_tile.dart';
import 'medicine_section_header.dart';

/// One homepage category strip: title + "See all" + up to 6 products in a
/// horizontal scroll. Tapping "See all" opens the full category listing.
/// Auto-hides while loading-empty or on error so the homepage stays clean.
class MedicineCategorySection extends ConsumerWidget {
  const MedicineCategorySection({super.key, required this.category});

  final String category;

  static const double cardWidth = 150;
  static const double stripHeight = 250;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final async = ref.watch(medicineCategoryPreviewProvider(category));

    return async.when(
      loading: () => _Skeleton(category: category),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicineSectionHeader(
              title: category,
              onSeeAll: () => context.push(
                Routes.medicineListing,
                extra: MedicineListingArgs(categoryLabel: category),
              ),
            ),
            Gap(dims.spacing.s16),
            SizedBox(
              height: stripHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: items.length,
                separatorBuilder: (_, _) => Gap(dims.spacing.s12),
                itemBuilder: (_, i) => SizedBox(
                  width: cardWidth,
                  child: MedicineProductGridTile(
                    product: items[i].product,
                    shopName: items[i].shopName,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    Widget card() => SizedBox(
      width: MedicineCategorySection.cardWidth,
      child: Container(
        padding: EdgeInsets.all(dims.padding.p10),
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.background.surfaceContainerHighDim,
                  borderRadius: BorderRadius.circular(dims.radius.r8),
                ),
              ),
            ),
            Gap(dims.spacing.s8),
            Container(
              width: 90,
              height: 14,
              color: colors.background.surfaceContainerHighDim,
            ),
            Gap(dims.spacing.s8),
            Container(
              width: 50,
              height: 14,
              color: colors.background.surfaceContainerHighDim,
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MedicineSectionHeader(title: category),
        Gap(dims.spacing.s16),
        SizedBox(
          height: MedicineCategorySection.stripHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 3,
            separatorBuilder: (_, _) => Gap(dims.spacing.s12),
            itemBuilder: (_, _) => card(),
          ),
        ),
      ],
    );
  }
}
