import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../../notifications/riverpod/notifications_provider.dart';

/// Medicine homepage header: category label + name (tap to switch vertical),
/// notification bell, and cart button — both with unread/count badges.
class MedicineHomeHeader extends ConsumerStatefulWidget {
  const MedicineHomeHeader({super.key});

  @override
  ConsumerState<MedicineHomeHeader> createState() => _MedicineHomeHeaderState();
}

class _MedicineHomeHeaderState extends ConsumerState<MedicineHomeHeader> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(notificationsProvider.notifier).fetch(),
    );
  }

  void _switchCategory() {
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    final cartCount = ref
        .watch(cartProvider)
        .fold<int>(0, (sum, c) => sum + c.quantity);
    final unreadCount = ref.watch(
      notificationsProvider.select((s) => s.unreadCount),
    );

    return SizedBox(
      width: double.infinity,
      height: dims.size.s56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _switchCategory,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Category',
                  style: text.bodySmallCompact.copyWith(
                    color: colors.text.primary,
                  ),
                ),
                Gap(dims.spacing.s6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Medicine', style: text.displaySmall),
                    Gap(dims.spacing.s4),
                    Icon(
                      Icons.expand_more,
                      color: colors.icon.primary,
                      size: dims.size.s24,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NotificationButton(unreadCount: unreadCount),
              Gap(dims.spacing.s16),
              _CartButton(cartCount: cartCount),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;

    return GestureDetector(
      onTap: () => context.push(Routes.notifications),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(
            Icons.notifications_outlined,
            color: colors.icon.primary,
            size: 28,
          ),
          if (unreadCount > 0)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.error.defaultValue,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: text.labelSmall.copyWith(
                    color: colors.text.inverse,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton({required this.cartCount});

  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: () => context.push(Routes.cart),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: dims.size.s56,
            height: dims.size.s56,
            decoration: BoxDecoration(
              color: colors.background.surface,
              borderRadius: BorderRadius.circular(dims.radius.r12),
            ),
            child: Center(
              child: Icon(
                Icons.shopping_bag_outlined,
                color: colors.icon.primary,
                size: dims.size.s24,
              ),
            ),
          ),
          if (cartCount > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: dims.size.s20,
                height: dims.size.s20,
                decoration: BoxDecoration(
                  color: colors.brand.secondary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  cartCount > 99 ? '99+' : '$cartCount',
                  style: text.labelSmall.copyWith(
                    color: colors.text.inverse,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
