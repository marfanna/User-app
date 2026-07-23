import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../medicine_home/widgets/medicine_cart_fab.dart';
import '../../medicine_home/widgets/medicine_home_header.dart';
import '../riverpod/laundry_provider.dart';
import '../widgets/laundry_home_widgets.dart';

class LaundryHomeScreen extends ConsumerWidget {
  const LaundryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final categoriesAsync = ref.watch(laundryCategoriesProvider);
    final servicesAsync = ref.watch(laundryServicesProvider);

    return Scaffold(
      floatingActionButton: const MedicineCartFab(),
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(dims.spacing.s16),
                      const MedicineHomeHeader(currentRoute: Routes.laundry),
                      Gap(dims.spacing.s24),
                      const LaundryHero(),
                      Gap(dims.spacing.s16),
                      const LaundryProcessStrip(),
                      Gap(dims.spacing.s16),
                      LaundryCategoryChips(
                        categories: categoriesAsync.value ?? const [],
                      ),
                      Gap(dims.spacing.s24),
                      _AvailabilityMessage(async: servicesAsync),
                    ],
                  ),
                ),
              ),
              _categorySections(context, categoriesAsync),
              SliverToBoxAdapter(child: Gap(dims.spacing.s100)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categorySections(
    BuildContext context,
    AsyncValue<List<String>> async,
  ) {
    final dims = context.dimensions;

    return async.when(
      loading: () => SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, _) => Gap(dims.spacing.s24),
          itemBuilder: (_, _) => const _SectionPlaceholder(),
        ),
      ),
      error: (_, _) => const SliverToBoxAdapter(
        child: _Message(text: "Couldn't load laundry services"),
      ),
      data: (categories) {
        if (categories.isEmpty) {
          return const SliverToBoxAdapter(
            child: _Message(text: 'Laundry services are not available yet'),
          );
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
          sliver: SliverList.separated(
            itemCount: categories.length,
            separatorBuilder: (_, _) => Gap(dims.spacing.s24),
            itemBuilder: (_, index) =>
                LaundryCategorySection(category: categories[index]),
          ),
        );
      },
    );
  }
}

class _AvailabilityMessage extends StatelessWidget {
  const _AvailabilityMessage({required this.async});

  final AsyncValue<List<LaundryCatalogItem>> async;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return async.maybeWhen(
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(dims.padding.p12),
          decoration: BoxDecoration(
            color: colors.background.surface,
            borderRadius: BorderRadius.circular(dims.radius.r16),
            border: Border.all(color: colors.border.divider),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colors.icon.primary,
                size: dims.size.s20,
              ),
              Gap(dims.spacing.s10),
              Expanded(
                child: Text(
                  'Prices are fixed per item. '
                  'Rider pickup is ASAP after checkout.',
                  style: text.labelMedium.copyWith(
                    color: colors.text.secondary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _SectionPlaceholder extends StatelessWidget {
  const _SectionPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      height: 214,
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r16),
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

    return Padding(
      padding: EdgeInsets.all(dims.padding.p32),
      child: Center(
        child: Column(
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
      ),
    );
  }
}
