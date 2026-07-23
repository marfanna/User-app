import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../models/fashion_product_args.dart';
import '../riverpod/fashion_products_provider.dart';

class FashionProductGridTile extends StatelessWidget {
  const FashionProductGridTile({super.key, required this.item});

  final FashionCatalogItem item;

  static void openProduct(BuildContext context, FashionCatalogItem item) {
    context.push(
      Routes.fashionProduct,
      extra: FashionProductArgs.fromProduct(
        item.product,
        shopId: item.shopId,
        shopName: item.shopName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final product = item.product;
    final hasCombos = product.combos.isNotEmpty;

    return GestureDetector(
      onTap: () => openProduct(context, item),
      child: Container(
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r16),
          border: Border.all(color: colors.border.divider),
          boxShadow: [
            BoxShadow(
              color: colors.elevation.elevationLow,
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _Image(image: product.image)),
            Padding(
              padding: EdgeInsets.all(dims.padding.p10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelSmall.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                  Gap(dims.spacing.s4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelLarge.copyWith(
                      color: colors.text.primary,
                      height: 1.18,
                    ),
                  ),
                  Gap(dims.spacing.s8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hasCombos
                              ? 'from Tk ${product.price.toStringAsFixed(0)}'
                              : 'Tk ${product.price.toStringAsFixed(0)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall.copyWith(
                            color: colors.text.primary,
                          ),
                        ),
                      ),
                      _OptionsButton(onTap: () => openProduct(context, item)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FashionWideProductCard extends StatelessWidget {
  const FashionWideProductCard({super.key, required this.item});

  final FashionCatalogItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final product = item.product;

    return GestureDetector(
      onTap: () => FashionProductGridTile.openProduct(context, item),
      child: Container(
        height: 118,
        padding: EdgeInsets.all(dims.padding.p8),
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r16),
          border: Border.all(color: colors.border.divider),
        ),
        child: Row(
          children: [
            AspectRatio(aspectRatio: 0.82, child: _Image(image: product.image)),
            Gap(dims.spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelSmall.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                  Gap(dims.spacing.s4),
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall.copyWith(height: 1.18),
                  ),
                  Gap(dims.spacing.s8),
                  Text(
                    'Tk ${product.price.toStringAsFixed(0)}',
                    style: text.labelLarge.copyWith(color: colors.text.primary),
                  ),
                ],
              ),
            ),
            Gap(dims.spacing.s8),
            _OptionsButton(
              onTap: () => FashionProductGridTile.openProduct(context, item),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionsButton extends StatelessWidget {
  const _OptionsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: dims.size.s32,
        height: dims.size.s32,
        decoration: BoxDecoration(
          color: colors.background.surface,
          shape: BoxShape.circle,
          border: Border.all(color: colors.border.divider),
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: colors.icon.primary,
          size: dims.size.s18,
        ),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  const _Image({this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    Widget placeholder() => Container(
      color: colors.background.surfaceContainerHighDim,
      alignment: Alignment.center,
      child: Icon(
        Icons.checkroom_outlined,
        size: dims.size.s40,
        color: colors.icon.secondary,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(dims.radius.r16),
      child: SizedBox.expand(
        child: image != null && image!.isNotEmpty
            ? Image.network(
                image!,
                fit: BoxFit.cover,
                cacheWidth: 500,
                errorBuilder: (_, _, _) => placeholder(),
              )
            : placeholder(),
      ),
    );
  }
}
