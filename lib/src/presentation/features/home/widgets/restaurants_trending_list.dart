import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../models/shop_data.dart';
import '../riverpod/restaurants_provider.dart';

class RestaurantsTrendingList extends ConsumerWidget {
  const RestaurantsTrendingList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(restaurantsProvider);

    return async.when(
      loading: () => _buildSkeleton(),
      error: (_, _) => const SizedBox.shrink(),
      data: (shops) {
        if (shops.isEmpty) return const SizedBox.shrink();
        final trending = shops.take(6).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trending Restaurants',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.28,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(16),
            SizedBox(
              height: 229,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: trending.length,
                separatorBuilder: (_, _) => const Gap(16),
                itemBuilder: (_, i) => _TrendingCard(
                  shop: trending[i],
                  onTap: () =>
                      context.push(Routes.restaurantDetailPath(trending[i].id)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 200,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 229,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 3,
            separatorBuilder: (_, _) => const Gap(16),
            itemBuilder: (_, _) => _SkeletonTrendingCard(),
          ),
        ),
      ],
    );
  }
}

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.shop, required this.onTap});

  final ShopData shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 251,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _ShopImage(
                    width: 231,
                    height: 140,
                    banner: shop.banner,
                    logo: shop.logo,
                  ),
                ),
                if (!shop.isOpen)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shop.isPaused ? 'Temporarily Closed' : 'Closed',
                            style: const TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
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
                    ),
                  ),
              ],
            ),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              color: Colors.black,
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

class _SkeletonTrendingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 251,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: 231,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Gap(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(8),
                Container(
                  width: 90,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
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
    final url = _url;
    return Container(
      width: widget.width,
      height: widget.height,
      color: const Color(0xFFE0E0E0),
      child: url != null
          ? Image.network(
              url,
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                if (!_bannerFailed &&
                    widget.logo != null &&
                    widget.logo!.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _bannerFailed = true);
                  });
                }
                return Container(color: const Color(0xFFE0E0E0));
              },
            )
          : const SizedBox.shrink(),
    );
  }
}
