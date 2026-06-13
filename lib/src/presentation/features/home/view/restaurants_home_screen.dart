import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../orders/models/customer_order_model.dart';
import '../../orders/riverpod/order_review_provider.dart';
import '../../orders/view/order_review_dialog.dart';
import '../widgets/restaurants_home_header.dart';
import '../widgets/restaurants_search_bar.dart';
import '../widgets/restaurants_promotional_banner.dart';
import '../widgets/restaurants_trending_list.dart';
import '../widgets/restaurants_best_deals.dart';
import '../widgets/restaurants_category_list.dart';
import '../widgets/restaurants_all_list.dart';
import '../widgets/restaurants_sponsored_card.dart';

class RestaurantsHomeScreen extends ConsumerStatefulWidget {
  const RestaurantsHomeScreen({super.key});

  @override
  ConsumerState<RestaurantsHomeScreen> createState() =>
      _RestaurantsHomeScreenState();
}

class _RestaurantsHomeScreenState extends ConsumerState<RestaurantsHomeScreen> {
  bool _reviewDialogShown = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(orderReviewProvider.notifier).initialize(),
    );
  }

  void _showReviewDialog(CustomerOrderModel order) {
    if (_reviewDialogShown) return;
    _reviewDialogShown = true;
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: OrderReviewDialog(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<CustomerOrderModel?>(orderReviewProvider, (_, next) {
      if (next != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) { if (mounted) _showReviewDialog(next); },
        );
      }
    });
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
        child: const SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(16),
                RestaurantsHomeHeader(),
                Gap(24),
                RestaurantsSearchBar(),
                Gap(24),
                RestaurantsCategoryList(),
                Gap(24),
                RestaurantsPromotionalBanner(),
                Gap(24),
                RestaurantsBestDeals(),
                Gap(24),
                RestaurantsTrendingList(),
                Gap(24),
                RestaurantsSponsoredCard(),
                Gap(24),
                RestaurantsAllList(),
                Gap(100), // Space for bottom navigation bar
              ],
            ),
          ),
        ),
      ),
    );
  }
}
