import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../models/medicine_listing_args.dart';
import '../riverpod/medicine_listing_provider.dart';
import '../widgets/medicine_cart_fab.dart';
import '../widgets/medicine_product_grid_tile.dart';

/// Cross-pharmacy listing of medicines in one category. Reached by tapping a
/// category tile on the homepage grid or the full categories screen.
class MedicineListingScreen extends ConsumerWidget {
  const MedicineListingScreen({super.key, required this.args});

  final MedicineListingArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.textStyle;
    final dims = context.dimensions;
    final async = ref.watch(medicineListingProvider(args.categoryLabel));

    return Scaffold(
      floatingActionButton: const MedicineCartFab(),
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  dims.padding.p16,
                  dims.padding.p16,
                  dims.padding.p16,
                  dims.padding.p8,
                ),
                child: Row(
                  children: [
                    const RoundedBackButton.secondary(),
                    Gap(dims.spacing.s12),
                    Expanded(
                      child: Text(
                        args.categoryLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: async.when(
                  loading: () => const _GridSkeleton(),
                  error: (_, _) =>
                      const _Message(text: "Couldn't load medicines"),
                  data: (items) {
                    if (items.isEmpty) {
                      return const _Message(
                        text: 'No medicines in this category yet',
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                        dims.padding.p16,
                        dims.padding.p8,
                        dims.padding.p16,
                        dims.spacing.s32,
                      ),
                      itemCount: items.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: dims.spacing.s12,
                            crossAxisSpacing: dims.spacing.s12,
                            childAspectRatio: 0.62,
                          ),
                      itemBuilder: (_, i) => MedicineProductGridTile(
                        product: items[i].product,
                        shopName: items[i].shopName,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.medication_outlined,
            size: dims.size.s48,
            color: colors.icon.secondary,
          ),
          Gap(dims.spacing.s12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: context.textStyle.bodyMedium.copyWith(
              color: colors.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        dims.padding.p16,
        dims.padding.p8,
        dims.padding.p16,
        dims.spacing.s32,
      ),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: dims.spacing.s12,
        crossAxisSpacing: dims.spacing.s12,
        childAspectRatio: 0.62,
      ),
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r12),
        ),
        padding: EdgeInsets.all(dims.padding.p10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.background.surfaceContainerHighDim,
                  borderRadius: BorderRadius.circular(dims.radius.r8),
                ),
              ),
            ),
            Gap(dims.spacing.s8),
            Container(
              width: 110,
              height: 14,
              color: colors.background.surfaceContainerHighDim,
            ),
            Gap(dims.spacing.s8),
            Container(
              width: 60,
              height: 14,
              color: colors.background.surfaceContainerHighDim,
            ),
          ],
        ),
      ),
    );
  }
}
