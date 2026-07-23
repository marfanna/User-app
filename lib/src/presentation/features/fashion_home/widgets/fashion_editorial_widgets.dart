import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../home/models/shop_data.dart';
import '../models/fashion_listing_args.dart';
import '../riverpod/fashion_products_provider.dart';
import 'fashion_product_grid_tile.dart';

class FashionHero extends StatelessWidget {
  const FashionHero({super.key, required this.featured});

  final FashionCatalogItem? featured;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final product = featured?.product;

    return GestureDetector(
      onTap: featured == null
          ? null
          : () => FashionProductGridTile.openProduct(context, featured!),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dims.radius.r24),
        child: Container(
          height: 190,
          width: double.infinity,
          color: colors.background.surfaceContainerHighest,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (product?.image != null && product!.image!.isNotEmpty)
                Image.network(
                  product.image!,
                  fit: BoxFit.cover,
                  cacheWidth: 1000,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      colors.text.primary.withValues(alpha: 0.78),
                      colors.text.primary.withValues(alpha: 0.28),
                      colors.background.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(dims.padding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroBadge(label: 'New season'),
                    const Spacer(),
                    Text(
                      'Style that arrives at your door',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.displaySmallCompact.copyWith(
                        color: colors.text.inverse,
                        letterSpacing: 0,
                        height: 1.08,
                      ),
                    ),
                    Gap(dims.spacing.s8),
                    Text(
                      product == null
                          ? 'Browse local boutiques and fresh drops'
                          : '${product.name} · ${featured!.shopName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall.copyWith(
                        color: colors.text.inverse.withValues(alpha: 0.86),
                      ),
                    ),
                    Gap(dims.spacing.s16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Shop collection',
                          style: text.labelLarge.copyWith(
                            color: colors.text.inverse,
                          ),
                        ),
                        Gap(dims.spacing.s8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: colors.icon.inverse,
                          size: dims.size.s18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dims.padding.p10,
        vertical: dims.padding.p6,
      ),
      decoration: BoxDecoration(
        color: colors.background.surface.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(dims.radius.r64),
        border: Border.all(
          color: colors.background.surface.withValues(alpha: 0.24),
        ),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmallSemiBold.copyWith(
          color: colors.text.inverse,
        ),
      ),
    );
  }
}

class FashionStyleChips extends StatelessWidget {
  const FashionStyleChips({super.key, required this.categories});

  final List<String> categories;

  static const _fallback = ['New', 'Women', 'Men', 'Shoes', 'Bags', 'Sale'];

  @override
  Widget build(BuildContext context) {
    final labels = categories.isNotEmpty
        ? categories.take(8).toList()
        : _fallback;
    final dims = context.dimensions;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: labels.length,
        separatorBuilder: (_, _) => Gap(dims.spacing.s8),
        itemBuilder: (context, index) {
          final label = labels[index];
          return _StyleChip(
            label: label,
            onTap: categories.contains(label)
                ? () => context.push(
                    Routes.fashionListing,
                    extra: FashionListingArgs(categoryLabel: label),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _StyleChip extends StatelessWidget {
  const _StyleChip({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r64),
          border: Border.all(color: colors.border.divider),
        ),
        child: Text(
          label,
          style: context.textStyle.labelMedium.copyWith(
            color: colors.text.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class FashionProductRail extends StatelessWidget {
  const FashionProductRail({
    super.key,
    required this.title,
    required this.items,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final List<FashionCatalogItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FashionSectionTitle(title: title, subtitle: subtitle),
        Gap(dims.spacing.s16),
        SizedBox(
          height: 292,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, _) => Gap(dims.spacing.s12),
            itemBuilder: (_, index) => SizedBox(
              width: 164,
              child: FashionProductGridTile(item: items[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class FashionShopRail extends StatelessWidget {
  const FashionShopRail({super.key, required this.shops});

  final List<ShopData> shops;

  @override
  Widget build(BuildContext context) {
    if (shops.isEmpty) return const SizedBox.shrink();
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FashionSectionTitle(
          title: 'Local boutiques',
          subtitle: 'Browse stores with their own style',
        ),
        Gap(dims.spacing.s16),
        SizedBox(
          height: 152,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: shops.length,
            separatorBuilder: (_, _) => Gap(dims.spacing.s12),
            itemBuilder: (_, index) => _BoutiqueCard(shop: shops[index]),
          ),
        ),
      ],
    );
  }
}

class _BoutiqueCard extends StatelessWidget {
  const _BoutiqueCard({required this.shop});

  final ShopData shop;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: () => context.push(Routes.fashionShopPath(shop.id)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dims.radius.r20),
        child: Container(
          width: 220,
          color: colors.background.surfaceContainerHighest,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (shop.banner != null && shop.banner!.isNotEmpty)
                Image.network(
                  shop.banner!,
                  fit: BoxFit.cover,
                  cacheWidth: 600,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      colors.background.transparent,
                      colors.text.primary.withValues(alpha: 0.74),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: dims.padding.p16,
                right: dims.padding.p16,
                bottom: dims.padding.p16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall.copyWith(
                        color: colors.text.inverse,
                      ),
                    ),
                    Gap(dims.spacing.s4),
                    Text(
                      shop.area ?? 'Fashion store',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.labelSmall.copyWith(
                        color: colors.text.inverse.withValues(alpha: 0.84),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FashionSectionTitle extends StatelessWidget {
  const _FashionSectionTitle({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: text.titleLarge.copyWith(
            color: colors.text.primary,
            letterSpacing: 0,
          ),
        ),
        if (subtitle != null) ...[
          Gap(dims.spacing.s4),
          Text(
            subtitle!,
            style: text.bodySmall.copyWith(color: colors.text.secondary),
          ),
        ],
      ],
    );
  }
}
