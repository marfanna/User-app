import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';

/// Single source of truth for the Explore category grid.
/// A category is "active" (navigable) when it has a non-null [route].
/// Coming-soon / unrouted entries are shown but not navigable.
const List<CategoryItem> exploreCategories = [
  CategoryItem(
    title: 'Restaurants',
    description: 'Order from local restaurants',
    imagePath: 'assets/images/explore/restaurants.png',
    route: Routes.restaurants,
    tint: Color(0xFFFF9800),
  ),
  CategoryItem(
    title: 'Pharmacy',
    description: 'Medicines delivered fast',
    imagePath: 'assets/images/explore/medicine.png',
    route: Routes.medicine,
    tint: Color(0xFF0156A7),
  ),
  CategoryItem(
    title: 'Grocery',
    description: 'Daily groceries & essentials',
    imagePath: 'assets/images/explore/mart.png',
    route: Routes.mart,
    tint: Color(0xFF12B757),
  ),
  CategoryItem(
    title: 'Fashion',
    description: 'Shoes & clothing',
    imagePath: 'assets/images/explore/fashion.png',
    route: Routes.fashion,
    tint: Color(0xFF9C27B0),
    fallbackIcon: Icons.checkroom_outlined,
  ),
  CategoryItem(
    title: 'Gas Cylinder',
    description: '25kg LPG home delivery',
    imagePath: 'assets/images/explore/cylinder.png',
    tint: Color(0xFFE65100),
    isComingSoon: true,
  ),
  CategoryItem(
    title: 'Laundry',
    description: 'Wash & fold — coming soon',
    imagePath: 'assets/images/explore/laundry.png',
    tint: Color(0xFF29B6F6),
    isComingSoon: true,
  ),
];

/// Routes of every active (navigable) category. Drives the "skip the picker
/// when only one vertical is live" redirect on the home tab.
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

    return Scaffold(
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
          // This is a bottom-nav shell tab root (see shell_routes.dart), not
          // a pushed route — there is never anything to pop back to here, so
          // no back button.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(20),

              // Title — single line, no subtitle. This is a nav grid, not a
              // hero moment; the old two-line title + subtitle ate ~35% of
              // the screen before any category was visible.
              Text(
                'Explore Categories',
                textAlign: TextAlign.center,
                style: context.textStyle.titleLarge.copyWith(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: const Color(0xFF040707),
                ),
              ),

              const Gap(16),

              // Categories Grid — sized so all 6 tiles fit one screen
              // without scrolling on a typical device.
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    dims.padding.p16,
                    dims.padding.p0,
                    dims.padding.p16,
                    dims.padding.p16 +
                        90 +
                        MediaQuery.of(context).padding.bottom,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.15,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];
                    return _CategoryCard(item: item);
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
    required this.imagePath,
    required this.tint,
    this.route,
    this.isComingSoon = false,
    this.fallbackIcon = Icons.category_outlined,
  });

  final String title;
  final String description;
  final String imagePath;
  final String? route;
  final bool isComingSoon;

  /// Shown (tinted) when [imagePath] can't load — e.g. an asset not yet
  /// added. Keeps a missing tile looking intentional rather than broken.
  final IconData fallbackIcon;

  /// Soft category-tint used on the icon well and card border — gives
  /// repeat users a color cue to recognize a category faster than reading
  /// the label. Does not fix mismatched illustration art styles (cylinder
  /// is semi-3D, food is flat clipart, storefront is line art) — that
  /// needs new icon assets in one consistent style, not a code change.
  final Color tint;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final cardContent = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tinted icon well — equal size/padding for every category so
          // mismatched illustration styles read more like one system.
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.tint.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                item.imagePath,
                height: 30,
                width: 30,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Missing/not-yet-added asset (e.g. fashion.png): show a
                  // category-tinted icon so it reads as intentional, not
                  // a broken image.
                  return Icon(item.fallbackIcon, size: 26, color: item.tint);
                },
              ),
            ),
          ),
          const Gap(8),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textStyle.titleMediumCompact.copyWith(
              color: const Color(0xFF040707),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const Gap(2),
          Text(
            item.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              fontSize: 10.5,
              color: Color(0xFF737780),
            ),
          ),
        ],
      ),
    );

    final cardDecoration = BoxDecoration(
      color: item.tint.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: item.tint.withValues(alpha: 0.18)),
    );

    if (item.isComingSoon) {
      return Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: cardDecoration,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Opacity(opacity: 0.5, child: cardContent),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0950A3).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  'Coming Soon',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () => context.push(item.route!),
      child: Container(decoration: cardDecoration, child: cardContent),
    );
  }
}
