import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:duare_user/src/presentation/core/widgets/rounded_back_button.dart';

class DuareAppBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final VoidCallback? onBackPressed;

  const DuareAppBar({
    super.key,
    required this.title,
    this.trailing,
    this.onBackPressed,
  });

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
                RoundedBackButton.primary(
                  onPressed:
                      onBackPressed ??
                      () {
                        if (context.canPop()) context.pop();
                      },
                ),
                const Gap(16),
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
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
