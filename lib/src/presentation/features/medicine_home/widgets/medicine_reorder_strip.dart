import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../orders/models/customer_order_model.dart';
import '../riverpod/pharmacy_reorder_provider.dart';
import 'medicine_section_header.dart';

/// "Order Again" strip — recent pharmacy orders for quick reorder.
///
/// Tapping a card opens the order detail screen, where the existing reorder
/// flow re-adds the items to the cart. Auto-hides when there are no past
/// pharmacy orders.
class MedicineReorderStrip extends ConsumerWidget {
  const MedicineReorderStrip({super.key});

  static const double stripHeight = 96;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dims = context.dimensions;
    final async = ref.watch(pharmacyReorderProvider);

    return async.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (orders) {
        if (orders.isEmpty) return const SizedBox.shrink();
        final recent = orders.take(8).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MedicineSectionHeader(title: 'Order Again'),
            Gap(dims.spacing.s16),
            SizedBox(
              height: stripHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                itemCount: recent.length,
                separatorBuilder: (_, _) => Gap(dims.spacing.s12),
                itemBuilder: (_, i) => _ReorderCard(
                  order: recent[i],
                  onTap: () => context.pushNamed(
                    Routes.orderDetails,
                    pathParameters: {'id': recent[i].id},
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ReorderCard extends StatelessWidget {
  const _ReorderCard({required this.order, required this.onTap});

  final CustomerOrderModel order;
  final VoidCallback onTap;

  static const double cardWidth = 260;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        padding: EdgeInsets.all(dims.padding.p12),
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
        child: Row(
          children: [
            Container(
              width: dims.size.s48,
              height: dims.size.s48,
              decoration: BoxDecoration(
                color: colors.brand.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(dims.radius.r10),
              ),
              child: Icon(
                Icons.medication_outlined,
                color: colors.brand.primary,
                size: dims.size.s24,
              ),
            ),
            Gap(dims.spacing.s12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.shopName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.titleSmall,
                  ),
                  Gap(dims.spacing.s4),
                  Text(
                    'BDT ${order.total.toStringAsFixed(0)} · '
                    '${_formatDate(order.createdAt)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: text.labelMedium.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
            Gap(dims.spacing.s8),
            Icon(
              Icons.replay_rounded,
              color: colors.brand.primary,
              size: dims.size.s24,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]}';
  }
}
