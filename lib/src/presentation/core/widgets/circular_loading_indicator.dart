import 'package:flutter/material.dart';

class CircularLoadingIndicator extends StatelessWidget {
  const CircularLoadingIndicator({
    super.key,
    this.dimension = 20,
    this.strokeWidth = 2,
    this.color,
  });

  final double dimension;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: dimension,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );
  }
}
