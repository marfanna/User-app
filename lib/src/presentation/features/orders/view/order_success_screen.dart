import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/theme/src/theme_extensions/src/gradients.dart';
import '../../../core/widgets/button/primary_gradient_button.dart';
import '../../../core/router/routes.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const DuareAppBar(title: 'Success'),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildIllustration(),
                      const Gap(30),
                      const Text(
                        'Your Order\nHas Placed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 41,
                          height: 1.28,
                          letterSpacing: -1,
                          color: Color(0xFF040707),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return SizedBox(
      width: 260,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sparkles
          Positioned(
            top: 20,
            left: 70,
            child: _buildSparkle(size: 24, opacity: 0.4),
          ),
          Positioned(
            top: 30,
            right: 50,
            child: _buildSparkle(size: 16, opacity: 0.8),
          ),
          Positioned(
            top: 80,
            right: 80,
            child: _buildSparkle(size: 12, opacity: 0.6),
          ),
          Positioned(
            bottom: 40,
            right: 30,
            child: _buildSparkle(size: 32, opacity: 0.4),
          ),
          Positioned(
            bottom: 60,
            left: 40,
            child: _buildSparkle(size: 8, opacity: 0.8),
          ),
          Positioned(
            bottom: 80,
            left: 80,
            child: _buildSparkle(size: 14, opacity: 0.6),
          ),

          // Main circle
          Container(
            width: 99,
            height: 99,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppGradients.primaryRadial,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle({required double size, required double opacity}) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: 45 * math.pi / 180,
        child: Icon(
          Icons.star_rounded,
          color: const Color(0xFF0156A7),
          size: size,
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: PrimaryGradientButton(
        text: 'Track your Order',
        height: 56,
        borderRadius: 4,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        trailing: const Icon(
          Icons.trending_flat,
          color: Colors.white,
          size: 24,
        ),
        onPressed: () {
          context.pushNamed(
            Routes.trackOrder,
            pathParameters: {'id': orderId},
          );
        },
      ),
    );
  }
}
