import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../domain/entities/order_entity.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/widgets/card/duare_card.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/gradient_background.dart';
import '../riverpod/track_order_provider.dart';

String _maskOrderId(String id) {
  if (id.length <= 4) return id;
  return '...${id.substring(id.length - 4)}';
}

class TrackOrderScreen extends ConsumerStatefulWidget {
  final String orderId;

  const TrackOrderScreen({super.key, required this.orderId});

  @override
  ConsumerState<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends ConsumerState<TrackOrderScreen> {
  static const _cancelWindowSeconds = 240; // 4-min cancel window
  int _secondsLeft = 0;
  Timer? _timer;
  OrderEntity? _currentOrder;
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    _startTimer();
    _setupFCMListener();
  }

  void _setupFCMListener() {
    _fcmSubscription = FirebaseMessaging.onMessage.listen((message) {
      final payloadOrderId = message.data['orderId'];
      if (payloadOrderId == widget.orderId || payloadOrderId == null) {
        ref.invalidate(trackOrderProvider(widget.orderId));
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_currentOrder == null) return;
      final diff = DateTime.now()
          .difference(_currentOrder!.createdAt ?? DateTime.now())
          .inSeconds;
      final left = _cancelWindowSeconds - diff;
      if (left > 0) {
        if (_secondsLeft != left) setState(() => _secondsLeft = left);
      } else {
        if (_secondsLeft > 0) {
          _timer?.cancel();
          setState(() => _secondsLeft = 0);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fcmSubscription?.cancel();
    super.dispose();
  }

  String get _countdown {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  bool get _showCancel =>
      _secondsLeft > 0 && (_currentOrder?.status == 'pending');

  bool get _showLocked {
    final s = _currentOrder?.status;
    if (s == null) return false;
    return _secondsLeft == 0 &&
        s != 'delivered' &&
        s != 'cancelled' &&
        s != 'rejected' &&
        s != 'refunded';
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(trackOrderProvider(widget.orderId));

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: orderAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, _) => ErrorState(
                    message: err.toString(),
                    onRetry: () =>
                        ref.invalidate(trackOrderProvider(widget.orderId)),
                  ),
                  data: (order) {
                    _currentOrder = order;
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          _buildStatusCard(order),
                          const Gap(16),
                          _buildReceiptCard(order),
                          const Gap(24),
                        ],
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

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: const DuareAppBar(title: 'Order Status'),
    );
  }

  Widget _buildStatusCard(OrderEntity order) {
    return DuareCard(
      borderRadius: 7.28,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderSummaryRow(order),
          const Gap(16),
          _buildEstimatedTime(),
          const Gap(20),
          _buildTimeline(order),
          if (order.assignedRider != null) ...[
            const Gap(20),
            _buildRiderCard(order),
          ],
        ],
      ),
    );
  }

  Widget _buildReceiptCard(OrderEntity order) {
    return DuareCard(
      borderRadius: 7.28,
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...order.items.asMap().entries.map((e) => _buildReceiptItem(
                index: e.key + 1,
                name: e.value.name,
                subtitle: e.value.variant?.name ?? '',
                qty: e.value.quantity,
                price: e.value.totalPrice.toInt(),
              )),
          const Gap(16),
          _buildPriceSummary(order),
          if (_showCancel) ...[
            const Gap(16),
            _buildCancelButton(),
          ] else if (_showLocked) ...[
            const Gap(16),
            _buildOrderLockedButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummaryRow(OrderEntity order) {
    final date = order.createdAt != null
        ? DateFormat('dd MMM, hh:mm a')
            .format(order.createdAt!.toLocal())
            .toUpperCase()
        : 'N/A';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF6B6E82),
                ),
              ),
              const Gap(6),
              Text(
                'Order Id #${_maskOrderId(order.orderId)}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF040707),
                ),
              ),
              const Gap(4),
              Text(
                order.shop?.name ?? 'Unknown Shop',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
              'BDT ${order.grandTotal.toInt()}',
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
    );
  }

