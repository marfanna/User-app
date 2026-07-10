import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../explore/view/explore_screen.dart';

/// Top-left vertical switcher: shows the current vertical ("Restaurants" /
/// "Medicine" …) under a small "Category" label, and — when 2+ verticals are
/// live — an anchored dropdown to jump between them.
///
/// Active verticals come from the single source of truth in [exploreCategories]
/// (a category is switchable when it has a non-null route). With only one
/// active vertical the chevron and menu are hidden (nothing to switch to).
class CategorySwitcher extends StatelessWidget {
  const CategorySwitcher({super.key, required this.currentRoute});

  /// Route of the vertical currently shown (e.g. Routes.restaurants).
  final String currentRoute;

  static const _labelColor = Color(0xFF040707);
  static const _accent = Color(0xFF036FFD);

  @override
  Widget build(BuildContext context) {
    final active =
        exploreCategories.where((c) => c.route != null).toList();
    final current = active.firstWhere(
      (c) => c.route == currentRoute,
      orElse: () => active.isNotEmpty
          ? active.first
          : const CategoryItem(title: 'Category', imagePath: ''),
    );
    final canSwitch = active.length > 1;

    final label = _Label(title: current.title, showChevron: canSwitch);

    if (!canSwitch) return label;

    return PopupMenuButton<String>(
      // Drop the menu just below the label.
      offset: const Offset(0, 52),
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      position: PopupMenuPosition.under,
      onSelected: (route) {
        if (route != currentRoute) context.go(route);
      },
      itemBuilder: (context) => [
        for (final c in active)
          PopupMenuItem<String>(
            value: c.route!,
            child: _MenuRow(
              item: c,
              isCurrent: c.route == currentRoute,
            ),
          ),
      ],
      child: label,
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.title, required this.showChevron});

  final String title;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.28,
            letterSpacing: -1,
            color: CategorySwitcher._labelColor,
          ),
        ),
        const Gap(6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                height: 1.28,
                letterSpacing: -1,
                color: CategorySwitcher._labelColor,
              ),
            ),
            if (showChevron) ...[
              const Gap(4),
              const Icon(
                Icons.expand_more,
                color: Color(0xFF1C1B1F),
                size: 24,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item, required this.isCurrent});

  final CategoryItem item;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          item.imagePath,
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.category_outlined,
            size: 24,
            color: isCurrent ? CategorySwitcher._accent : Colors.grey,
          ),
        ),
        const Gap(12),
        Text(
          item.title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
            fontSize: 16,
            color: isCurrent
                ? CategorySwitcher._accent
                : CategorySwitcher._labelColor,
          ),
        ),
        if (isCurrent) ...[
          const Gap(8),
          const Icon(Icons.check, size: 18, color: CategorySwitcher._accent),
        ],
      ],
    );
  }
}
