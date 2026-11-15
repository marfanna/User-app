import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../models/laundry_service_args.dart';
import '../riverpod/laundry_provider.dart';

/// Icon for a laundry category name. Shared by tiles, rows and the detail
/// header so a category always reads the same everywhere.
IconData laundryCategoryIcon(String? category) {
  final value = category?.toLowerCase() ?? '';
  if (value.contains('women')) return Icons.dry_cleaning_outlined;
  if (value.contains('men')) return Icons.checkroom_outlined;
  if (value.contains('blanket') || value.contains('quilt')) {
    return Icons.king_bed_outlined;
  }
  if (value.contains('bedsheet') || value.contains('bedding')) {
    return Icons.bed_outlined;
  }
  if (value.contains('curtain') || value.contains('cover')) {
    return Icons.curtains_outlined;
  }
  if (value.contains('kid') || value.contains('school')) {
    return Icons.child_care_outlined;
  }
  if (value.contains('iron') || value.contains('press')) {
    return Icons.iron_outlined;
  }
  return Icons.local_laundry_service_outlined;
}

const _imageBase = 'https://api-v2.duare.net/uploads/product_image/';

/// Category tile photos (uploaded with the laundry catalog, 2026-11-15).
/// Unknown categories fall back to the icon box.
String? laundryCategoryImage(String? category) {
  final value = category?.toLowerCase() ?? '';
  final file = switch (value) {
    _ when value.contains('women') =>
      '1794744938925_product_image_'
          '1794744938925_83746a15-4527-4df9-a74c-51b046e21c0f.jpg',
    _ when value.contains('men') =>
      '1794744882550_product_image_'
          '1794744882550_0a7603a7-c52d-4849-b7f2-06ef072fcdbb.jpg',
    _ when value.contains('bedding') =>
      '1794744954266_product_image_'
          '1794744954266_f4bbc50c-ecd1-464a-b572-02af7c3c546f.jpg',
    _ when value.contains('blanket') =>
      '1794744887485_product_image_'
          '1794744887485_02db3344-a1ee-4bde-8f9a-7099f1ae25fe.jpg',
    _ when value.contains('curtain') =>
      '1794744984165_product_image_'
          '1794744984165_edf5f7f2-5db6-4ae1-bf96-dada62775b93.jpg',
    _ when value.contains('kids') =>
      '1794744973421_product_image_'
          '1794744973421_ab13b606-1af9-4abd-8341-c988c8f0675d.jpg',
    _ when value.contains('other') =>
      '1794744979310_product_image_'
          '1794744979310_072c8eb2-946e-41b8-8b6f-76c0fcd85521.jpg',
    _ => null,
  };
  return file == null ? null : '$_imageBase$file';
}

/// Product photo on a white tile; falls back to the category icon box when
/// there's no image or it fails to load.
class LaundryThumb extends StatelessWidget {
  const LaundryThumb({
    super.key,
    required this.size,
    this.image,
    this.category,
  });

  final double size;
  final String? image;
  final String? category;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final url = image;
    final fallback = LaundryIconBox(category: category, size: size);
    if (url == null || url.isEmpty) return fallback;

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.06),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r12),
        border: Border.all(color: colors.border.divider),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dims.radius.r8),
        child: Image.network(
          url,
          fit: BoxFit.contain,
          cacheWidth: (size * 3).round(),
          errorBuilder: (_, _, _) => Icon(
            laundryCategoryIcon(category),
            size: size * 0.5,
            color: colors.brand.primary,
          ),
        ),
      ),
    );
  }
}

/// Short label for category tiles/tabs ("Bedsheet & Bedding" → "Bedding").
String laundryShortCategory(String category) {
  final value = category.trim();
  final lower = value.toLowerCase();
  if (lower.startsWith("men's")) return 'Men';
  if (lower.startsWith("women's")) return 'Women';
  if (lower.contains('bedding')) return 'Bedding';
  if (lower.contains('blanket')) return 'Blanket';
  if (lower.contains('curtain')) return 'Curtain';
  if (lower.contains('kids')) return 'Kids';
  return value.split(' ').first;
}

/// One laundry item as a list row (Urban Company / Keeta pattern):
/// icon · English name + Bangla name · price · cart-linked add control.
class LaundryServiceRow extends StatelessWidget {
  const LaundryServiceRow({super.key, required this.item});

  final LaundryCatalogItem item;

  void _open(BuildContext context) {
    context.push(
      Routes.laundryService,
      extra: LaundryServiceArgs(
        service: item.service,
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
    final service = item.service;
    final bangla = service.banglaName;

    return GestureDetector(
      onTap: () => _open(context),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dims.padding.p12),
        child: Row(
          children: [
            LaundryThumb(
              size: dims.size.s56,
              image: service.image,
              category: service.itemCategory,
            ),
            Gap(dims.spacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.englishName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall,
                  ),
                  Gap(dims.spacing.s2),
                  Text(
                    bangla == null
                        ? service.unitLabel
                        : '$bangla · ${service.unitLabel}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelMedium.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Gap(dims.spacing.s12),
            Text(
              '৳${service.price.toStringAsFixed(0)}',
              style: text.titleMedium.copyWith(color: colors.brand.secondary),
            ),
            Gap(dims.spacing.s12),
            LaundryAddControl(item: item),
          ],
        ),
      ),
    );
  }
}

class LaundryIconBox extends StatelessWidget {
  const LaundryIconBox({super.key, this.category, this.size});

  final String? category;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final box = size ?? dims.size.s44;

    return Container(
      width: box,
      height: box,
      decoration: BoxDecoration(
        color: colors.brand.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(dims.radius.r12),
      ),
      child: Icon(
        laundryCategoryIcon(category),
        size: box * 0.5,
        color: colors.brand.primary,
      ),
    );
  }
}

/// "+" when the item isn't in the cart; a − qty + pill once it is.
/// Reads and writes the real cart, so the count is always truthful.
class LaundryAddControl extends ConsumerWidget {
  const LaundryAddControl({super.key, required this.item});

  final LaundryCatalogItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final service = item.service;

    final cartLine = ref
        .watch(cartProvider)
        .where(
          (c) =>
              c.item.id == service.id &&
              c.selectedVariant == null &&
              c.selectedChoices.isEmpty,
        )
        .firstOrNull;
    final notifier = ref.read(cartProvider.notifier);

    void add() => notifier.addItem(
      item: service.toApiMenuItem(),
      shopName: item.shopName,
      shopId: item.shopId,
      quantity: 1,
      selectedChoices: const {},
    );

    if (cartLine == null) {
      return GestureDetector(
        onTap: add,
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

    Widget button(IconData icon, VoidCallback onTap) => GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: dims.size.s28,
        height: dims.size.s32,
        child: Icon(icon, size: dims.size.s18, color: colors.icon.inverse),
      ),
    );

    return Container(
      height: dims.size.s32,
      decoration: BoxDecoration(
        color: colors.brand.primary,
        borderRadius: BorderRadius.circular(dims.radius.r64),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(
            Icons.remove_rounded,
            () => notifier.updateQuantity(cartLine.id, cartLine.quantity - 1),
          ),
          SizedBox(
            width: dims.size.s20,
            child: Text(
              '${cartLine.quantity}',
              textAlign: TextAlign.center,
              style: text.labelLarge.copyWith(color: colors.text.inverse),
            ),
          ),
          button(Icons.add_rounded, add),
        ],
      ),
    );
  }
}
