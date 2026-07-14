import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../orders/models/customer_order_model.dart';
import 'medicine_section_header.dart';

/// "Order Again" strip — recent orders for quick reorder. Shared by verticals
/// (Medicine, Mart, ...) — caller watches its own reorder provider and passes
/// the result in via [ordersAsync], matching `MedicineProductStrip`'s pattern.
///
/// Tapping a card opens the order detail screen, where the existing reorder
/// flow re-adds the items to the cart. Auto-hides when there are no past
/// orders for the vertical.
class MedicineReorderStrip extends StatelessWidget {
  const MedicineReorderStrip({
    super.key,
    required this.ordersAsync,
    this.title = 'Order Again',
    this.icon = Icons.medication_outlined,
  });

  final AsyncValue<List<CustomerOrderModel>> ordersAsync;
  final String title;
  final IconData icon;

  static const double stripHeight = 96;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;
    final async = ordersAsync;

    return async.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (orders) {
        if (orders.isEmpty) return const SizedBox.shrink();
        final recent = orders.take(8).toList();
        // Leading gap lives here, not in the parent Column, so a collapsed
        // (empty) strip contributes zero space instead of a dead fixed gap.
        return Padding(
          padding: EdgeInsets.only(top: dims.spacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedicineSectionHeader(title: title),
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
                    icon: icon,
                    onTap: () => context.pushNamed(
                      Routes.orderDetails,
                      pathParameters: {'id': recent[i].id},
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReorderCard extends StatelessWidget {
  const _ReorderCard({
    required this.order,
    required this.icon,
    required this.onTap,
  });

  final CustomerOrderModel order;
  final IconData icon;
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
              child: Icon(icon, color: colors.brand.primary, size: dims.size.s24),
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
