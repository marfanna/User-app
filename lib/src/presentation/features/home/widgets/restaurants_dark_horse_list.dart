import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../riverpod/dark_horse_shops_provider.dart';
import 'restaurant_strip_skeleton.dart';
import 'shop_card.dart';

/// Horizontal strip for "Dark Horse" restaurants — new joiners already
/// topping the order charts. Reuses the shared [ShopCard].
class RestaurantsDarkHorseList extends ConsumerWidget {
  const RestaurantsDarkHorseList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(darkHorseShopsProvider);

    return async.when(
      loading: () => const RestaurantStripSkeleton(titleWidth: 110),
      error: (_, _) => const SizedBox.shrink(),
      data: (shops) {
        if (shops.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dark Horse',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.28,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(4),
            const Text(
              'New restaurants already topping the charts',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: Color(0xFF646464),
              ),
            ),
            const Gap(16),
            SizedBox(
              height: 249,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: shops.length,
                separatorBuilder: (_, _) => const Gap(16),
                itemBuilder: (_, i) => SizedBox(
                  width: 231,
                  child: ShopCard(
                    shop: shops[i],
                    onTap: () =>
                        context.push(Routes.restaurantDetailPath(shops[i].id)),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
