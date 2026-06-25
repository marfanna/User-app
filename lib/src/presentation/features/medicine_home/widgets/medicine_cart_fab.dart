import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../cart/riverpod/cart_provider.dart';

/// Floating cart button shown on the full-screen medicine pages (storefront,
/// listing, product detail) — those sit outside the bottom-nav shell, so this
/// is the user's way back to the cart after adding. Hidden when cart is empty.
class MedicineCartFab extends ConsumerWidget {
  const MedicineCartFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    final count = ref
        .watch(cartProvider)
        .fold<int>(0, (sum, c) => sum + c.quantity);
    if (count == 0) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        right: dims.padding.p16,
        bottom: dims.padding.p16 + MediaQuery.of(context).padding.bottom,
      ),
      child: GestureDetector(
        onTap: () => context.push(Routes.cart),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: dims.size.s56,
              height: dims.size.s56,
              decoration: BoxDecoration(
                color: colors.brand.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.elevation.elevationMedium,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: colors.icon.inverse,
                size: dims.size.s24,
              ),
            ),
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: dims.size.s20,
                height: dims.size.s20,
                decoration: BoxDecoration(
                  color: colors.brand.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.icon.inverse, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: text.labelSmall.copyWith(
                    color: colors.icon.inverse,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
