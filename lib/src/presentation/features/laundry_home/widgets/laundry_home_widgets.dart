import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../cart/riverpod/cart_provider.dart';
import 'laundry_service_card.dart';

/// In-page item search (filters the list as you type). Styled like the
/// shared `MedicineSearchBar` pill so it reads as the same component.
class LaundrySearchField extends StatelessWidget {
  const LaundrySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Container(
      height: dims.size.s48,
      padding: EdgeInsets.symmetric(horizontal: dims.padding.p20),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r64),
        boxShadow: [
          BoxShadow(
            color: colors.elevation.elevationLow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: colors.icon.secondary, size: dims.size.s20),
          Gap(dims.spacing.s10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              style: text.bodySmallCompactLoose.copyWith(
                color: colors.text.primary,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                hintText: 'Search items (Shirt, শাড়ী..)',
                hintStyle: text.bodySmallCompactLoose.copyWith(
                  color: colors.text.secondary,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () {
                  controller.clear();
                  onChanged('');
                },
                child: Icon(
                  Icons.close_rounded,
                  color: colors.icon.secondary,
                  size: dims.size.s20,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// What the customer gets, in one calm card (Angi-style promise list).
class LaundryPromiseCard extends StatelessWidget {
  const LaundryPromiseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dims.padding.p16),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r12),
        boxShadow: [
          BoxShadow(
            color: colors.elevation.elevationLow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Expanded(
            child: _Promise(
              icon: Icons.two_wheeler_outlined,
              title: 'Door pickup',
              subtitle: 'ASAP rider',
            ),
          ),
          _divider(context),
          const Expanded(
            child: _Promise(
              icon: Icons.sell_outlined,
              title: 'Fixed price',
              subtitle: 'Per item',
            ),
          ),
          _divider(context),
          const Expanded(
            child: _Promise(
              icon: Icons.event_available_outlined,
              title: 'Back home',
              subtitle: 'In 7–14 days',
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) => Container(
    width: 1,
    height: context.dimensions.size.s40,
    margin: EdgeInsets.symmetric(horizontal: context.dimensions.padding.p8),
    color: context.color.border.divider,
  );
}

class _Promise extends StatelessWidget {
  const _Promise({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Column(
      children: [
        Icon(icon, color: colors.brand.primary, size: dims.size.s24),
        Gap(dims.spacing.s6),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.labelLarge,
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.labelSmall.copyWith(color: colors.text.secondary),
        ),
      ],
    );
  }
}

/// Careem-style category tiles. Tapping jumps to that section.
class LaundryCategoryTiles extends StatelessWidget {
  const LaundryCategoryTiles({
    super.key,
    required this.categories,
    required this.counts,
    required this.onTap,
  });

  final List<String> categories;
  final Map<String, int> counts;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: dims.spacing.s12,
        crossAxisSpacing: dims.spacing.s12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (_, index) {
        final category = categories[index];
        return _CategoryTile(
          category: category,
          count: counts[category] ?? 0,
          onTap: () => onTap(category),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.count,
    required this.onTap,
  });

  final String category;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(dims.padding.p8),
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r12),
          boxShadow: [
            BoxShadow(
              color: colors.elevation.elevationLow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LaundryThumb(
              size: dims.size.s48,
              image: laundryCategoryImage(category),
              category: category,
            ),
            Gap(dims.spacing.s6),
            Text(
              laundryShortCategory(category),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: text.labelMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              '$count items',
              maxLines: 1,
              style: text.labelSmall.copyWith(color: colors.text.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pinned category tab bar (Keeta pattern). Highlights the section in view.
class LaundryCategoryTabsDelegate extends SliverPersistentHeaderDelegate {
  LaundryCategoryTabsDelegate({
    required this.categories,
    required this.active,
    required this.onTap,
    required this.height,
    required this.background,
    required this.tabKeys,
  });

  /// Keys per tab so the screen can scroll the active tab into view.
  final Map<String, GlobalKey> tabKeys;
  final List<String> categories;
  final String? active;
  final ValueChanged<String> onTap;
  final double height;
  final Color background;

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlaps) {
    final dims = context.dimensions;

    return Container(
      color: background,
      alignment: Alignment.centerLeft,
      // All tabs built (only a handful) so the active one can always be
      // scrolled into view, even when it starts off-screen.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
        child: Row(
          spacing: dims.spacing.s8,
          children: [
            for (final category in categories)
              _tab(context, category, category == active),
          ],
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, String category, bool selected) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    return Center(
      key: tabKeys.putIfAbsent(category, GlobalKey.new),
      child: GestureDetector(
        onTap: () => onTap(category),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.symmetric(
            horizontal: dims.padding.p16,
            vertical: dims.padding.p8,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.brand.primary : colors.background.surface,
            borderRadius: BorderRadius.circular(dims.radius.r64),
            border: Border.all(
              color: selected ? colors.brand.primary : colors.border.divider,
            ),
          ),
          child: Text(
            category,
            style: text.labelMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: selected ? colors.text.inverse : colors.text.primary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant LaundryCategoryTabsDelegate old) =>
      old.active != active ||
      old.categories != categories ||
      old.background != background;
}

/// Fixed cart summary at the bottom (Keeta / Urban Company pattern).
/// Hidden while the cart is empty.
class LaundryCartBar extends ConsumerWidget {
  const LaundryCartBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final cart = ref.watch(cartProvider);
    if (cart.isEmpty) return const SizedBox.shrink();

    final count = cart.fold<int>(0, (sum, c) => sum + c.quantity);
    final total = cart.fold<double>(0, (sum, c) => sum + c.totalPrice);
    final itemsLabel = '$count item${count == 1 ? '' : 's'}';
    final summary = '$itemsLabel · ৳${total.toStringAsFixed(0)}';

    return Container(
      padding: EdgeInsets.fromLTRB(
        dims.padding.p16,
        dims.padding.p12,
        dims.padding.p16,
        dims.padding.p12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.background.surface,
        boxShadow: [
          BoxShadow(
            color: colors.elevation.elevationLow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => context.push(Routes.cart),
        child: Container(
          height: dims.size.s56,
          padding: EdgeInsets.symmetric(horizontal: dims.padding.p20),
          decoration: BoxDecoration(
            color: colors.brand.primary,
            borderRadius: BorderRadius.circular(dims.radius.r64),
          ),
          child: Row(
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                color: colors.icon.inverse,
                size: dims.size.s22,
              ),
              Gap(dims.spacing.s10),
              Expanded(
                child: Text(
                  summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: text.titleSmall.copyWith(color: colors.text.inverse),
                ),
              ),
              Text(
                'View cart',
                style: text.labelLarge.copyWith(color: colors.text.inverse),
              ),
              Gap(dims.spacing.s4),
              Icon(
                Icons.arrow_forward_rounded,
                color: colors.icon.inverse,
                size: dims.size.s20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
