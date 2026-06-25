import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../home/models/shop_data.dart';
import '../riverpod/medicine_pharmacies_provider.dart';
import 'medicine_section_header.dart';

/// "Nearby Pharmacies" horizontal shop strip. Tokenized port of the restaurant
/// trending strip, scoped to franchise pharmacy shops.
class MedicineNearbyPharmacies extends ConsumerWidget {
  const MedicineNearbyPharmacies({super.key});

  static const double stripHeight = 229;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final async = ref.watch(medicinePharmaciesProvider);

    return async.when(
      loading: () => const _Skeleton(stripHeight: stripHeight),
      error: (_, _) => const SizedBox.shrink(),
      data: (shops) {
        if (shops.isEmpty) return const SizedBox.shrink();
        final nearby = shops.take(8).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MedicineSectionHeader(title: 'Nearby Pharmacies'),
            Gap(dims.spacing.s16),
            SizedBox(
              height: stripHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: nearby.length,
                separatorBuilder: (_, _) => Gap(dims.spacing.s16),
                itemBuilder: (_, i) => _PharmacyCard(
                  shop: nearby[i],
                  onTap: () => context.push(Routes.pharmacyPath(nearby[i].id)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PharmacyCard extends StatelessWidget {
  const _PharmacyCard({required this.shop, required this.onTap});

  final ShopData shop;
  final VoidCallback onTap;

  static const double cardWidth = 251;
  static const double imageWidth = 231;
  static const double imageHeight = 140;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
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
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(dims.radius.r8),
                  child: _ShopImage(
                    width: imageWidth,
                    height: imageHeight,
                    banner: shop.banner,
                    logo: shop.logo,
                  ),
                ),
                if (!shop.isOpen)
                  Positioned.fill(
                    child: _ClosedOverlay(isPaused: shop.isPaused),
                  ),
              ],
            ),
            Gap(dims.spacing.s10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: dims.padding.p4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          shop.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall,
                        ),
                      ),
                      Gap(dims.spacing.s8),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: colors.brand.primary,
                            size: dims.size.s20,
                          ),
                          Gap(dims.spacing.s4),
                          Text(
                            shop.rating != null && shop.rating! > 0
                                ? shop.rating!.toStringAsFixed(1)
                                : '0.0',
                            style: text.titleSmallNunito,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (shop.area != null) ...[
                    Gap(dims.spacing.s6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: colors.icon.secondary,
                          size: dims.size.s16,
                        ),
                        Gap(dims.spacing.s4),
                        Expanded(
                          child: Text(
                            shop.area!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.bodySmall.copyWith(
                              color: colors.text.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClosedOverlay extends StatelessWidget {
  const _ClosedOverlay({required this.isPaused});

  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Container(
      decoration: BoxDecoration(
        color: colors.text.primary.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(dims.radius.r8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isPaused ? 'Temporarily Closed' : 'Closed',
            style: text.titleSmall.copyWith(color: colors.text.inverse),
          ),
          Gap(dims.spacing.s8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: dims.padding.p16,
              vertical: dims.padding.p8,
            ),
            decoration: BoxDecoration(
              color: colors.background.surface,
              borderRadius: BorderRadius.circular(dims.radius.r20),
            ),
            child: Text(
              'Order For Later',
              style: text.labelSmallSemiBold.copyWith(
                color: colors.text.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShopImage extends StatefulWidget {
  const _ShopImage({
    required this.width,
    required this.height,
    this.banner,
    this.logo,
  });

  final double width;
  final double height;
  final String? banner;
  final String? logo;

  @override
  State<_ShopImage> createState() => _ShopImageState();
}

class _ShopImageState extends State<_ShopImage> {
  bool _bannerFailed = false;

  String? get _url {
    if (!_bannerFailed && widget.banner != null && widget.banner!.isNotEmpty) {
      return widget.banner;
    }
    if (widget.logo != null && widget.logo!.isNotEmpty) return widget.logo;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final url = _url;

    return Container(
      width: widget.width,
      height: widget.height,
      color: colors.background.surfaceContainerHighDim,
      child: url != null
          ? Image.network(
              url,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
              cacheWidth: 460,
              errorBuilder: (_, _, _) {
                if (!_bannerFailed &&
                    widget.logo != null &&
                    widget.logo!.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _bannerFailed = true);
                  });
                }
                return Container(
                  color: colors.background.surfaceContainerHighDim,
                );
              },
            )
          : const SizedBox.shrink(),
    );
  }
}

class _Skeleton extends StatelessWidget {
  const _Skeleton({required this.stripHeight});

  final double stripHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    Widget bar(double w, double h) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighDim,
        borderRadius: BorderRadius.circular(dims.radius.r4),
      ),
    );

    Widget card() => Container(
      width: _PharmacyCard.cardWidth,
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
          ClipRRect(
            borderRadius: BorderRadius.circular(dims.radius.r8),
            child: bar(_PharmacyCard.imageWidth, _PharmacyCard.imageHeight),
          ),
          Gap(dims.spacing.s10),
          bar(140, 16),
          Gap(dims.spacing.s8),
          bar(90, 14),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        bar(180, 22),
        Gap(dims.spacing.s16),
        SizedBox(
          height: stripHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 3,
            separatorBuilder: (_, _) => Gap(dims.spacing.s16),
            itemBuilder: (_, _) => card(),
          ),
        ),
      ],
    );
  }
}
