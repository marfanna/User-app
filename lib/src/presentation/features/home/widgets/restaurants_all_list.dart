import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../riverpod/restaurants_provider.dart';
import 'shop_card.dart';

class RestaurantsAllList extends ConsumerWidget {
  const RestaurantsAllList({super.key});

  static const int _skeletonCount = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(restaurantsProvider).when(
      loading: _buildSkeleton,
      error: (_, _) => const SizedBox.shrink(),
      data: (shops) {
        if (shops.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Restaurants',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.28,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: shops.length,
              separatorBuilder: (_, _) => const Gap(16),
              itemBuilder: (_, i) => ShopCard(
                shop: shops[i],
                onTap: () =>
                    context.push(Routes.restaurantDetailPath(shops[i].id)),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 160,
          height: 22,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const Gap(16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _skeletonCount,
          separatorBuilder: (_, _) => const Gap(16),
          itemBuilder: (_, _) => const _SkeletonCard(),
        ),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const Gap(10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonLine(width: 160, height: 16),
                Gap(8),
                _SkeletonLine(width: 100, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
