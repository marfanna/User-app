import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';
import '../rounded_back_button.dart';

class OrderDetailsShimmer extends StatelessWidget {
  const OrderDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final shimmerBaseColor = context.color.background.surfaceVariant;
    final shimmerHighlightColor = context.color.background.surfaceVariant
        .withValues(alpha: 0.25);
    const shimmerPeriod = Duration(seconds: 3);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: const Center(child: RoundedBackButton.secondary()),
        centerTitle: false,
        titleSpacing: context.dimensions.padding.p16,
        title: Shimmer.fromColors(
          period: shimmerPeriod,
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
          child: Container(
            height: context.dimensions.size.s20,
            width: context.dimensions.size.s100,
            decoration: BoxDecoration(
              color: context.color.background.surface,
              borderRadius: BorderRadius.circular(context.dimensions.radius.r4),
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(context.dimensions.radius.r20),
            bottomRight: Radius.circular(context.dimensions.radius.r20),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Photo Placeholder Shimmer
              Shimmer.fromColors(
                period: shimmerPeriod,
                baseColor: shimmerBaseColor,
                highlightColor: shimmerHighlightColor,
                child: Container(
                  height: context.dimensions.size.s260,
                  width: double.infinity,
                  color: context.color.background.surface,
                ),
              ),
              Container(
                padding: EdgeInsets.all(context.dimensions.padding.p16),
                decoration: BoxDecoration(
                  color: context.color.background.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(context.dimensions.radius.r20),
                    topRight: Radius.circular(context.dimensions.radius.r20),
                  ),
                ),
                child: Shimmer.fromColors(
                  period: shimmerPeriod,
                  baseColor: shimmerBaseColor,
                  highlightColor: shimmerHighlightColor,
                  child: Column(
                    spacing: context.dimensions.spacing.s16,
                    children: [
                      // Restaurant Info Shimmer
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Box(
                            height: context.dimensions.size.s56,
                            width: context.dimensions.size.s56,
                            radius: context.dimensions.radius.r8,
                          ),
                          Gap(context.dimensions.spacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: context.dimensions.spacing.s8,
                              children: [
                                _Box(
                                  height: context.dimensions.size.s16,
                                  width: double.infinity,
                                ),
                                _Box(
                                  height: context.dimensions.size.s16,
                                  width: MediaQuery.sizeOf(context).width * 0.4,
                                ),
                              ],
                            ),
                          ),
                          Gap(context.dimensions.spacing.s12),
                          _Box(
                            height: context.dimensions.size.s56,
                            width: context.dimensions.size.s56,
                            radius: context.dimensions.radius.r8,
                          ),
                        ],
                      ),

                      // Customer Info Shimmer
                      Container(
                        padding: EdgeInsets.all(context.dimensions.padding.p10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: context.color.background.surface,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r10,
                          ),
                        ),
                        child: Column(
                          spacing: context.dimensions.spacing.s12,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      context.color.background.surface,
                                ),
                                Gap(context.dimensions.spacing.s12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: context.dimensions.spacing.s8,
                                    children: [
                                      _Box(
                                        height: context.dimensions.size.s16,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                            0.3,
                                      ),
                                      _Box(
                                        height: context.dimensions.size.s12,
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                            0.2,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      context.color.background.surface,
                                ),
                                Gap(context.dimensions.spacing.s12),
                                Expanded(
                                  child: _Box(
                                    height: context.dimensions.size.s16,
                                    width: double.infinity,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Items List Shimmer
                      Column(
                        spacing: context.dimensions.spacing.s10,
                        children: List.generate(
                          3,
                          (_) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _Box(
                                height: context.dimensions.size.s16,
                                width: MediaQuery.sizeOf(context).width * 0.4,
                              ),
                              _Box(
                                height: context.dimensions.size.s16,
                                width: context.dimensions.size.s60,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Divider(),

                      // Price Summary Shimmer
                      Column(
                        spacing: context.dimensions.spacing.s8,
                        children: List.generate(
                          4,
                          (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _Box(
                                height: context.dimensions.size.s14,
                                width: context.dimensions.size.s100,
                              ),
                              _Box(
                                height: context.dimensions.size.s14,
                                width: context.dimensions.size.s60,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _Box extends StatelessWidget {
  const _Box({required this.height, required this.width, this.radius});

  final double height;
  final double width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: context.color.background.surface,
        borderRadius: BorderRadius.circular(
          radius ?? context.dimensions.radius.r4,
        ),
      ),
    );
  }
}
