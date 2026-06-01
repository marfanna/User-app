import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RestaurantsCategoryList extends StatelessWidget {
  const RestaurantsCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'name': 'All',
        'image': 'https://cdn-icons-png.flaticon.com/512/3274/3274099.png',
      },
      {
        'name': 'Sweet',
        'image': 'https://cdn-icons-png.flaticon.com/512/2821/2821805.png',
      },
      {
        'name': 'Pizza',
        'image': 'https://cdn-icons-png.flaticon.com/512/3595/3595458.png',
      },
      {
        'name': 'Burger',
        'image': 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png',
      },
      {
        'name': 'Pizza',
        'image': 'https://cdn-icons-png.flaticon.com/512/3595/3595458.png',
      },
    ];

    return SizedBox(
      height: 87,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const Gap(11),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF4F4F6),
                    width: 0.62,
                  ),
                ),
                alignment: Alignment.center,
                child: Image.network(
                  category['image']!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.fastfood, color: Colors.grey),
                ),
              ),
              const Gap(5),
              Text(
                category['name']!,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.28,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