  Widget _buildEstimatedTime() {
    return const Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 20,
          color: Color(0xFF60635E),
        ),
        Gap(8),
        Expanded(
          child: Text(
            'Order Estimated time',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: Color(0xFF70756B),
            ),
          ),
        ),
        Text(
          '30mins',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Color(0xFF363A33),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(OrderEntity order) {
    int currentStep = 0;
    switch (order.status) {
      case 'pending':
        currentStep = 0;
      case 'confirmed':
      case 'preparing':
      case 'ready_for_pickup':
        currentStep = 1;
      case 'assigned':
      case 'picked_up':
      case 'on_way':
        currentStep = 2;
      case 'delivered':
        currentStep = 3;
      case 'cancelled':
      case 'rejected':
      case 'refunded':
        currentStep = -1;
    }

    if (currentStep == -1) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Order ${order.status.toUpperCase()}',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    String? fmt(DateTime? t) =>
        t != null ? DateFormat('hh:mm a').format(t.toLocal()) : null;

    final steps = [
      (label: 'Order Pending', time: fmt(order.createdAt), active: true),
      (
        label: 'Processing',
        time: currentStep >= 1 ? fmt(order.updatedAt) : null,
        active: currentStep >= 1,
      ),
      (
        label: 'On The Way',
        time: currentStep >= 2 ? fmt(order.updatedAt) : null,
        active: currentStep >= 2,
      ),
      (
        label: 'Delivered',
        time: currentStep >= 3 ? fmt(order.updatedAt) : null,
        active: currentStep >= 3,
      ),
    ];

    return Column(
      children: List.generate(steps.length, (i) {
        final step = steps[i];
        final isLast = i == steps.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
              child: Column(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: step.active
                          ? const Color(0xFF0156A7)
                          : const Color(0xFFA0A4AD),
                    ),
                  ),
                  if (!isLast)
                    SizedBox(
                      height: step.time != null ? 52 : 36,
                      child: CustomPaint(
                        painter: _DashedLinePainter(
                          color: step.active
                              ? const Color(0xFF0156A7)
                              : const Color(0xFFA0A4AD),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: Opacity(
                opacity: step.active ? 1.0 : 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.label,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Color(0xFF040707),
                      ),
                    ),
                    if (step.time != null) ...[
                      const Gap(2),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: 14,
                            color: Color(0xFF0156A7),
                          ),
                          const Gap(4),
                          Text(
                            step.time!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              letterSpacing: -0.5,
                              color: Color(0xFF9F9F9F),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (!isLast) const Gap(16),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildRiderCard(OrderEntity order) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFD0D0D0),
                  border: Border.all(
                    color: const Color.fromRGBO(145, 149, 142, 0.06),
                  ),
                ),
                child: const Icon(Icons.person, size: 28, color: Colors.white),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.assignedRider ?? 'Rider',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        height: 1.7,
                        color: Color(0xFF363A33),
                      ),
                    ),
                    if (order.customer?.phone.isNotEmpty == true)
                      Text(
                        order.customer!.phone,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          height: 1.7,
                          color: Color(0xFF60655C),
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8EBE6)),
                ),
                child: const Icon(
                  Icons.call_outlined,
                  size: 20,
                  color: Color(0xFF60635E),
                ),
              ),
            ],
          ),
          const Gap(10),
          const Divider(color: Color(0xFFE8EBE6), height: 1),
          const Gap(10),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: Color(0xFF60635E),
              ),
              const Gap(8),
              const Text(
                'Deliver to',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Color(0xFF70756B),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  order.deliveryAddress?.type?.isNotEmpty == true
                      ? order.deliveryAddress!.type!
                      : order.deliveryAddress?.street ?? 'Home',
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF363A33),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptItem({
    required int index,
    required String name,
    required String subtitle,
    required int qty,
    required int price,
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
                    fontFamily: 'Manrope',
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
                    if (subtitle.isNotEmpty)
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
                        fontFamily: 'Manrope',
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
        Container(height: 1, color: const Color(0xFFEBEBEB)),
      ],
    );
  }

  Widget _buildPriceSummary(OrderEntity order) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          _summaryRow('Sub-Total', order.subtotal.toInt()),
          const Gap(6),
          _summaryRow('Delivery Charge', order.deliveryCharge.toInt()),
          const Gap(6),
          _summaryRow('Discount', order.discountAmount.toInt()),
          const Gap(6),
          _summaryRow('Rider Tips', order.tip.toInt()),
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
                'BDT ${order.grandTotal.toInt()}',
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

  Widget _summaryRow(String label, int amount) {
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

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: _confirmCancel,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFF6220E),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Cancel Order',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: -0.5,
                color: Colors.white,
              ),
            ),
            Text(
              _countdown,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderLockedButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Order Locked',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          letterSpacing: -0.5,
          color: Color(0xFF737780),
        ),
      ),
    );
  }

  void _confirmCancel() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Cancel Order?'),
        content: const Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Color(0xFFF6220E)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  const _DashedLinePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashH = 4.0;
    const gapH = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, (y + dashH).clamp(0, size.height)),
        paint,
      );
      y += dashH + gapH;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}
