import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../add_food/view/add_food_screen.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import '../riverpod/favourites_provider.dart';

class FavouritesScreen extends ConsumerWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 56,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: Material(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Color(0xFF1C1B1F),
                  ),
                ),
              ),
            ),
          ),
        ),
        titleSpacing: 16,
        title: const Text(
          'My Favourite',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF040707),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x1A036FFD), // rgba(3, 111, 253, 0.1)
              Color(0x1AE8F2FF), // rgba(232, 242, 255, 0.1)
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: ref.watch(favouriteProductsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => _ErrorView(
            onRetry: () => ref.invalidate(favouriteProductsProvider),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const _EmptyView(
                message: 'No favourite products yet',
                subMessage: 'Tap the heart icon on any product to save it here',
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
              ),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final record = list[i];
                return FavouriteProductCard(
                  item: record.item,
                  shopName: record.shopName,
                  onTap: () {
                    context.push(
                      Routes.addFood,
                      extra: AddFoodArgs(
                        item: record.item,
                        shopName: record.shopName,
                        shopId: record.shopId,
                      ),
                    );
                  },
                  onAddTap: () {
                    context.push(
                      Routes.addFood,
                      extra: AddFoodArgs(
                        item: record.item,
                        shopName: record.shopName,
                        shopId: record.shopId,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class FavouriteProductCard extends StatelessWidget {
  const FavouriteProductCard({
    super.key,
    required this.item,
    required this.shopName,
    required this.onTap,
    required this.onAddTap,
  });

  final ApiMenuItemData item;
  final String shopName;
  final VoidCallback onTap;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                  child: item.image != null && item.image!.isNotEmpty
                      ? Image.network(
                          item.image!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              const _PlaceholderImage(height: 120),
                        )
                      : const _PlaceholderImage(height: 120),
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
                    shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFF737780),
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '৳${item.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF040707),
                    ),
                  ),
                  const Gap(6),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 12,
                        color: Color(0xFF9EA3B0),
                      ),
                      const Gap(2),
                      Text(
                        '${item.likeCount}',
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
                        '${item.dislikeCount}',
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

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage({this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child: Icon(
          Icons.fastfood_rounded,
          color: Color(0xFFD1D5DB),
          size: 36,
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message, required this.subMessage});

  final String message;
  final String subMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 64, color: Color(0xFFCCCCCC)),
          const Gap(16),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF737780),
            ),
          ),
          const Gap(8),
          Text(
            subMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: Color(0xFF9EA3AD),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Color(0xFFCCCCCC),
          ),
          const Gap(12),
          const Text(
            'Failed to load favourites',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Color(0xFF737780),
            ),
          ),
          const Gap(16),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
