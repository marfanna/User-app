import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/extensions/app_localization.dart';
import '../gen/assets.gen.dart';
import '../theme/theme.dart';
import 'gradient_background.dart';
import 'text/typography.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onTap(BuildContext context, int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // AppBar removed as per user request to integrate header into tab views
      extendBody: true,
      body: GradientBackground(child: widget.navigationShell),
      bottomNavigationBar: Container(
        margin: .fromLTRB(
          context.dimensions.padding.p16,
          context.dimensions.padding.p0,
          context.dimensions.padding.p16,
          context.dimensions.padding.p16,
        ),
        padding: .all(context.dimensions.padding.p6),
        decoration: BoxDecoration(
          color: context.color.background.surface,
          borderRadius: .circular(context.dimensions.radius.r64),
          boxShadow: [
            BoxShadow(
              color: context.color.elevation.elevationLow,
              blurRadius: 24,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: .max,
          mainAxisAlignment: .spaceBetween,
          children: [
            _NavBarItem(
              isSelected: widget.navigationShell.currentIndex == 0,
              iconGen: Assets.icons.home,
              label: context.locale.home,
              onTap: () => _onTap(context, 0),
            ),
            _NavBarItem(
              isSelected: widget.navigationShell.currentIndex == 1,
              iconGen: Assets.icons.order,
              label: context.locale.orders,
              onTap: () => _onTap(context, 1),
            ),
            _NavBarItem(
              isSelected: widget.navigationShell.currentIndex == 2,
              iconGen: Assets.icons.statistic,
              label: context.locale.leaderboard,
              onTap: () => _onTap(context, 2),
            ),
            _NavBarItem(
              isSelected: widget.navigationShell.currentIndex == 3,
              iconGen: Assets.icons.profile,
              label: context.locale.profile,
              onTap: () => _onTap(context, 3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  const _NavBarItem({
    required this.isSelected,
    required this.iconGen,
    required this.label,
    required this.onTap,
  });

  final bool isSelected;
  final SvgGenImage iconGen;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 300);

    final itemBackgroundColor = switch (isSelected) {
      true => context.color.background.surfaceContainerGradient,
      false => [
        context.color.background.surfaceContainerHigh,
        context.color.background.surfaceContainerHigh,
      ],
    };

    final ({Color selected, Color unselected}) iconColor = (
      selected: context.color.icon.inverse,
      unselected: context.color.icon.secondary,
    );

    return Expanded(
      flex: isSelected ? 2 : 1,
      child: GestureDetector(
        onTap: onTap,
        behavior: .opaque,
        child: AnimatedContainer(
          duration: duration,
          curve: Curves.easeOutCubic,
          padding: .symmetric(vertical: context.dimensions.padding.p16),
          decoration: BoxDecoration(
            borderRadius: .circular(context.dimensions.radius.r64),
            gradient: LinearGradient(
              colors: itemBackgroundColor,
              begin: .centerLeft,
              end: .centerRight,
            ),
          ),
          child: Row(
            mainAxisSize: .min,
            mainAxisAlignment: .center,
            children: [
              TweenAnimationBuilder<Color?>(
                tween: ColorTween(
                  begin: iconColor.unselected,
                  end: isSelected ? iconColor.selected : iconColor.unselected,
                ),
                duration: duration,
                builder: (context, color, child) {
                  return iconGen.svg(
                    width: context.dimensions.size.s24,
                    height: context.dimensions.size.s24,
                    colorFilter: .mode(color ?? iconColor.unselected, .srcIn),
                  );
                },
              ),
              Flexible(
                child: AnimatedSize(
                  duration: duration,
                  curve: Curves.easeOutCubic,
                  child: SizedBox(
                    height: context.dimensions.size.s24,
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        if (isSelected) ...[
                          SizedBox(width: context.dimensions.spacing.s8),
                          Flexible(
                            child: AnimatedOpacity(
                              opacity: isSelected ? 1.0 : 0.0,
                              duration: duration,
                              curve: Curves.easeOut,
                              child: LabelText.largeInverse(
                                label,
                                maxLines: 1,
                                softWrap: false,
                                overflow: .fade,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
