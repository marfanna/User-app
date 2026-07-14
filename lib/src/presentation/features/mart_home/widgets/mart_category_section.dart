import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../medicine_home/widgets/medicine_section_header.dart';
import '../models/mart_listing_args.dart';
import '../riverpod/mart_products_provider.dart';
import 'mart_product_grid_tile.dart';

/// One Mart homepage category strip: title + "See all" + up to 6 products.
/// Mirrors `MedicineCategorySection`. Auto-hides while loading-empty or on
/// error so the homepage stays clean.
class MartCategorySection extends ConsumerWidget {
  const MartCategorySection({super.key, required this.category});

  final String category;

  static const double cardWidth = 150;
  static const double stripHeight = 250;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final colors = context.color;
    final async = ref.watch(martCategoryPreviewProvider(category));
    final isMeat = isMeatCategory(category);

    return async.when(
      loading: () => _Skeleton(category: category),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        final section = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MedicineSectionHeader(
              title: category,
              leadingIcon: isMeat ? Icons.set_meal_outlined : null,
              onSeeAll: () => context.push(
                Routes.martListing,
                extra: MartListingArgs(categoryLabel: category),
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
                  child: MartProductGridTile(item: items[i]),
                ),
              ),
            ),
          ],
        );

        // Meat & Fish gets dedicated framing (stated business focus), not
        // just front-of-list ordering — a tinted, rounded container the
        // other categories don't have.
        if (!isMeat) return section;
        return Container(
          padding: EdgeInsets.all(dims.padding.p12),
          decoration: BoxDecoration(
            color: colors.brand.primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(dims.radius.r16),
            border: Border.all(
              color: colors.brand.primary.withValues(alpha: 0.15),
            ),
          ),
          child: section,
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
      width: MartCategorySection.cardWidth,
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
          height: MartCategorySection.stripHeight,
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
