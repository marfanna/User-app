import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Auto-playing promotional banner carousel for medicine offers.
///
/// Placeholder pharmacy imagery for now; swap [_bannerImages] for a banners
/// provider when the offers endpoint is wired.
class MedicinePromotionalBanner extends StatefulWidget {
  const MedicinePromotionalBanner({super.key});

  @override
  State<MedicinePromotionalBanner> createState() =>
      _MedicinePromotionalBannerState();
}

class _MedicinePromotionalBannerState extends State<MedicinePromotionalBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _autoPlayTimer;

  final List<String> _bannerImages = [
    'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=1200&h=400&fit=crop',
    'https://images.unsplash.com/photo-1587854692152-cbe660dbde88?w=1200&h=400&fit=crop',
    'https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=1200&h=400&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _bannerImages.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return SizedBox(
      width: double.infinity,
      height: 160,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(dims.radius.r12),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _bannerImages.length,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index),
              itemBuilder: (context, index) {
                return Image.network(
                  _bannerImages[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  cacheWidth: 1000,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: colors.background.surfaceContainerHighDim,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.brand.secondary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: colors.background.surfaceContainerHighDim,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      color: colors.icon.secondary,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_bannerImages.length, (index) {
                final isActive = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: isActive ? 20 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? colors.icon.inverse
                        : colors.icon.inverse.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(dims.radius.r10),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(dims.radius.r12),
                bottomRight: Radius.circular(dims.radius.r12),
              ),
              child: TweenAnimationBuilder<double>(
                key: ValueKey(_currentPage),
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(seconds: 5),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor:
                        colors.icon.inverse.withValues(alpha: 0.2),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(colors.icon.inverse),
                    minHeight: 3,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
