import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../medicine_home/widgets/medicine_home_header.dart';
import '../../medicine_home/widgets/medicine_search_bar.dart';
import '../riverpod/fashion_products_provider.dart';
import '../riverpod/fashion_shops_provider.dart';
import '../widgets/fashion_category_section.dart';
import '../widgets/fashion_editorial_widgets.dart';

class FashionHomeScreen extends ConsumerWidget {
  const FashionHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final categoriesAsync = ref.watch(fashionCategoriesProvider);
    final productsAsync = ref.watch(fashionProductsProvider);
    final shopsAsync = ref.watch(fashionShopsProvider);

    final categories = categoriesAsync.value ?? const <String>[];
    final products = productsAsync.value ?? const <FashionCatalogItem>[];
    final shops = shopsAsync.value ?? const [];
    final heroProduct = _heroProduct(products);
    final newDrops = products.take(8).toList();
    final trending = _trending(products);
    final underBudget = products
        .where((item) => item.product.price > 0 && item.product.price <= 1500)
        .take(8)
        .toList();

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
                      const MedicineHomeHeader(currentRoute: Routes.fashion),
                      Gap(dims.spacing.s24),
                      FashionHero(featured: heroProduct),
                      Gap(dims.spacing.s16),
                      const MedicineSearchBar(
                        vertical: 'fashion',
                        hintText: 'Search outfits, shoes, boutiques...',
                      ),
                      Gap(dims.spacing.s16),
                      FashionStyleChips(categories: categories),
                      Gap(dims.spacing.s24),
                      FashionProductRail(
                        title: 'New drops',
                        subtitle: 'Fresh pieces from local fashion shops',
                        items: newDrops,
                      ),
                      Gap(dims.spacing.s24),
                      FashionShopRail(shops: shops.take(8).toList()),
                      Gap(dims.spacing.s24),
                      FashionProductRail(
                        title: 'Trending fits',
                        subtitle: 'Popular styles with colour and size choices',
                        items: trending,
                      ),
                      Gap(dims.spacing.s24),
                      FashionProductRail(
                        title: 'Under Tk 1500',
                        subtitle: 'Easy style picks without overthinking it',
                        items: underBudget,
                      ),
                      Gap(dims.spacing.s24),
                    ],
                  ),
                ),
              ),
              _categorySections(context, categoriesAsync),
              SliverToBoxAdapter(child: Gap(dims.spacing.s100)),
            ],
          ),
        ),
      ),
    );
  }

  FashionCatalogItem? _heroProduct(List<FashionCatalogItem> products) {
    for (final item in products) {
      if (item.product.image != null && item.product.image!.isNotEmpty) {
        return item;
      }
    }
    return products.isEmpty ? null : products.first;
  }

  List<FashionCatalogItem> _trending(List<FashionCatalogItem> products) {
    final variantItems = products
        .where((item) => item.product.combos.isNotEmpty)
        .take(8)
        .toList();
    if (variantItems.isNotEmpty) return variantItems;
    return products.take(8).toList();
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
          itemCount: 2,
          separatorBuilder: (_, _) => Gap(dims.spacing.s24),
          itemBuilder: (_, _) => const _SectionPlaceholder(),
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
                FashionCategorySection(category: categories[i]),
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
      height: 292,
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r16),
      ),
    );
  }
}
