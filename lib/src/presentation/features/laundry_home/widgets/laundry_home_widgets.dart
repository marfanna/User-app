import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../models/laundry_listing_args.dart';
import '../riverpod/laundry_provider.dart';
import 'laundry_service_card.dart';

class LaundryHero extends StatelessWidget {
  const LaundryHero({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dims.padding.p20),
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(dims.radius.r24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: dims.size.s56,
            height: dims.size.s56,
            decoration: BoxDecoration(
              color: colors.background.surface.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(dims.radius.r16),
              border: Border.all(
                color: colors.background.surface.withValues(alpha: 0.2),
              ),
            ),
            child: Icon(
              Icons.local_laundry_service_outlined,
              color: colors.icon.inverse,
              size: dims.size.s28,
            ),
          ),
          Gap(dims.spacing.s24),
          Text(
            'Laundry pickup from your door',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: text.displaySmallCompact.copyWith(
              color: colors.text.inverse,
              letterSpacing: 0,
              height: 1.08,
            ),
          ),
          Gap(dims.spacing.s8),
          Text(
            'Duare handles pickup, cleaning, and delivery back to '
            'the same address.',
            style: text.bodySmall.copyWith(
              color: colors.text.inverse.withValues(alpha: 0.82),
              height: 1.35,
            ),
          ),
          Gap(dims.spacing.s16),
          Wrap(
            spacing: dims.spacing.s8,
            runSpacing: dims.spacing.s8,
            children: const [
              _HeroPill(label: 'ASAP pickup'),
              _HeroPill(label: 'Per-item pricing'),
              _HeroPill(label: '7-14 day return'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dims.padding.p10,
        vertical: dims.padding.p6,
      ),
      decoration: BoxDecoration(
        color: colors.background.surface.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(dims.radius.r64),
      ),
      child: Text(
        label,
        style: context.textStyle.labelSmallSemiBold.copyWith(
          color: colors.text.inverse,
        ),
      ),
    );
  }
}

class LaundryProcessStrip extends StatelessWidget {
  const LaundryProcessStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;

    return Row(
      children: [
        const Expanded(
          child: _ProcessStep(
            icon: Icons.shopping_bag_outlined,
            title: 'Choose',
            subtitle: 'Add items',
          ),
        ),
        Gap(dims.spacing.s8),
        const Expanded(
          child: _ProcessStep(
            icon: Icons.two_wheeler_outlined,
            title: 'Pickup',
            subtitle: 'ASAP rider',
          ),
        ),
        Gap(dims.spacing.s8),
        const Expanded(
          child: _ProcessStep(
            icon: Icons.checkroom_outlined,
            title: 'Return',
            subtitle: '7-14 days',
          ),
        ),
      ],
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.all(dims.padding.p12),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r16),
        border: Border.all(color: colors.border.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.icon.primary, size: dims.size.s22),
          Gap(dims.spacing.s12),
          Text(title, style: text.labelLarge),
          Gap(dims.spacing.s2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelSmall.copyWith(color: colors.text.secondary),
          ),
        ],
      ),
    );
  }
}

class LaundryCategoryChips extends StatelessWidget {
  const LaundryCategoryChips({super.key, required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const SizedBox.shrink();
    final dims = context.dimensions;

    return SizedBox(
      height: dims.size.s40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: categories.length,
        separatorBuilder: (_, _) => Gap(dims.spacing.s8),
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => context.push(
              Routes.laundryListing,
              extra: LaundryListingArgs(categoryLabel: category),
            ),
            child: _CategoryChip(label: category),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r64),
        border: Border.all(color: colors.border.divider),
      ),
      child: Text(
        label,
        style: context.textStyle.labelMedium.copyWith(
          color: colors.text.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class LaundryCategorySection extends ConsumerWidget {
  const LaundryCategorySection({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(laundryCategoryPreviewProvider(category));
    final dims = context.dimensions;

    return async.when(
      loading: () => const _SectionSkeleton(),
      error: (_, _) => const SizedBox.shrink(),
      data: (items) {
        if (items.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: category,
              onSeeAll: () => context.push(
                Routes.laundryListing,
                extra: LaundryListingArgs(categoryLabel: category),
              ),
            ),
            Gap(dims.spacing.s16),
            SizedBox(
              height: 214,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: items.length,
                separatorBuilder: (_, _) => Gap(dims.spacing.s12),
                itemBuilder: (_, index) =>
                    LaundryServiceCard(item: items[index], compact: true),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.titleLarge.copyWith(
              color: colors.text.primary,
              letterSpacing: 0,
            ),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'See all',
              style: text.labelMedium.copyWith(color: colors.brand.primary),
            ),
          ),
      ],
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton();

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
