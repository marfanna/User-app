import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../rounded_back_button.dart';

class DuareAppBar extends StatelessWidget {
  const DuareAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.onBackPressed,
    this.showBackButton = true,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback? onBackPressed;

  /// Set to false on bottom-tab root screens (Profile, etc.) — there's
  /// nothing to pop back to there, so the button would be a dead tap.
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (showBackButton) ...[
                  RoundedBackButton.primary(
                    onPressed:
                        onBackPressed ??
                        () {
                          if (context.canPop()) context.pop();
                        },
                  ),
                  const Gap(16),
                ],
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      letterSpacing: -0.5,
                      color: Color(0xFF040707),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
