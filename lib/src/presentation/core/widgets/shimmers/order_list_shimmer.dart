import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/theme.dart';

class OrderListShimmer extends StatelessWidget {
  const OrderListShimmer({super.key, this.itemCount = 3})
    : isHorizontal = false;

  const OrderListShimmer.horizontal({super.key, this.itemCount = 3})
    : isHorizontal = true;

  final int itemCount;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Row(
          spacing: context.dimensions.spacing.s16,
          children: List.generate(itemCount, (_) => const _OrderCardShimmer()),
        ),
      );
    }

    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, _) => Padding(
        padding: EdgeInsets.only(bottom: context.dimensions.spacing.s16),
        child: const _OrderCardShimmer(),
      ),
    );
  }
}

class _OrderCardShimmer extends StatelessWidget {
  const _OrderCardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      padding: EdgeInsets.all(context.dimensions.padding.p10),
      decoration: BoxDecoration(
        color: context.color.background.surface,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
        boxShadow: [
          BoxShadow(
            color: context.color.elevation.elevationLow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        period: const Duration(seconds: 3),
        baseColor: context.color.background.surfaceVariant,
        highlightColor: context.color.background.surfaceVariant.withValues(
          alpha: 0.25,
        ),
        child: Column(
          spacing: context.dimensions.spacing.s12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant Info Shimmer
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.dimensions.size.s56,
                  width: context.dimensions.size.s56,
                  decoration: BoxDecoration(
                    color: context.color.background.surface,
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r8,
                    ),
                  ),
                ),
                Gap(context.dimensions.spacing.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: context.dimensions.size.s16,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: context.color.background.surface,
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r4,
                          ),
                        ),
                      ),
                      Gap(context.dimensions.spacing.s8),
                      Container(
                        height: context.dimensions.size.s16,
                        width: MediaQuery.sizeOf(context).width * 0.4,
                        decoration: BoxDecoration(
                          color: context.color.background.surface,
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(context.dimensions.spacing.s12),
                Container(
                  height: context.dimensions.size.s56,
                  width: context.dimensions.size.s56,
                  decoration: BoxDecoration(
                    color: context.color.background.surface,
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r8,
                    ),
                  ),
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
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: context.color.background.surface,
                      ),
                      Gap(context.dimensions.spacing.s12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: context.dimensions.size.s16,
                              width: MediaQuery.sizeOf(context).width * 0.3,
                              decoration: BoxDecoration(
                                color: context.color.background.surface,
                                borderRadius: BorderRadius.circular(
                                  context.dimensions.radius.r4,
                                ),
                              ),
                            ),
                            Gap(context.dimensions.spacing.s8),
                            Container(
                              height: context.dimensions.size.s12,
                              width: MediaQuery.sizeOf(context).width * 0.2,
                              decoration: BoxDecoration(
                                color: context.color.background.surface,
                                borderRadius: BorderRadius.circular(
                                  context.dimensions.radius.r4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: context.dimensions.size.s32,
                        width: context.dimensions.size.s64,
                        decoration: BoxDecoration(
                          color: context.color.background.surface,
                          borderRadius: BorderRadius.circular(
                            context.dimensions.radius.r30,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(context.dimensions.spacing.s12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: context.color.background.surface,
                      ),
                      Gap(context.dimensions.spacing.s12),
                      Expanded(
                        child: Container(
                          height: context.dimensions.size.s16,
                          decoration: BoxDecoration(
                            color: context.color.background.surface,
                            borderRadius: BorderRadius.circular(
                              context.dimensions.radius.r4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions Shimmer
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: context.dimensions.size.s48,
                    decoration: BoxDecoration(
                      color: context.color.background.surface,
                      borderRadius: BorderRadius.circular(
                        context.dimensions.radius.r24,
                      ),
                    ),
                  ),
                ),
                Gap(context.dimensions.spacing.s8),
                Container(
                  height: context.dimensions.size.s48,
                  width: context.dimensions.size.s100,
                  decoration: BoxDecoration(
                    color: context.color.background.surface,
                    borderRadius: BorderRadius.circular(
                      context.dimensions.radius.r24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
