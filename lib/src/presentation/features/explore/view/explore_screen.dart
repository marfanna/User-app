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
    imagePath: 'assets/images/explore/Restaurants.webp',
    route: Routes.restaurants,
  ),
  CategoryItem(
    title: 'Pharmacy',
    description: 'Medicines delivered fast',
    icon: Icons.local_pharmacy_outlined,
    imagePath: 'assets/images/explore/Pharmacy.webp',
    route: Routes.medicine,
  ),
  CategoryItem(
    title: 'Grocery',
    description: 'Daily groceries & essentials',
    icon: Icons.local_grocery_store_outlined,
    imagePath: 'assets/images/explore/Mart.webp',
    route: Routes.mart,
  ),
  CategoryItem(
    title: 'Fashion',
    description: 'Shoes & clothing',
    icon: Icons.checkroom_outlined,
    imagePath: 'assets/images/explore/Fashion.webp',
    route: Routes.fashion,
  ),
  CategoryItem(
    title: 'Gas Cylinder',
    description: '25kg LPG home delivery',
    icon: Icons.local_fire_department_outlined,
    imagePath: 'assets/images/explore/Gas Cylinder.webp',
    isComingSoon: true,
  ),
  CategoryItem(
    title: 'Laundry',
    description: 'Wash & fold service',
    icon: Icons.local_laundry_service_outlined,
    imagePath: 'assets/images/explore/Laundry.webp',
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
      backgroundColor: context.color.background.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                dims.padding.p24,
                dims.padding.p24,
                dims.padding.p24,
                dims.padding.p0,
              ),
              child: Text(
                'What you want\nto shop?',
                style: context.textStyle.displaySmallCompact.copyWith(
                  color: context.color.text.primary,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Gap(dims.spacing.s32),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.fromLTRB(
                  dims.padding.p16,
                  dims.padding.p0,
                  dims.padding.p16,
                  dims.padding.p16 + 90 + bottomInset,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 28,
                  childAspectRatio: 0.82,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _CategoryTile(item: categories[index]);
                },
              ),
            ),
          ],
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
    this.imagePath,
    this.route,
    this.isComingSoon = false,
  });

  final String title;
  final String description;

  /// Material-icon fallback shown when [imagePath] is missing or fails to load.
  final IconData icon;

  /// 3D product illustration (transparent PNG). Optional — falls back to
  /// [icon] so a missing asset never looks broken.
  final String? imagePath;

  final String? route;
  final bool isComingSoon;
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;
    final isDisabled = item.isComingSoon;

    final iconWidget = Icon(
      item.icon,
      size: dims.size.s48,
      color: context.color.icon.secondary,
    );

    final illustration = SizedBox(
      height: dims.size.s64,
      child: item.imagePath != null
          ? Image.asset(
              item.imagePath!,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => Center(child: iconWidget),
            )
          : Center(child: iconWidget),
    );

    final tile = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Dim the whole illustration for coming-soon categories.
        Opacity(opacity: isDisabled ? 0.45 : 1, child: illustration),
        Gap(dims.spacing.s10),
        Text(
          item.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textStyle.titleSmall.copyWith(
            color: isDisabled
                ? context.color.text.secondary
                : context.color.text.primary,
            fontWeight: FontWeight.w600,
            height: 1.15,
          ),
        ),
        if (isDisabled) ...[
          Gap(dims.spacing.s2),
          Text(
            'Coming soon',
            textAlign: TextAlign.center,
            style: context.textStyle.labelSmall.copyWith(
              color: context.color.text.secondary,
            ),
          ),
        ],
      ],
    );

    if (isDisabled || item.route == null) {
      return tile;
    }

    return InkWell(
      onTap: () => context.push(item.route!),
      borderRadius: BorderRadius.circular(dims.radius.r16),
      child: tile,
    );
  }
}
