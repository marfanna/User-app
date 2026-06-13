import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/toast.dart';
import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../models/customer_order_model.dart';
import '../riverpod/customer_orders_provider.dart';

class OrderTabScreen extends ConsumerWidget {
  const OrderTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(customerOrdersProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x1A036FFD), Color(0x1AE8F2FF)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Expanded(
              child: async.when(
                loading: () => _buildSkeleton(),
                error: (_, _) => const Center(
                  child: Text(
                    'Failed to load orders',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: Color(0xFF737780),
                    ),
                  ),
                ),
                data: (orders) => _buildList(context, orders),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.28,
                  letterSpacing: -1,
                  color: Color(0xFF040707),
                ),
              ),
              Gap(6),
              Row(
                children: [
                  Text(
                    'Restaurants',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 1.28,
                      letterSpacing: -1,
                      color: Color(0xFF040707),
                    ),
                  ),
                  Gap(4),
                  Icon(
                    Icons.expand_more,
                    color: Color(0xFF1C1B1F),
                    size: 24,
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.push(Routes.cart),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Color(0xFF1C1C1C),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<CustomerOrderModel> orders) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              height: 1.28,
              color: Color(0xFF040707),
            ),
          ),
          const Gap(16),
          if (orders.isEmpty)
            _buildEmpty()
          else
            Column(
              children: [
                for (int i = 0; i < orders.length; i++) ...[
                  if (i > 0) const Gap(2),
                  _OrderCard(order: orders[i]),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Color(0xFFD0D0D0),
            ),
            Gap(16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xFF9B9B9B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const Gap(16),
          ...List.generate(
            3,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: _SkeletonCard(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends ConsumerStatefulWidget {
  const _OrderCard({required this.order});

  final CustomerOrderModel order;

  @override
  ConsumerState<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<_OrderCard> {
  bool _payLoading = false;

  String _formatDate(DateTime dt) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]}, $h:$m';
  }

  Future<void> _handlePay() async {
    setState(() => _payLoading = true);
    try {
      final repo = ref.read(bkashRepositoryProvider);
      final result = await repo.initiatePayment(
        orderId: widget.order.id,
        amount: widget.order.total,
      );
      if (!mounted) return;
      result.when(
        success: (data) {
          if (data?.checkoutUrl != null) {
            context.pushNamed(
              Routes.bkashPayment,
              extra: {
                'checkoutUrl': data!.checkoutUrl!,
                'paymentId': data.paymentID!,
                'orderId': widget.order.id,
              },
            );
          } else {
            Toast.error(context, 'Failed to get bKash checkout URL');
          }
        },
        error: (failure) {
          final msg = failure.message.contains('already in progress')
              ? 'Payment pending — open bKash app to complete'
              : 'Payment failed: ${failure.message}';
          Toast.error(context, msg, duration: const Duration(seconds: 4));
        },
      );
    } finally {
      if (mounted) setState(() => _payLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.28),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(90, 108, 234, 0.07),
            blurRadius: 52,
            offset: Offset(12.48, 27.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(order.createdAt),
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 1.33,
                        color: Color(0xFF6B6E82),
                      ),
                    ),
                    const Gap(10),
                    Text(
                      'Order Id #${order.displayId}',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.28,
                        color: Color(0xFF040707),
                      ),
                    ),
                    const Gap(5),
                    Text(
                      order.shopName,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF040707),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(21),
              RichText(
                textAlign: TextAlign.right,
                text: TextSpan(
                  text: 'Total Price\n',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF040707),
                  ),
                  children: [
                    TextSpan(
                      text: 'BDT ${order.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              Expanded(
                child: order.needsPayment
                    ? _GradientButton(
                        label: _payLoading ? 'Loading...' : 'Pay Now',
                        color: const Color(0xFFE2136E),
                        onTap: _payLoading ? () {} : _handlePay,
                      )
                    : _GradientButton(label: 'Re-order', onTap: () {}),
              ),
              const Gap(10),
              Expanded(
                child: _OutlineButton(
                  label: 'Preview',
                  onTap: () => context.pushNamed(
                    Routes.trackOrder,
                    pathParameters: {'id': order.id},
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.onTap,
    this.color,
  });

  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.27, -0.27),
            radius: 1.53,
            colors: color != null
                ? [color!, color!]
                : const [Color(0xFF0156A7), Color(0xFF2E3293)],
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: -0.5,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF0156A7)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: -0.5,
            color: Color(0xFF040707),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7.28),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(90, 108, 234, 0.07),
            blurRadius: 52,
            offset: Offset(12.48, 27.04),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bone(60, 12),
                    const Gap(10),
                    _bone(130, 16),
                    const Gap(5),
                    _bone(100, 14),
                  ],
                ),
              ),
              _bone(70, 40),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              Expanded(child: _bone(double.infinity, 40)),
              const Gap(10),
              Expanded(child: _bone(double.infinity, 40)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bone(double w, double h) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
