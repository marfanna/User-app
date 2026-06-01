import 'package:flutter/material.dart';

import '../../../core/extensions/app_localization.dart';
import '../theme/theme.dart';
import 'text/typography.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
  });

  final String message;
  final VoidCallback onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.dimensions.padding.p16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: context.dimensions.spacing.s12,
          children: [
            Icon(icon, size: 64, color: context.color.icon.secondary),
            BodyText.medium(message, textAlign: TextAlign.center),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(context.locale.retry),
            ),
          ],
        ),
      ),
    );
  }
}
