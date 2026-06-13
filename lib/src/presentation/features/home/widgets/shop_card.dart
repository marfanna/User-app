import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/shop_data.dart';

/// Reusable shop card: banner image on top, name + rating + area below.
/// Used by [RestaurantsAllList], [FavouritesScreen], etc.
class ShopCard extends StatelessWidget {
  const ShopCard({super.key, required this.shop, required this.onTap});

  final ShopData shop;
  final VoidCallback onTap;

  static const double _imageHeight = 140;
  static const double _cardRadius = 10;
  static const double _imageRadius = 8;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(_cardRadius),
        ),
        child: Column(
          children: [
            _ShopBannerImage(
              shop: shop,
              height: _imageHeight,
              radius: _imageRadius,
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            height: 1.28,
                            color: Color(0xFF040707),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFF6700),
                            size: 20,
                          ),
                          const Gap(4),
                          Text(
                            shop.rating != null && shop.rating! > 0
                                ? shop.rating!.toStringAsFixed(1)
                                : '0.0',
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              height: 1.2,
                              color: Color(0xFF040707),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (shop.area != null) ...[
                    const Gap(6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xFF646464),
                          size: 16,
                        ),
                        const Gap(5),
                        Text(
                          shop.area!,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF040707),
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

/// Banner image with logo fallback and closed overlay.
/// Extracted so it can be reused independently.
class _ShopBannerImage extends StatelessWidget {
  const _ShopBannerImage({
    required this.shop,
    required this.height,
    required this.radius,
  });

  final ShopData shop;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: _NetworkImageWithFallback(
            banner: shop.banner,
            logo: shop.logo,
            height: height,
          ),
        ),
        if (!shop.isOpen)
          Positioned.fill(
            child: _ClosedOverlay(
              radius: radius,
              label: shop.isPaused ? 'Temporarily Closed' : 'Closed',
            ),
          ),
      ],
    );
  }
}

/// Shows a dark overlay with a "Closed" or "Temporarily Closed" label.
class _ClosedOverlay extends StatelessWidget {
  const _ClosedOverlay({required this.radius, required this.label});

  final double radius;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const Gap(8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Order For Later',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: Color(0xFF040707),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Network image that falls back from banner → logo → placeholder.
class _NetworkImageWithFallback extends StatefulWidget {
  const _NetworkImageWithFallback({
    this.banner,
    this.logo,
    required this.height,
  });

  final String? banner;
  final String? logo;
  final double height;

  @override
  State<_NetworkImageWithFallback> createState() =>
      _NetworkImageWithFallbackState();
}

class _NetworkImageWithFallbackState
    extends State<_NetworkImageWithFallback> {
  bool _bannerFailed = false;

  String? get _url {
    if (!_bannerFailed &&
        widget.banner != null &&
        widget.banner!.isNotEmpty) {
      return widget.banner;
    }
    if (widget.logo != null && widget.logo!.isNotEmpty) return widget.logo;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final url = _url;
    return Container(
      width: double.infinity,
      height: widget.height,
      color: const Color(0xFFE0E0E0),
      child: url != null
          ? Image.network(
              url,
              width: double.infinity,
              height: widget.height,
              fit: BoxFit.cover,
              cacheWidth: 800,
              errorBuilder: (_, _, _) {
                _tryFallback();
                return Container(color: const Color(0xFFE0E0E0));
              },
            )
          : const SizedBox.shrink(),
    );
  }

  void _tryFallback() {
    if (_bannerFailed) return;
    if (widget.logo == null || widget.logo!.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _bannerFailed = true);
    });
  }
}
