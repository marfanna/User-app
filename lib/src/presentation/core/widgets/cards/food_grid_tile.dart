import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../models/menu_item.dart';

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: double.infinity,
      color: const Color(0xFFF5F5F5),
      child: const Icon(
        Icons.restaurant_outlined,
        size: 40,
        color: Color(0xFFCCCCCC),
      ),
    );
  }
}

class FoodGridTile extends StatelessWidget {
  const FoodGridTile({super.key, required this.item, required this.onAddTap});

  final MenuItem item;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) =>
                              const _ImagePlaceholder(),
                          loadingBuilder: (_, child, progress) =>
                              progress == null
                                  ? child
                                  : const _ImagePlaceholder(),
                        )
                      : const _ImagePlaceholder(),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onAddTap,
                    child: Container(
                      width: 28,
                      height: 28,
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF040707),
                    ),
                  ),
                  const Gap(2),
                  Text(
                    item.price,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF040707),
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 12,
                        color: Color(0xFF9EA3B0),
                      ),
                      const Gap(2),
                      Text(
                        '${item.likes}',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          color: Color(0xFF9EA3B0),
                        ),
                      ),
                      const Gap(8),
                      const Icon(
                        Icons.thumb_down_alt_outlined,
                        size: 12,
                        color: Color(0xFF9EA3B0),
                      ),
                      const Gap(2),
                      Text(
                        '${item.dislikes}',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          color: Color(0xFF9EA3B0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
