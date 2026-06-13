import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../riverpod/categories_provider.dart';

class RestaurantsCategoryList extends ConsumerWidget {
  const RestaurantsCategoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) return const SizedBox.shrink();

        return SizedBox(
          height: 87,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: categories.length,
            separatorBuilder: (context, index) => const Gap(11),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category.value;

              return GestureDetector(
                onTap: () {
                  ref
                      .read(selectedCategoryProvider.notifier)
                      .select(category.value);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF036FFD).withValues(alpha: 0.1) : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? const Color(0xFF036FFD) : const Color(0xFFF4F4F6),
                          width: isSelected ? 2.0 : 0.62,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: category.icon != null && category.icon!.isNotEmpty
                          ? Image.network(
                              category.icon!,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.category, color: Colors.grey),
                            )
                          : Text(
                              category.label.isNotEmpty
                                  ? category.label[0].toUpperCase()
                                  : 'C',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? const Color(0xFF036FFD)
                                    : Colors.grey,
                              ),
                            ),
                    ),
                    const Gap(5),
                    Text(
                      category.label,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        fontSize: 14,
                        height: 1.28,
                        color: isSelected
                            ? const Color(0xFF036FFD)
                            : const Color(0xFF040707),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 87,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}
