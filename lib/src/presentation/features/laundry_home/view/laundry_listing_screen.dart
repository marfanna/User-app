import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../medicine_home/widgets/medicine_cart_fab.dart';
import '../models/laundry_listing_args.dart';
import '../riverpod/laundry_provider.dart';
import '../widgets/laundry_service_card.dart';

class LaundryListingScreen extends ConsumerWidget {
  const LaundryListingScreen({super.key, required this.args});

  final LaundryListingArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.textStyle;
    final dims = context.dimensions;
    final async = ref.watch(laundryListingProvider(args.categoryLabel));

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
                  loading: () => const _ListSkeleton(),
                  error: (_, _) =>
                      const _Message(text: "Couldn't load laundry services"),
                  data: (items) {
                    if (items.isEmpty) {
                      return const _Message(
                        text: 'No laundry items in this category yet',
                      );
                    }
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        dims.padding.p16,
                        dims.padding.p8,
                        dims.padding.p16,
                        dims.spacing.s32,
                      ),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => Gap(dims.spacing.s12),
                      itemBuilder: (_, index) =>
                          LaundryServiceCard(item: items[index]),
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

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return ListView.separated(
      padding: EdgeInsets.all(dims.padding.p16),
      itemCount: 6,
      separatorBuilder: (_, _) => Gap(dims.spacing.s12),
      itemBuilder: (_, _) => Container(
        height: 132,
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r16),
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
            Icons.local_laundry_service_outlined,
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
