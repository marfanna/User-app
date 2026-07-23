import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../medicine_home/widgets/medicine_section_header.dart';
import '../models/fashion_listing_args.dart';
import '../riverpod/fashion_products_provider.dart';
import 'fashion_product_grid_tile.dart';

/// One Fashion homepage category strip: title + "See all" + up to 6 products.
/// Mirrors `MartCategorySection`. Auto-hides while loading-empty or on error.
class FashionCategorySection extends ConsumerWidget {
  const FashionCategorySection({super.key, required this.category});

  final String category;

  static const double cardWidth = 164;
  static const double stripHeight = 292;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final async = ref.watch(fashionCategoryPreviewProvider(category));

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
                Routes.fashionListing,
                extra: FashionListingArgs(categoryLabel: category),
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
                  child: FashionProductGridTile(item: items[i]),
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
      width: FashionCategorySection.cardWidth,
      child: Container(
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.background.surfaceContainerHighDim,
                  borderRadius: BorderRadius.circular(dims.radius.r16),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(dims.padding.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
          height: FashionCategorySection.stripHeight,
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
