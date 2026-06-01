import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../widgets/restaurants_home_header.dart';
import '../widgets/restaurants_search_bar.dart';
import '../widgets/restaurants_category_list.dart';
import '../widgets/restaurants_promotional_banner.dart';
import '../widgets/restaurants_trending_list.dart';
import '../widgets/restaurants_best_deals.dart';
import '../widgets/restaurants_all_list.dart';
import '../widgets/restaurants_sponsored_card.dart';

class RestaurantsHomeScreen extends ConsumerStatefulWidget {
  const RestaurantsHomeScreen({super.key});

  @override
  ConsumerState<RestaurantsHomeScreen> createState() =>
      _RestaurantsHomeScreenState();
}

class _RestaurantsHomeScreenState extends ConsumerState<RestaurantsHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background matching Figma
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x1A036FFD), // rgba(3, 111, 253, 0.1)
              Color(0x1AE8F2FF), // rgba(232, 242, 255, 0.1)
            ],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(16),
                const RestaurantsHomeHeader(),
                const Gap(24),
                const RestaurantsSearchBar(),
                const Gap(24),
                const RestaurantsCategoryList(),
                const Gap(24),
                const RestaurantsPromotionalBanner(),
                const Gap(24),
                const RestaurantsBestDeals(),
                const Gap(24),
                const RestaurantsTrendingList(),
                const Gap(24),
                const RestaurantsSponsoredCard(),
                const Gap(24),
                const RestaurantsAllList(),
                const Gap(100), // Space for bottom navigation bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}
