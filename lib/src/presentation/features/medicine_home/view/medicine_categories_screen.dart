import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../models/medicine_listing_args.dart';
import '../riverpod/medicine_categories_provider.dart';
import '../riverpod/medicine_category_provider.dart';
import '../widgets/medicine_category_icon.dart';
import '../widgets/medicine_category_tile.dart';

/// Full medicine category catalogue (the grid's "See all" destination).
/// Built from the real `itemCategory` values across the franchise's pharmacies.
class MedicineCategoriesScreen extends ConsumerWidget {
  const MedicineCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = context.textStyle;
    final dims = context.dimensions;
    final selected = ref.watch(selectedMedicineSubCategoryProvider);
    final async = ref.watch(medicineAggregatedCategoriesProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(dims.spacing.s16),
                Row(
                  children: [
                    const RoundedBackButton.secondary(),
                    Gap(dims.spacing.s12),
                    Text('All Categories', style: text.titleLarge),
                  ],
                ),
                Gap(dims.spacing.s24),
                Expanded(
                  child: async.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (_, _) => _empty(context, "Couldn't load"),
                    data: (categories) {
                      if (categories.isEmpty) {
                        return _empty(context, 'No categories yet');
                      }
                      return GridView.builder(
                        padding: EdgeInsets.only(bottom: dims.spacing.s24),
                        itemCount: categories.length,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: dims.spacing.s16,
                              crossAxisSpacing: dims.spacing.s12,
                              childAspectRatio: 0.78,
                            ),
                        itemBuilder: (_, i) {
                          final label = categories[i];
                          return MedicineCategoryTile(
                            label: label,
                            icon: medicineCategoryIcon(label),
                            selected: selected == label,
                            onTap: () {
                              ref
                                  .read(
                                    selectedMedicineSubCategoryProvider
                                        .notifier,
                                  )
                                  .select(label);
                              context.push(
                                Routes.medicineListing,
                                extra: MedicineListingArgs(
                                  categoryLabel: label,
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _empty(BuildContext context, String message) {
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
            message,
            style: context.textStyle.bodyMedium.copyWith(
              color: colors.text.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
