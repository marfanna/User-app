import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../gen/assets.gen.dart';
import '../theme/theme.dart';

enum _BackButtonStyle { primary, secondary }

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton.primary({super.key, this.onPressed})
    : _style = .primary;

  const RoundedBackButton.secondary({super.key, this.onPressed})
    : _style = .secondary;

  final VoidCallback? onPressed;
  final _BackButtonStyle _style;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (_style) {
      .primary => context.color.background.surfaceContainer,
      .secondary => context.color.background.surfaceContainerHigh,
    };

    return InkWell(
      onTap: onPressed ?? () => context.pop(),
      borderRadius: .circular(context.dimensions.radius.r12),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: context.dimensions.size.s40,
          maxHeight: context.dimensions.size.s40,
        ),
        padding: .all(context.dimensions.padding.p8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: .circular(context.dimensions.radius.r12),
        ),
        child: Assets.icons.leftArrow.svg(
          width: context.dimensions.size.s24,
          height: context.dimensions.size.s24,
          colorFilter: .mode(context.color.icon.primary, .srcIn),
        ),
      ),
    );
  }
}
