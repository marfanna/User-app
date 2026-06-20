import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../models/featured_item.dart';
import '../riverpod/best_deals_provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../../add_food/view/add_food_screen.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';

class RestaurantsBestDeals extends ConsumerWidget {
  const RestaurantsBestDeals({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(bestDealsProvider);

    return async.when(
      loading: () => _buildSkeleton(),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spotlight',
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
              height: 264,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: items.length,
                separatorBuilder: (_, _) => const Gap(16),
                itemBuilder: (_, i) => _DealCard(item: items[i]),
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
          width: 120,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const Gap(16),
        SizedBox(
          height: 264,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: 3,
            separatorBuilder: (_, _) => const Gap(16),
            itemBuilder: (_, _) => _SkeletonDealCard(),
          ),
        ),
      ],
    );
  }
}

class _DealCard extends StatelessWidget {
  const _DealCard({required this.item});

  final FeaturedItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final apiItem = ApiMenuItemData(
          id: item.item.id,
          name: item.item.name,
          image: item.item.image,
          price: item.item.price.toDouble(),
          description: '',
          options: [],
          variants: [],
          images: item.item.image != null ? [item.item.image!] : [],
        );
        context.push(
          Routes.addFood,
          extra: AddFoodArgs(
            item: apiItem,
            shopName: item.shop.name,
            shopId: item.shopId.isNotEmpty ? item.shopId : item.shop.id,
          ),
        );
      },
      child: Container(
        width: 251,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            _ItemImage(imageUrl: item.item.image, fallbackUrl: item.shop.logo),
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
                          item.item.name,
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
                    ],
                  ),
                  const Gap(12),
                  Text(
                    item.shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF040707),
                    ),
                  ),
                  const Gap(12),
                  Text(
                    'BDT ${item.item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      height: 1.28,
                      color: Color(0xFF0156A7),
                    ),
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

class _ItemImage extends StatefulWidget {
  const _ItemImage({this.imageUrl, this.fallbackUrl});

  final String? imageUrl;
  final String? fallbackUrl;

  @override
  State<_ItemImage> createState() => _ItemImageState();
}

class _ItemImageState extends State<_ItemImage> {
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
    final url = _url;
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 231,
        height: 140,
        color: const Color(0xFFE0E0E0),
        child: url != null
            ? Image.network(
                url,
                width: 231,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  if (!_primaryFailed &&
                      widget.fallbackUrl != null &&
                      widget.fallbackUrl!.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _primaryFailed = true);
                    });
                  }
                  return Container(color: const Color(0xFFE0E0E0));
                },
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}

class _SkeletonDealCard extends StatelessWidget {
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
                const Gap(12),
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(12),
                Container(
                  width: 80,
                  height: 18,
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
