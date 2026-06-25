import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/toast.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../models/medicine_product_args.dart';
import '../models/medicine_product_detail.dart';

/// Vertical 2-column grid card for medicines. Used by the pharmacy storefront
/// and the medicine listing page. Tap → product detail; "+" → quick add 1.
class MedicineProductGridTile extends ConsumerWidget {
  const MedicineProductGridTile({
    super.key,
    required this.product,
    required this.shopName,
  });

  final MedicineProductDetail product;
  final String shopName;

  void _open(BuildContext context) {
    context.push(
      Routes.medicineProductPath(product.id),
      extra: MedicineProductArgs(
        productId: product.id,
        shopId: product.shopId,
        shopName: shopName,
        name: product.name,
        image: product.image,
        price: product.price,
      ),
    );
  }

  void _quickAdd(BuildContext context, WidgetRef ref) {
    ref.read(cartProvider.notifier).addItem(
          item: product.toApiMenuItem(),
          shopName: shopName,
          shopId: product.shopId,
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

    final subtitle = product.strength?.trim().isNotEmpty == true
        ? product.strength!.trim()
        : (product.genericName?.trim() ?? '');

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
            if (subtitle.isNotEmpty) ...[
              Gap(dims.spacing.s2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.labelMedium.copyWith(color: colors.text.secondary),
              ),
            ],
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
                _AddButton(
                  enabled: product.inStock,
                  onTap: () => _quickAdd(context, ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: dims.size.s32,
        height: dims.size.s32,
        decoration: BoxDecoration(
          color: enabled
              ? colors.brand.primary
              : colors.background.surfaceVariant,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add_rounded,
          color: enabled ? colors.icon.inverse : colors.text.disabled,
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
        Icons.medication_outlined,
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
                // Cap decode size to keep grid memory bounded (crash guard).
                cacheWidth: 400,
                errorBuilder: (_, _, _) => placeholder(),
              )
            : placeholder(),
      ),
    );
  }
}
