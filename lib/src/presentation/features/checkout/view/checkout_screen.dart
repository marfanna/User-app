import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart'; // re-enable with bKash option
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base/base.dart';
import '../../../core/theme/src/theme_extensions/src/gradients.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/analytics/analytics_service.dart';
import '../../../../data/services/network/endpoints.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../address_book/riverpod/address_book_provider.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../riverpod/checkout_state_providers.dart';

enum _PaymentMethod { cash, bkash }

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  _PaymentMethod _selectedPayment = _PaymentMethod.cash;
  final _instructionCtrl = TextEditingController();
  bool _placing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final items = ref.read(cartProvider);
      if (items.isEmpty) return;
      AnalyticsService.instance.logBeginCheckout(
        value: ref.read(cartProvider.notifier).subtotal,
        items: items
            .map((c) => AnalyticsService.instance.item(
                  itemId: c.item.id,
                  itemName: c.item.name,
                  price: c.selectedVariant?.price ?? c.item.price,
                  quantity: c.quantity,
                  category: c.shopName,
                ))
            .toList(),
      );
    });
  }

  @override
  void dispose() {
    _instructionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subtotal = ref.watch(cartProvider.notifier).subtotal;
    final deliveryCharge = ref.watch(checkoutDeliveryChargeProvider);
    final riderTip = ref.watch(checkoutRiderTipProvider);
    final discount = ref.watch(checkoutDiscountProvider);
    final total = subtotal + (deliveryCharge ?? 0) + riderTip - discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x1A036FFD), Color(0x1AE8F2FF)],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    _buildPaymentCard(),
                    const Gap(10),
                    _buildInstructionCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildSummaryPanel(
        subtotal: subtotal,
        deliveryCharge: deliveryCharge,
        riderTip: riderTip,
        discount: discount,
        total: total,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          RoundedBackButton.primary(
            onPressed: () {
              if (context.canPop()) context.pop();
            },
          ),
          const Gap(16),
          const Text(
            'Checkout',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              letterSpacing: -0.5,
              color: Color(0xFF040707),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
          const Row(
            children: [
              Icon(
                Icons.credit_card_outlined,
                size: 24,
                color: Color(0xFF60635E),
              ),
              Gap(12),
              Text(
                'Payment method',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.5,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          ),
          const Gap(10),
          _buildPaymentOption(
            method: _PaymentMethod.cash,
            child: const Text(
              'Cash On Delivery',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          // bKash option hidden for now — uncomment to re-enable.
          // const Gap(10),
          // _buildPaymentOption(
          //   method: _PaymentMethod.bkash,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       const Text(
          //         'bKash',
          //         style: TextStyle(
          //           fontFamily: 'Poppins',
          //           fontWeight: FontWeight.w500,
          //           fontSize: 16,
          //           color: Colors.black,
          //         ),
          //       ),
          //       const Gap(8),
          //       SvgPicture.asset(
          //         'assets/icons/bkash.svg',
          //         width: 28,
          //         height: 24,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required _PaymentMethod method,
    required Widget child,
  }) {
    final selected = _selectedPayment == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = method),
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD2D3D6)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF0156A7)
                      : const Color(0xFFDADADA),
                  width: 1.5,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0156A7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const Gap(12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
          const Text(
            'Special instruction',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF040707),
            ),
          ),
          const Gap(10),
          Container(
            height: 89,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD2D3D6)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: TextField(
              controller: _instructionCtrl,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: -0.5,
                color: Color(0xFF040707),
              ),
              decoration: const InputDecoration(
                hintText: 'Any special instructions?',
                hintStyle: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.5,
                  color: Color(0xFFA0A4AD),
                ),
                contentPadding: EdgeInsets.all(16),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPanel({
    required double subtotal,
    required double? deliveryCharge,
    required double riderTip,
    required int discount,
    required double total,
  }) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          gradient: AppGradients.primaryLinear,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _summaryLabel('Sub-Total'),
                      const Gap(2),
                      _summaryLabel('Delivery Charge'),
                      const Gap(2),
                      _summaryLabel('Discount'),
                      const Gap(2),
                      _summaryLabel('Rider Tips'),
                      const Gap(16),
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w800,
                          fontSize: 18.72,
                          letterSpacing: 0.67,
                          color: Color(0xFFFEFEFF),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _summaryValue('BDT ${subtotal.toInt()}'),
                    const Gap(2),
                    _summaryValue('BDT ${(deliveryCharge ?? 0).toInt()}'),
                    const Gap(2),
                    _summaryValue('BDT $discount'),
                    const Gap(2),
                    _summaryValue('BDT ${riderTip.toInt()}'),
                    const Gap(16),
                    Text(
                      'BDT ${total.toInt()}',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w800,
                        fontSize: 18.72,
                        letterSpacing: 0.67,
                        color: Color(0xFFFEFEFF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Gap(16),
            _buildPlaceOrderButton(total),
          ],
        ),
      ),
    );
  }

  Widget _summaryLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w500,
      fontSize: 14.56,
      height: 1.37,
      letterSpacing: 0.52,
      color: Color(0xFFFEFEFF),
    ),
  );

  Widget _summaryValue(String text) => Text(
    text,
    textAlign: TextAlign.right,
    style: const TextStyle(
      fontFamily: 'Manrope',
      fontWeight: FontWeight.w500,
      fontSize: 14.56,
      height: 1.37,
      letterSpacing: 0.52,
      color: Color(0xFFFEFEFF),
    ),
  );

  Widget _buildPlaceOrderButton(double total) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: TextButton(
        onPressed: _placing ? null : () => _placeOrder(total),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0156A7),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 26),
        ),
        child: _placing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF0156A7),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Place order',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: -0.5,
                      color: Color(0xFF0156A7),
                    ),
                  ),
                  Icon(Icons.trending_flat, color: Color(0xFF0156A7), size: 24),
                ],
              ),
      ),
    );
  }

  Future<void> _placeOrder(double totalAmount) async {
    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) return;

    setState(() => _placing = true);
    try {
      final dio = ref.read(dioProvider);
      final shopId = cartItems.first.shopId;
      final items = cartItems
          .map(
            (c) => {
              'itemId': c.item.id,
              'itemType': 'menu_item',
              'quantity': c.quantity,
              if (c.selectedVariant != null)
                'variant': {
                  '_id': c.selectedVariant!.id,
                  'name': c.selectedVariant!.name,
                },
            },
          )
          .toList();

      final addressData = ref.read(addressBookProvider).value;
      Map<String, dynamic> deliveryAddress;
      if (addressData != null && addressData.addresses.isNotEmpty) {
        final selectedIndex =
            ref.read(selectedAddressIndexProvider) ??
            addressData.defaultAddressIndex;
        final effectiveIndex = selectedIndex < addressData.addresses.length
            ? selectedIndex
            : addressData.defaultAddressIndex;
        final addr = addressData.addresses[effectiveIndex];
        deliveryAddress = {
          'street': addr.street,
          'city': addr.city,
          'district': addr.district,
          'division': addr.division,
          if (addr.coordinates != null)
            'coordinates': {
              'type': 'Point',
              'coordinates': [
                addr.coordinates!.longitude,
                addr.coordinates!.latitude,
              ],
            },
        };
      } else {
        deliveryAddress = {
          'street': '',
          'city': 'Dhaka',
          'district': 'Dhaka',
          'division': 'Dhaka',
          'coordinates': {
            'type': 'Point',
            'coordinates': [90.4125, 23.8103],
          },
        };
      }

      final response = await dio.post(
        '${Endpoints.base}orders/create',
        data: {
          'shopId': shopId,
          'items': items,
          'paymentMethod': _selectedPayment == _PaymentMethod.bkash
              ? 'bkash'
              : 'cash_on_delivery',
          'orderChannel': Platform.isIOS ? 'ios' : 'android',
          if (_instructionCtrl.text.trim().isNotEmpty)
            'specialInstructions': _instructionCtrl.text.trim(),
          'deliveryAddress': deliveryAddress,
        },
      );

      final purchasedItems = ref.read(cartProvider);
      ref.read(cartProvider.notifier).clearCart();

      final orderData = response.data['data'];
      final orderId = orderData['_id'];

      AnalyticsService.instance.logPurchase(
        transactionId: orderId.toString(),
        value: totalAmount,
        items: purchasedItems
            .map((c) => AnalyticsService.instance.item(
                  itemId: c.item.id,
                  itemName: c.item.name,
                  price: c.selectedVariant?.price ?? c.item.price,
                  quantity: c.quantity,
                  category: c.shopName,
                ))
            .toList(),
      );

      if (_selectedPayment == _PaymentMethod.bkash) {
        final bkashRepo = ref.read(bkashRepositoryProvider);
        final bkashResult = await bkashRepo.initiatePayment(
          orderId: orderId,
          amount: totalAmount,
        );

        if (mounted) {
          bkashResult.when(
            success: (data) {
              if (data?.checkoutUrl != null) {
                context.pushReplacementNamed(
                  Routes.bkashPayment,
                  extra: {
                    'checkoutUrl': data!.checkoutUrl!,
                    'paymentId': data.paymentID!,
                    'orderId': orderId,
                  },
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to get bKash checkout URL'),
                  ),
                );
              }
            },
            error: (failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to initiate bKash payment: ${failure.message}',
                  ),
                ),
              );
            },
          );
        }
      } else {
        if (mounted) {
          context.pushReplacementNamed(
            Routes.orderSuccess,
            pathParameters: {'id': orderId},
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
      }
    } finally {
      if (mounted) setState(() => _placing = false);
    }
  }
}
