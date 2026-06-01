import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
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
                error: (_, __) => const Center(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
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
              const Gap(6),
              Row(
                children: [
                  const Text(
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
                  const Gap(4),
                  const Icon(
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
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Gap(2),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
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

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final CustomerOrderModel order;

  String _formatDate(DateTime dt) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]}, $h:$m';
  }

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
                child: _GradientButton(label: 'Re-order', onTap: () {}),
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
  const _GradientButton({required this.label, required this.onTap});

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
          gradient: const RadialGradient(
            center: Alignment(-0.27, -0.27),
            radius: 1.53,
            colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
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
