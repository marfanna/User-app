import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../home/models/featured_item.dart';
import '../models/medicine_product_args.dart';

/// Horizontal-strip product card for medicines (Featured / Best Selling).
///
/// Tokenized: all colors via `context.color.*`, radii/padding via
/// `context.dimensions.*`, text via `context.textStyle.*`. Fixed layout
/// dimensions (card/image size) are intentional literals — no design token
/// exists for them, matching the rider/order card convention.
class MedicineProductCard extends StatelessWidget {
  const MedicineProductCard({super.key, required this.item});

  final FeaturedItem item;

  static const double cardWidth = 240;
  static const double imageWidth = 220;
  static const double imageHeight = 140;

  void _openProduct(BuildContext context) {
    context.push(
      Routes.medicineProductPath(item.item.id),
      extra: MedicineProductArgs(
        productId: item.item.id,
        shopId: item.shopId.isNotEmpty ? item.shopId : item.shop.id,
        shopName: item.shop.name,
        name: item.item.name,
        image: item.item.image,
        price: item.item.price.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final text = context.textStyle;

    return GestureDetector(
      onTap: () => _openProduct(context),
      child: Container(
        width: cardWidth,
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
            _ProductImage(
              imageUrl: item.item.image,
              fallbackUrl: item.shop.logo,
            ),
            Gap(dims.spacing.s10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dims.padding.p4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall,
                  ),
                  Gap(dims.spacing.s6),
                  Text(
                    item.shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.bodySmall.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                  Gap(dims.spacing.s8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          'BDT ${item.item.price.toStringAsFixed(0)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium.copyWith(
                            color: colors.brand.secondary,
                          ),
                        ),
                      ),
                      _AddButton(onTap: () => _openProduct(context)),
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

/// Image with graceful banner→logo fallback and a tinted placeholder.
class _ProductImage extends StatefulWidget {
  const _ProductImage({this.imageUrl, this.fallbackUrl});

  final String? imageUrl;
  final String? fallbackUrl;

  @override
  State<_ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<_ProductImage> {
  bool _primaryFailed = false;

  String? get _url {
    if (!_primaryFailed &&
        widget.imageUrl != null &&
        widget.imageUrl!.isNotEmpty) {
      return widget.imageUrl;
    }
    if (widget.fallbackUrl != null && widget.fallbackUrl!.isNotEmpty) {
      return widget.fallbackUrl;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final url = _url;

    return ClipRRect(
      borderRadius: BorderRadius.circular(dims.radius.r8),
      child: Container(
        width: MedicineProductCard.imageWidth,
        height: MedicineProductCard.imageHeight,
        color: colors.background.surfaceContainerHighDim,
        child: url != null
            ? Image.network(
                url,
                width: MedicineProductCard.imageWidth,
                height: MedicineProductCard.imageHeight,
                fit: BoxFit.cover,
                cacheWidth: 440,
                errorBuilder: (_, _, _) {
                  if (!_primaryFailed &&
                      widget.fallbackUrl != null &&
                      widget.fallbackUrl!.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _primaryFailed = true);
                    });
                  }
                  return _placeholder(context);
                },
              )
            : _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    return Container(
      width: MedicineProductCard.imageWidth,
      height: MedicineProductCard.imageHeight,
      color: colors.background.surfaceContainerHighDim,
      alignment: Alignment.center,
      child: Icon(
        Icons.medication_outlined,
        size: dims.size.s48,
        color: colors.icon.secondary,
      ),
    );
  }
}
