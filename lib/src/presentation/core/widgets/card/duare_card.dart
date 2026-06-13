import 'package:flutter/material.dart';

class DuareCard extends StatelessWidget {

  const DuareCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 10,
    this.backgroundColor = Colors.white,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(90, 108, 234, 0.07),
            blurRadius: 52,
            offset: Offset(12.48, 27.04),
          ),
        ],
      ),
      child: child,
    );
  }
}
