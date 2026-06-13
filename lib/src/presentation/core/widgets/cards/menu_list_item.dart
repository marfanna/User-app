import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../models/menu_item.dart';

class MenuListItem extends StatelessWidget {
  const MenuListItem({super.key, required this.item, required this.onAddTap});

  final MenuItem item;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: name, price, like/dislike
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(4),
                Text(
                  item.price,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(10),
                Row(
                  children: [
                    const Icon(
                      Icons.favorite_border_rounded,
                      size: 16,
                      color: Color(0xFF9EA3B0),
                    ),
                    const Gap(4),
                    Text(
                      '${item.likes}',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: Color(0xFF9EA3B0),
                      ),
                    ),
                    const Gap(12),
                    const Icon(
                      Icons.thumb_down_alt_outlined,
                      size: 16,
                      color: Color(0xFF9EA3B0),
                    ),
                    const Gap(4),
                    Text(
                      '${item.dislikes}',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: Color(0xFF9EA3B0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(16),
          // Right: image with + button
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  item.imageUrl,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 110,
                    height: 110,
                    color: const Color(0xFFF0F0F0),
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Color(0xFF040707),
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
