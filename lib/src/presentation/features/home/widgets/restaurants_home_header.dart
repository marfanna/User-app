import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../../notifications/riverpod/notifications_provider.dart';

class RestaurantsHomeHeader extends ConsumerStatefulWidget {
  const RestaurantsHomeHeader({super.key});

  @override
  ConsumerState<RestaurantsHomeHeader> createState() =>
      _RestaurantsHomeHeaderState();
}

class _RestaurantsHomeHeaderState extends ConsumerState<RestaurantsHomeHeader> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(notificationsProvider.notifier).fetch(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref
        .watch(cartProvider)
        .fold<int>(0, (sum, c) => sum + c.quantity);
    final unreadCount = ref.watch(
      notificationsProvider.select((s) => s.unreadCount),
    );

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text block
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Category',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.28,
                  letterSpacing: -1,
                  color: Color(0xFF040707),
                ),
              ),
              Gap(6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Restaurants',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 1.28,
                      letterSpacing: -1,
                      color: Color(0xFF040707),
                    ),
                  ),
                  Gap(4),
                  Icon(Icons.expand_more, color: Color(0xFF1C1B1F), size: 24),
                ],
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notification icon with badge
              GestureDetector(
                onTap: () => context.push(Routes.notifications),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(
                      Icons.notifications_outlined,
                      color: Color(0xFF1C1C1C),
                      size: 28,
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Gap(16),

              // Cart button with badge
              GestureDetector(
                onTap: () => context.push(Routes.cart),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          color: Color(0xFF1C1C1C),
                          size: 24,
                        ),
                      ),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0156A7),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            cartCount > 99 ? '99+' : '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
