import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/rounded_back_button.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Categories list matching the Figma grid design
    final categories = [
      const _CategoryItem(
        title: 'Restaurants',
        imagePath: 'assets/images/explore/restaurants.png',
        route: Routes.restaurants,
      ),
      const _CategoryItem(
        title: 'Cylinder',
        imagePath: 'assets/images/explore/cylinder.png',
      ),
      const _CategoryItem(
        title: 'Medicine',
        imagePath: 'assets/images/explore/medicine.png',
      ),
      const _CategoryItem(title: 'Mart', imagePath: 'assets/images/explore/mart.png'),
      const _CategoryItem(
        title: 'Laundry',
        imagePath: 'assets/images/explore/laundry.png',
      ),
      const _CategoryItem(
        title: 'Laundry',
        imagePath: 'assets/images/explore/laundry.png',
        isComingSoon: true,
      ),
    ];

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top AppBar section with custom back button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.dimensions.padding.p16,
                  vertical: context.dimensions.padding.p8,
                ),
                child: RoundedBackButton.primary(
                  onPressed: () {
                    // Go back if we can, otherwise do nothing
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                ),
              ),

              const Gap(16),

              // Title and Subtitle Text Content
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'Explore a\nCategory Now',
                      textAlign: TextAlign.center,
                      style: context.textStyle.displayMedium.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                        fontSize: 32,
                        height: 1.28,
                        color: const Color(0xFF040707),
                      ),
                    ),
                    const Gap(8),
                    Text(
                      'Please select A Category that you\nwant to explore',
                      textAlign: TextAlign.center,
                      style: context.textStyle.bodyMedium.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1.50,
                        color: const Color(0xFF040707),
                      ),
                    ),
                  ],
                ),
              ),

              const Gap(28),

              // Categories Grid
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    context.dimensions.padding.p16,
                    context.dimensions.padding.p0,
                    context.dimensions.padding.p16,
                    context.dimensions.padding.p16 +
                        100, // Account for Bottom Nav Bar offset
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 163.5 / 158,
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

class _CategoryItem {
  const _CategoryItem({
    required this.title,
    required this.imagePath,
    this.route,
    this.isComingSoon = false,
  });

  final String title;
  final String imagePath;
  final String? route;
  final bool isComingSoon;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final _CategoryItem item;

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Centered illustration
        Image.asset(
          item.imagePath,
          height: 64,
          width: 83.32,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback placeholder in case asset isn't ready
            return const Icon(Icons.broken_image, size: 64);
          },
        ),
        const Gap(16),
        // Title Text
        Text(
          item.title,
          style: context.textStyle.titleMediumCompact.copyWith(
            color: const Color(0xFF040707),
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
    );

    // Custom borders matching Figma: border-width: 0px 2px 2px 1px
    final cardDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(4),
      border: Border(
        top: BorderSide.none,
        left: BorderSide(
          color: const Color(0xFF0156A7).withValues(alpha: 0.2),
          width: 1,
        ),
        right: BorderSide(
          color: const Color(0xFF0156A7).withValues(alpha: 0.2),
          width: 2,
        ),
        bottom: BorderSide(
          color: const Color(0xFF0156A7).withValues(alpha: 0.2),
          width: 2,
        ),
      ),
    );

    if (item.isComingSoon) {
      return Stack(
        children: [
          // Blurred background card content
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: cardDecoration,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Opacity(opacity: 0.5, child: cardContent),
            ),
          ),
          // Dark overlays & "Coming Soon" tag
          Container(
            decoration: BoxDecoration(
              color: const Color(
                0xFF0950A3,
              ).withValues(alpha: 0.5), // Color Scheme/Brand dark blue opacity
              borderRadius: BorderRadius.circular(4),
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
      onTap: () {
        if (item.route != null) {
          context.push(item.route!);
        } else {
          // Display Toast or SnackBar for "Coming Soon" features
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.title} category is coming soon!'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: context.color.brand.primary,
            ),
          );
        }
      },
      child: Container(decoration: cardDecoration, child: cardContent),
    );
  }
}
