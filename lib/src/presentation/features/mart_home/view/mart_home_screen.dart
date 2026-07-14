import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../home/models/featured_item.dart';
import '../../medicine_home/widgets/medicine_home_header.dart';
import '../../medicine_home/widgets/medicine_nearby_pharmacies.dart';
import '../../medicine_home/widgets/medicine_product_strip.dart';
import '../../medicine_home/widgets/medicine_promotional_banner.dart';
import '../../medicine_home/widgets/medicine_reorder_strip.dart';
import '../../medicine_home/widgets/medicine_search_bar.dart';
import '../models/mart_product_args.dart';
import '../riverpod/mart_featured_provider.dart';
import '../riverpod/mart_products_provider.dart';
import '../riverpod/mart_reorder_provider.dart';
import '../riverpod/mart_shops_provider.dart';
import '../widgets/mart_category_section.dart';

/// Mart category homepage.
///
/// Mirrors the Medicine homepage structure exactly (see ui-registry.md):
/// Header → Search → Order Again → Featured → Best Selling → Banner, then
/// every real `itemCategory` as its own lazy strip ("Fish & Meat" pinned
/// first — the stated business focus), then Nearby Shops at the bottom.
class MartHomeScreen extends ConsumerWidget {
  const MartHomeScreen({super.key});

  static void _openProduct(BuildContext context, FeaturedItem item) {
    context.push(
      Routes.martProduct,
      extra: MartProductArgs(
        productId: item.item.id,
        shopId: item.shopId.isNotEmpty ? item.shopId : item.shop.id,
        shopName: item.shop.name,
        name: item.item.name,
        price: item.item.price.toDouble(),
        image: item.item.image,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final categoriesAsync = ref.watch(martCategoriesProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(dims.spacing.s16),
                      const MedicineHomeHeader(currentRoute: Routes.mart),
                      Gap(dims.spacing.s24),
                      const MedicineSearchBar(
                        vertical: 'mart',
                        hintText: 'Search mart shops..',
                      ),
                      MedicineReorderStrip(
                        icon: Icons.shopping_basket_outlined,
                        ordersAsync: ref.watch(martReorderProvider),
                      ),
                      MedicineProductStrip(
                        title: 'Featured',
                        async: ref.watch(martFeaturedProvider),
                        onItemTap: (item) => _openProduct(context, item),
                      ),
                      MedicineProductStrip(
                        title: 'Best Selling',
                        async: ref.watch(martBestSellingProvider),
                        onItemTap: (item) => _openProduct(context, item),
                      ),
                      Gap(dims.spacing.s24),
                      const MedicinePromotionalBanner(bannerCategory: 'mart'),
                      Gap(dims.spacing.s24),
                    ],
                  ),
                ),
              ),
              _categorySections(context, categoriesAsync),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  dims.padding.p16,
                  dims.spacing.s24,
                  dims.padding.p16,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: MedicineNearbyPharmacies(
                    title: 'Nearby Shops',
                    shopsAsync: ref.watch(martShopsProvider),
                    routeBuilder: Routes.martShopPath,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: Gap(dims.spacing.s100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categorySections(
    BuildContext context,
    AsyncValue<List<String>> async,
  ) {
    final dims = context.dimensions;

    return async.when(
      loading: () => SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, _) => Gap(dims.spacing.s24),
          itemBuilder: (_, i) => const _SectionPlaceholder(),
        ),
      ),
      error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (categories) {
        if (categories.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
          sliver: SliverList.separated(
            itemCount: categories.length,
            separatorBuilder: (_, _) => Gap(dims.spacing.s24),
            itemBuilder: (_, i) =>
                MartCategorySection(category: categories[i]),
          ),
        );
      },
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  const _SectionPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    return Container(
      width: 160,
      height: 22,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighDim,
        borderRadius: BorderRadius.circular(dims.radius.r4),
      ),
    );
  }
}
