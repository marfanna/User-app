import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

class ProfileTabShimmer extends StatelessWidget {
  const ProfileTabShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerBaseColor = context.color.background.surfaceVariant;
    final shimmerHighlightColor = context.color.background.surfaceVariant
        .withValues(alpha: 0.25);
    const shimmerPeriod = Duration(seconds: 3);

    return Shimmer.fromColors(
      period: shimmerPeriod,
      baseColor: shimmerBaseColor,
      highlightColor: shimmerHighlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.dimensions.spacing.s16,
        children: [
          // Profile Header Shimmer
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(context.dimensions.spacing.s16),
              CircleAvatar(
                radius: context.dimensions.size.s100 / 2,
                backgroundColor: context.color.background.surface,
              ),
              Gap(context.dimensions.spacing.s12),
              _Box(
                height: context.dimensions.size.s20,
                width: MediaQuery.sizeOf(context).width * 0.45,
              ),
              Gap(context.dimensions.spacing.s4),
              _Box(
                height: context.dimensions.size.s16,
                width: MediaQuery.sizeOf(context).width * 0.3,
              ),
            ],
          ),

          // Order Stats Row Shimmer
          Row(
            spacing: context.dimensions.spacing.s16,
            children: [const _StatCardShimmer(), const _StatCardShimmer()],
          ),
        ],
      ),
    );
  }
}

class _StatCardShimmer extends StatelessWidget {
  const _StatCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(context.dimensions.padding.p16),
        decoration: BoxDecoration(
          color: context.color.background.surface,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: context.dimensions.spacing.s4,
          children: [
            _Box(
              height: context.dimensions.size.s20,
              width: context.dimensions.size.s64,
            ),
            _Box(
              height: context.dimensions.size.s14,
              width: MediaQuery.sizeOf(context).width * 0.2,
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: context.color.background.surface,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
      ),
    );
  }
}
