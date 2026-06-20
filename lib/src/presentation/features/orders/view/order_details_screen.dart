import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/widgets/button/primary_gradient_button.dart';
import '../../../core/widgets/card/duare_card.dart';
import '../../../core/widgets/toast.dart';
import '../riverpod/order_provider.dart';
import '../riverpod/re_order_provider.dart';
import '../../../core/models/order_details_ui_model.dart';
import '../../../../core/utiliity/order_id_util.dart';

class OrderDetailsScreen extends ConsumerStatefulWidget {

  const OrderDetailsScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends ConsumerState<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual<AsyncValue<ReOrderResult?>>(reOrderProvider, (_, next) {
      if (!mounted) return;
      next.whenOrNull(
        data: (result) {
          if (result == null) return;
          final msg = result.skipped == 0
              ? '${result.added} items added to cart'
              : '${result.added} added, ${result.skipped} unavailable';
          Toast.success(context, msg,
              duration: const Duration(seconds: 3));
        },
        error: (e, _) => Toast.error(context, 'Re-order failed: $e'),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(orderProvider(orderId: widget.orderId));
    final order = orderAsync.asData?.value;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              DuareAppBar(
                title: 'Order Details',
                trailing: order?.isDelivered == true
                    ? _HelpButton(orderId: widget.orderId)
                    : null,
              ),
              Expanded(
                child: orderAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text(err.toString())),
                  data: (order) => SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: _buildDetailsCard(context, order),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context, OrderDetailsUIModel order) {
    return DuareCard(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
      borderRadius: 7.28,
      child: Column(
        children: [
          _buildOrderSummaryHeader(order),
          const Gap(16),
          ...order.items.asMap().entries.map((entry) {
            final index = entry.key + 1;
            final item = entry.value;
            return _buildOrderItem(
              index: index,
              name: item.name,
              subtitle: item.portion,
              qty: item.qty,
              price: item.unitPrice.toInt(),
              showDivider: true,
            );
          }),
          const Gap(16),
          _buildPriceSummary(order),
          if (order.isDelivered) ...[
            const Gap(24),
            _buildActionButtons(context, order),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummaryHeader(OrderDetailsUIModel order) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderDate.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF6B6E82),
                    textBaseline: TextBaseline.alphabetic,
                  ),
                ),
                const Gap(4),
                Text(
                  'Order Id #${maskOrderId(order.orderDisplayId)}',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(2),
                Text(
                  order.shopName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF040707),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF040707),
                ),
              ),
              const Gap(2),
              Text(
                'BDT ${order.totalPrice}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem({
    required int index,
    required String name,
    required String subtitle,
    required int qty,
    required int price,
    required bool showDivider,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '$index.',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF040707),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF040707),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF040707),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Qty ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF737780),
                      ),
                      children: [
                        TextSpan(
                          text: '$qty',
                          style: const TextStyle(color: Color(0xFF040707)),
                        ),
                      ],
                    ),
                  ),
                  const Gap(4),
                  Text(
                    'BDT $price',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Color(0xFF040707),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) Container(height: 1, color: const Color(0xFFEBEBEB)),
      ],
    );
  }

  Widget _buildPriceSummary(OrderDetailsUIModel order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          _buildSummaryRow('Sub-Total', order.subTotal.toInt()),
          const Gap(6),
          _buildSummaryRow('Delivery Charge', order.deliveryFee.toInt()),
          const Gap(6),
          _buildSummaryRow('Discount', order.discount.toInt()),
          const Gap(6),
          _buildSummaryRow('Rider Tips', 0),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 18.72,
                  color: Color(0xFF040707),
                ),
              ),
              Text(
                'BDT ${order.total.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 18.72,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 14.56,
            color: Color(0xFF585C67),
          ),
        ),
        Text(
          'BDT $amount',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 14.56,
            color: Color(0xFF585C67),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    OrderDetailsUIModel order,
  ) {
    final reOrderState = ref.watch(reOrderProvider);
    final isLoading = reOrderState is AsyncLoading;

    return Row(
      children: [
        Expanded(
          child: PrimaryGradientButton(
            text: 'Re-order',
            height: 48,
            borderRadius: 4,
            trailing: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : null,
            onPressed: isLoading
                ? null
                : () => ref
                    .read(reOrderProvider.notifier)
                    .reOrder(order),
          ),
        ),
        const Gap(10),
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF0156A7)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  context.pushNamed(
                    Routes.trackOrder,
                    pathParameters: {'id': order.id},
                  );
                },
                child: const Center(
                  child: Text(
                    'Track Order',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xFF0156A7),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HelpButton extends StatelessWidget {
  const _HelpButton({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.disputePath(orderId)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF036FFD).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.help_outline_rounded,
              size: 16,
              color: Color(0xFF036FFD),
            ),
            Gap(4),
            Text(
              'Help',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF036FFD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
