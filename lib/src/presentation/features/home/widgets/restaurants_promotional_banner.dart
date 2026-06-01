import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RestaurantsPromotionalBanner extends StatefulWidget {
  const RestaurantsPromotionalBanner({super.key});

  @override
  State<RestaurantsPromotionalBanner> createState() =>
      _RestaurantsPromotionalBannerState();
}

class _RestaurantsPromotionalBannerState
    extends State<RestaurantsPromotionalBanner> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of banner data for future dynamic usage
    final banners = [
      {
        'title': 'Special Offer\nfor March',
        'subtitle': 'We are here with the Best Burgers in town.',
        'image':
            'https://png.pngtree.com/png-clipart/20230427/original/pngtree-food-burger-png-image_9115006.png',
        'gradient': [const Color(0xFF004422), const Color(0xFFD9FFEC)],
      },
      {
        'title': 'Free Delivery\nToday!',
        'subtitle': 'Order now and get free delivery on all items.',
        'image':
            'https://png.pngtree.com/png-clipart/20230427/original/pngtree-food-burger-png-image_9115006.png', // Placeholder
        'gradient': [const Color(0xFF5A1E96), const Color(0xFFE4D5F9)],
      },
      {
        'title': 'Weekend\nFiesta',
        'subtitle': 'Get 20% off on all pizzas this weekend.',
        'image':
            'https://png.pngtree.com/png-clipart/20230427/original/pngtree-food-burger-png-image_9115006.png', // Placeholder
        'gradient': [const Color(0xFF961E1E), const Color(0xFFF9D5D5)],
      },
    ];

    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = banners[index];
              return GestureDetector(
                onTap: () {
                  // TODO: Handle click in the future
                  debugPrint('Banner $index clicked');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: const Alignment(-1.0, -0.4),
                      end: const Alignment(1.0, 0.4),
                      colors: banner['gradient'] as List<Color>,
                      stops: const [0.0, 1.0],
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Background Image
                      Positioned(
                        left: 113.72,
                        top: -10,
                        bottom: -10,
                        right: -20,
                        child: Image.network(
                          banner['image'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                      // Text Content
                      Positioned(
                        left: 25,
                        top: 18,
                        child: SizedBox(
                          width: 140,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner['title'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  height: 1.03,
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(6),
                              Text(
                                banner['subtitle'] as String,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  height: 1.27,
                                  color: Colors.white,
                                ),
                              ),
                              const Gap(13),
                              Container(
                                width: 81,
                                height: 27,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5.01),
                                ),
                                child: const Text(
                                  'Buy Now',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    height: 0.77,
                                    color: Color(0xFF040707),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Smooth Minimal Indicators
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                final isActive = _currentPage == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 5,
                  width: isActive ? 18 : 5,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
