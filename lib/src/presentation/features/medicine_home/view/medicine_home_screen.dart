import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../riverpod/medicine_categories_provider.dart';
import '../widgets/medicine_best_selling_strip.dart';
import '../widgets/medicine_category_section.dart';
import '../widgets/medicine_featured_strip.dart';
import '../widgets/medicine_home_header.dart';
import '../widgets/medicine_nearby_pharmacies.dart';
import '../widgets/medicine_promotional_banner.dart';
import '../widgets/medicine_reorder_strip.dart';
import '../widgets/medicine_search_bar.dart';

/// Medicine (pharmacy) category homepage.
///
/// Top: Header → Search → Order Again → Featured → Best Selling → Banner. Then
/// every real medicine category renders as its own horizontal "section by
/// section" strip (6 products + See all), built lazily as you scroll so a large
/// catalogue doesn't hammer the API at once. Nearby Pharmacies sits at the very
/// bottom.
class MedicineHomeScreen extends ConsumerWidget {
  const MedicineHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final categoriesAsync = ref.watch(medicineAggregatedCategoriesProvider);

    return Scaffold(
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
                      const MedicineHomeHeader(),
                      Gap(dims.spacing.s24),
                      const MedicineSearchBar(),
                      Gap(dims.spacing.s24),
                      const MedicineReorderStrip(),
                      Gap(dims.spacing.s24),
                      const MedicineFeaturedStrip(),
                      Gap(dims.spacing.s24),
                      const MedicineBestSellingStrip(),
                      Gap(dims.spacing.s24),
                      const MedicinePromotionalBanner(),
                      Gap(dims.spacing.s24),
                    ],
                  ),
                ),
              ),
              _categorySections(context, categoriesAsync),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  dims.padding.p16,
                  dims.spacing.s24,
                  dims.padding.p16,
                  0,
                ),
                sliver: const SliverToBoxAdapter(
                  child: MedicineNearbyPharmacies(),
                ),
              ),
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
          itemBuilder: (_, i) => const _SectionPlaceholder(),
        ),
      ),
      error: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      data: (categories) {
        if (categories.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }
        return SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
          sliver: SliverList.separated(
            itemCount: categories.length,
            separatorBuilder: (_, _) => Gap(dims.spacing.s24),
            itemBuilder: (_, i) =>
                MedicineCategorySection(category: categories[i]),
          ),
        );
      },
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
      width: 160,
      height: 22,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighDim,
        borderRadius: BorderRadius.circular(dims.radius.r4),
      ),
    );
  }
}
