import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../models/fashion_product_args.dart';
import '../riverpod/fashion_products_provider.dart';

/// Vertical 2-column grid card for Fashion products. Unlike Mart/Medicine
/// there is no quick-add "+": a colour+size must be chosen first, so the
/// button opens the detail picker instead. Price shows "from ৳X" (the
/// cheapest combo) when the item has variants.
class FashionProductGridTile extends StatelessWidget {
  const FashionProductGridTile({super.key, required this.item});

  final FashionCatalogItem item;

  void _open(BuildContext context) {
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
      onTap: () => _open(context),
      child: Container(
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
            AspectRatio(
              aspectRatio: 1,
              child: _Image(image: product.image),
            ),
            Gap(dims.spacing.s8),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.titleSmall,
            ),
            Gap(dims.spacing.s8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    hasCombos
                        ? 'from ৳${product.price.toStringAsFixed(0)}'
                        : '৳${product.price.toStringAsFixed(0)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium.copyWith(
                      color: colors.brand.secondary,
                    ),
                  ),
                ),
                _OptionsButton(onTap: () => _open(context)),
              ],
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
          color: colors.brand.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.tune_rounded,
          color: colors.icon.inverse,
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
      borderRadius: BorderRadius.circular(dims.radius.r8),
      child: SizedBox.expand(
        child: image != null && image!.isNotEmpty
            ? Image.network(
                image!,
                fit: BoxFit.cover,
                cacheWidth: 400,
                errorBuilder: (_, _, _) => placeholder(),
              )
            : placeholder(),
      ),
    );
  }
}
