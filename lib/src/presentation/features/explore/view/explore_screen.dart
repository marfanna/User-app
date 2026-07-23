import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';

/// Single source of truth for the Explore category grid.
/// A category is active when it has a non-null [route].
const List<CategoryItem> exploreCategories = [
  CategoryItem(
    title: 'Restaurants',
    description: 'Order from local restaurants',
    icon: Icons.restaurant_menu_outlined,
    route: Routes.restaurants,
  ),
  CategoryItem(
    title: 'Pharmacy',
    description: 'Medicines delivered fast',
    icon: Icons.local_pharmacy_outlined,
    route: Routes.medicine,
  ),
  CategoryItem(
    title: 'Grocery',
    description: 'Daily groceries & essentials',
    icon: Icons.local_grocery_store_outlined,
    route: Routes.mart,
  ),
  CategoryItem(
    title: 'Fashion',
    description: 'Shoes & clothing',
    icon: Icons.checkroom_outlined,
    route: Routes.fashion,
  ),
  CategoryItem(
    title: 'Gas Cylinder',
    description: '25kg LPG home delivery',
    icon: Icons.local_fire_department_outlined,
    isComingSoon: true,
  ),
  CategoryItem(
    title: 'Laundry',
    description: 'Wash & fold service',
    icon: Icons.local_laundry_service_outlined,
    route: Routes.laundry,
  ),
];

/// Routes of every active category. Drives the "skip the picker when only one
/// vertical is live" redirect on the home tab.
List<String> get activeCategoryRoutes => exploreCategories
    .where((c) => c.route != null)
    .map((c) => c.route!)
    .toList();

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = exploreCategories;
    final dims = context.dimensions;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: context.color.background.surface,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: context.color.background.surfaceGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  dims.padding.p24,
                  dims.padding.p20,
                  dims.padding.p24,
                  dims.padding.p0,
                ),
                child: Text(
                  'Explore Categories',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyle.displaySmallCompact.copyWith(
                    color: context.color.text.primary,
                    fontWeight: FontWeight.w700,
                    height: 1.08,
                    letterSpacing: 0,
                  ),
                ),
              ),
              Gap(dims.spacing.s16),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    dims.padding.p24,
                    dims.padding.p0,
                    dims.padding.p24,
                    dims.padding.p16 + 90 + bottomInset,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.02,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return _CategoryCard(item: categories[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryItem {
  const CategoryItem({
    required this.title,
    required this.description,
    required this.icon,
    this.route,
    this.isComingSoon = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? route;
  final bool isComingSoon;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;
    final isDisabled = item.isComingSoon;
    final titleColor = isDisabled
        ? context.color.text.secondary
        : context.color.text.primary;
    final iconColor = isDisabled
        ? context.color.icon.secondary
        : context.color.icon.primary;
    final radius = BorderRadius.circular(dims.radius.r16);

    final decoration = BoxDecoration(
      color: isDisabled
          ? context.color.background.surfaceContainerHigh.withValues(
              alpha: 0.72,
            )
          : context.color.background.surface,
      borderRadius: radius,
      border: Border.all(
        color: isDisabled
            ? context.color.border.disabled
            : context.color.brand.primary.withValues(alpha: 0.22),
      ),
      boxShadow: [
        if (!isDisabled)
          BoxShadow(
            color: context.color.elevation.elevationLow,
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
      ],
    );

    final content = Padding(
      padding: EdgeInsets.all(dims.padding.p16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: dims.size.s48,
                height: dims.size.s48,
                decoration: BoxDecoration(
                  color: isDisabled
                      ? context.color.background.surfaceContainerHigh
                      : context.color.background.surface,
                  borderRadius: BorderRadius.circular(dims.radius.r12),
                  border: Border.all(color: context.color.border.divider),
                ),
                child: Icon(item.icon, size: dims.size.s26, color: iconColor),
              ),
              const Spacer(),
              if (isDisabled)
                _ComingSoonBadge(
                  foreground: context.color.text.secondary,
                  background: context.color.background.surfaceContainerHigh,
                )
              else
                Container(
                  width: dims.size.s32,
                  height: dims.size.s32,
                  decoration: BoxDecoration(
                    color: context.color.background.surfaceContainerHigh,
                    shape: BoxShape.circle,
                    border: Border.all(color: context.color.border.divider),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: dims.size.s18,
                    color: context.color.icon.primary,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.titleMediumCompact.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
              Gap(dims.spacing.s4),
              Text(
                item.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textStyle.bodySmall.copyWith(
                  color: context.color.text.secondary,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isDisabled) {
      return Container(decoration: decoration, child: content);
    }

    return Material(
      color: context.color.background.transparent,
      child: InkWell(
        onTap: () => context.push(item.route!),
        borderRadius: radius,
        child: Ink(decoration: decoration, child: content),
      ),
    );
  }
}

class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge({required this.foreground, required this.background});

  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dims.padding.p8,
        vertical: dims.padding.p4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(dims.radius.r64),
        border: Border.all(color: context.color.border.disabled),
      ),
      child: Text(
        'Soon',
        style: context.textStyle.labelSmall.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
