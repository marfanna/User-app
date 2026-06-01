import 'package:flutter/material.dart';
import 'package:duare_user/src/presentation/core/theme/src/theme_extensions/src/gradients.dart';

class PrimaryGradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? leading;
  final Widget? trailing;
  final MainAxisAlignment mainAxisAlignment;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const PrimaryGradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.leading,
    this.trailing,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.height = 48,
    this.borderRadius = 64,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryRadial,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
          ),
        ),
      ),
    );
  }
}
