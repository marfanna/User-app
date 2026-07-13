import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../riverpod/homemade_shops_provider.dart';
import 'shop_card.dart';

/// Horizontal strip for "Homemade / Cloud Kitchen" restaurants — cooked to
/// order, delivered next day. Reuses the shared [ShopCard] used by
/// [RestaurantsAllList].
class RestaurantsHomemadeList extends ConsumerWidget {
  const RestaurantsHomemadeList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(homemadeShopsProvider);

    return async.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (shops) {
        if (shops.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Homemade',
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
              'Cooked to order, delivered next day',
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
