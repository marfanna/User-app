import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/toast.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../models/mart_product_args.dart';
import '../riverpod/mart_products_provider.dart';

/// Vertical 2-column grid card for Mart products. Mirrors
/// `MedicineProductGridTile` — no stock gating (Duare holds no inventory; a
/// rider buys the item in person), so the "+" is always enabled.
class MartProductGridTile extends ConsumerWidget {
  const MartProductGridTile({super.key, required this.item});

  final MartCatalogItem item;

  void _open(BuildContext context) {
    context.push(
      Routes.martProduct,
      extra: MartProductArgs(
        productId: item.product.id,
        shopId: item.shopId,
        shopName: item.shopName,
        name: item.product.name,
        price: item.product.price,
        image: item.product.image,
        description: item.product.description,
        mrp: item.product.mrp,
      ),
    );
  }

  void _quickAdd(BuildContext context, WidgetRef ref) {
    ref.read(cartProvider.notifier).addItem(
          item: item.product.toApiMenuItem(),
          shopName: item.shopName,
          shopId: item.shopId,
          quantity: 1,
          selectedChoices: const {},
        );
    Toast.success(context, 'Added to cart');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final product = item.product;

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
                    '৳${product.price.toStringAsFixed(0)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleMedium.copyWith(
                      color: colors.brand.secondary,
                    ),
                  ),
                ),
                _AddButton(onTap: () => _quickAdd(context, ref)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

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
          Icons.add_rounded,
          color: colors.icon.inverse,
          size: dims.size.s20,
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
        Icons.shopping_basket_outlined,
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
