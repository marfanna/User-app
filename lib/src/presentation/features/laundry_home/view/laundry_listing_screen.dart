import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../models/laundry_listing_args.dart';
import '../riverpod/laundry_provider.dart';
import '../widgets/laundry_home_widgets.dart';
import '../widgets/laundry_service_card.dart';

class LaundryListingScreen extends ConsumerWidget {
  const LaundryListingScreen({super.key, required this.args});

  final LaundryListingArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final async = ref.watch(laundryListingProvider(args.categoryLabel));

    return Scaffold(
      bottomNavigationBar: const LaundryCartBar(),
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
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        dims.padding.p16,
                        dims.padding.p8,
                        dims.padding.p16,
                        dims.spacing.s32,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: dims.padding.p12,
                        ),
                        decoration: BoxDecoration(
                          color: colors.background.surface,
                          borderRadius: BorderRadius.circular(dims.radius.r12),
                          boxShadow: [
                            BoxShadow(
                              color: colors.elevation.elevationLow,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            for (var i = 0; i < items.length; i++) ...[
                              if (i > 0)
                                Divider(
                                  height: 1,
                                  color: colors.border.divider,
                                ),
                              LaundryServiceRow(item: items[i]),
                            ],
                          ],
                        ),
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
