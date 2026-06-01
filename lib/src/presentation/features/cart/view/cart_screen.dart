import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../core/router/routes.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/widgets/button/primary_gradient_button.dart';
import '../../../core/widgets/card/duare_card.dart';
import '../../address_book/riverpod/address_book_provider.dart';
import '../../checkout/riverpod/checkout_state_providers.dart';
import '../models/cart_item_model.dart';
import '../riverpod/cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  double _riderTip = 0;

  // Delivery charge state
  double? _deliveryCharge;
  bool _deliveryLoading = false;
  String? _deliveryError;
  bool _calculating = false;
  bool _isAvailable = true;
  String? _availabilityMessage;

  @override
  void initState() {
    super.initState();
    // Trigger initial calculation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateDelivery());
  }

  Future<void> _calculateDelivery() async {
    if (_calculating) return;
    _calculating = true;

    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      _calculating = false;
      if (mounted) setState(() { _deliveryCharge = null; _deliveryError = null; });
      return;
    }

    // Get selected address with coordinates
    final addressAsync = ref.read(addressBookProvider);
    final addressData = addressAsync.value;
    if (addressData == null || addressData.addresses.isEmpty) {
      _calculating = false;
      if (mounted) setState(() { _deliveryCharge = null; _deliveryError = null; });
      return;
    }

    final selectedIndex = ref.read(selectedAddressIndexProvider) ?? addressData.defaultAddressIndex;
    final effectiveIndex = selectedIndex < addressData.addresses.length ? selectedIndex : addressData.defaultAddressIndex;
    final address = addressData.addresses[effectiveIndex];

    if (mounted) setState(() { _deliveryLoading = true; _deliveryError = null; });

    double? lat = address.coordinates?.latitude;
    double? lng = address.coordinates?.longitude;

    // Geocode fallback when coordinates are missing or zero
    final hasCoords = lat != null && lng != null && !(lat == 0 && lng == 0);
    if (!hasCoords) {
      try {
        final addressText = [
          address.street,
          address.city,
          address.district,
          address.division,
          'Bangladesh',
        ].where((s) => s.isNotEmpty).join(', ');
        final locations = await locationFromAddress(addressText);
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lng = locations.first.longitude;
        }
      } catch (_) {}
    }

    if (lat == null || lng == null) {
      _calculating = false;
      if (mounted) setState(() { _deliveryCharge = null; _deliveryLoading = false; _deliveryError = 'Could not determine address location'; });
      return;
    }

    setState(() {
      _deliveryLoading = true;
      _deliveryError = null;
      _availabilityMessage = null;
      _isAvailable = true;
    });

    try {
      final dio = ref.read(dioProvider);
      final shopId = cartItems.first.shopId;
      final subtotal = cartItems.fold<double>(0, (sum, c) => sum + c.totalPrice);

      final selectedIndex = ref.read(selectedAddressIndexProvider) ?? addressData.defaultAddressIndex;
      final effectiveIndex = selectedIndex < addressData.addresses.length
          ? selectedIndex
          : addressData.defaultAddressIndex;
      final addr = addressData.addresses[effectiveIndex];

      if (addr.coordinates == null) {
        setState(() {
          _deliveryError = 'Please select an address with valid map coordinates';
          _deliveryLoading = false;
        });
        _calculating = false;
        return;
      }

      final lat = addr.coordinates!.latitude;
      final lng = addr.coordinates!.longitude;

      final items = cartItems.map((c) => {
        'itemId': c.item.id,
        'quantity': c.quantity,
        'preparationTime': c.item.preparationTime?.toString(),
      }).toList();

      final response = await dio.post(
        'delivery/calculate',
        data: {
          'shopId': shopId,
          'latitude': lat,
          'longitude': lng,
          'orderAmount': subtotal,
          'items': items,
        },
      );

      final data = response.data;
      final result = (data is Map && data['data'] != null) ? data['data'] : data;

      if (mounted) {
        final charge = (result['deliveryCharge'] as num?)?.toDouble() ?? 0;
        final available = result['isAvailable'] as bool? ?? true;
        final msg = result['availabilityMessage'] as String?;
        setState(() {
          _deliveryCharge = charge;
          _isAvailable = available;
          _availabilityMessage = msg;
          _deliveryLoading = false;
        });
        ref.read(checkoutDeliveryChargeProvider.notifier).state = charge;
      }
    } catch (e) {
      if (mounted) {
        String errMsg = 'Unable to calculate delivery fee';
        if (e is DioException && e.response?.data != null) {
          final data = e.response!.data;
          if (data is Map && data['message'] != null) {
            errMsg = data['message'];
          }
        }
        setState(() {
          _deliveryCharge = null;
          _deliveryLoading = false;
          _deliveryError = errMsg;
          _isAvailable = false;
          _availabilityMessage = errMsg;
        });
      }
    } finally {
      _calculating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final subtotal = cartItems.fold<double>(0, (sum, c) => sum + c.totalPrice);

    // Recalculate when cart or selected address changes
    ref.listen(cartProvider, (_, __) => _calculateDelivery());
    ref.listen(selectedAddressIndexProvider, (_, __) => _calculateDelivery());
    ref.listen(addressBookProvider, (_, next) {
      if (next.hasValue) _calculateDelivery();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Column(
          children: [
            const DuareAppBar(title: 'My Cart'),
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 72, color: Color(0xFF0156A7)),
                          Gap(16),
                          Text(
                            'Your cart is empty',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Color(0xFF040707),
                            ),
                          ),
                          Gap(8),
                          Text(
                            'Add items from a restaurant to get started',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Color(0xFF737780),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(16),
                          ...cartItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _CartItemCard(cartItem: item),
                              )),
                          const Gap(24),
                          const _DeliveryAddressCard(),
                          const Gap(16),
                          _TipsCard(
                            tip: _riderTip,
                            onTipChanged: (v) {
                              setState(() => _riderTip = v);
                              ref.read(checkoutRiderTipProvider.notifier).state = v;
                            },
                          ),
                          const Gap(16),
                          _SummaryCard(
                            subtotal: subtotal,
                            riderTip: _riderTip,
                            deliveryCharge: _deliveryCharge,
                            deliveryLoading: _deliveryLoading,
                            deliveryError: _deliveryError,
                            onRetryDelivery: _calculateDelivery,
                            onDiscountChanged: (d) =>
                                ref.read(checkoutDiscountProvider.notifier).state = d,
                          ),
                          const Gap(32),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, cartItems.isEmpty),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool disabled) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(-0.24, -0.24),
                end: Alignment(0.99, 0.99),
                colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: disabled ? null : () {
                  if (!_isAvailable) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_availabilityMessage ?? 'Delivery is not available right now')),
                    );
                    return;
                  }
                  if (_deliveryCharge == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select a valid delivery address')),
                    );
                    return;
                  }
                  context.push(Routes.checkout);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        disabled ? 'Cart is empty' : 'Checkout',
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(Icons.trending_flat, color: Colors.white, size: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartItemCard extends ConsumerStatefulWidget {
  const _CartItemCard({required this.cartItem});
  final CartItemModel cartItem;

  @override
  ConsumerState<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends ConsumerState<_CartItemCard>
    with SingleTickerProviderStateMixin {
  static const double _deleteW = 80.0;
  static const double _snapThreshold = 32.0;

  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  double _dragStart = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _open() => _ctrl.animateTo(1.0);
  void _close() => _ctrl.animateTo(0.0);
  void _toggle() => _ctrl.value > 0.5 ? _close() : _open();

  void _delete() {
    _close();
    ref.read(cartProvider.notifier).updateQuantity(widget.cartItem.id, 0);
  }

  @override
  Widget build(BuildContext context) {
    final cartItem = widget.cartItem;

    return GestureDetector(
      onHorizontalDragStart: (d) => _dragStart = d.localPosition.dx,
      onHorizontalDragUpdate: (d) {
        final delta = d.localPosition.dx - _dragStart;
        // map delta to [0,1]: sliding left by _deleteW = value 1
        final target = (_ctrl.value - delta / _deleteW).clamp(0.0, 1.0);
        _ctrl.value = target;
        _dragStart = d.localPosition.dx;
      },
      onHorizontalDragEnd: (d) {
        if (_ctrl.value > _snapThreshold / _deleteW) {
          _open();
        } else {
          _close();
        }
      },
      onTap: () {
        if (_ctrl.value > 0) _close();
      },
      child: AnimatedBuilder(
        animation: _anim,
        builder: (context, child) {
          final offset = _anim.value * _deleteW;
          return Stack(
            children: [
              // Red delete button behind
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7.28),
                    child: GestureDetector(
                      onTap: _delete,
                      child: Container(
                        width: _deleteW,
                        color: const Color(0xFFE53935),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
                            Gap(4),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Card that slides left
              Transform.translate(
                offset: Offset(-offset, 0),
                child: child,
              ),
            ],
          );
        },
        child: DuareCard(
          padding: const EdgeInsets.all(10),
          borderRadius: 7.28,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 74,
                height: 74,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(7.28),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.28),
                  child: widget.cartItem.item.images.isNotEmpty
                      ? Image.network(
                          widget.cartItem.item.images.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.fastfood, color: Colors.white54),
                        )
                      : widget.cartItem.item.image != null &&
                              widget.cartItem.item.image!.isNotEmpty
                          ? Image.network(
                              widget.cartItem.item.image!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.fastfood, color: Colors.white54),
                            )
                          : const Icon(Icons.fastfood, color: Colors.white54),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.cartItem.item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        height: 1.28,
                        color: Color(0xFF040707),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      widget.cartItem.selectedVariant?.name ?? widget.cartItem.shopName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Color(0xFF737780),
                      ),
                    ),
                    const Gap(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'BDT ${widget.cartItem.unitPrice.toInt()}',
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF040707),
                          ),
                        ),
                        Row(
                          children: [
                            _counterBtn(
                              icon: Icons.remove,
                              isFilled: false,
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(widget.cartItem.id, widget.cartItem.quantity - 1),
                            ),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${widget.cartItem.quantity}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xFF040707),
                                ),
                              ),
                            ),
                            _counterBtn(
                              icon: Icons.add,
                              isFilled: true,
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(widget.cartItem.id, widget.cartItem.quantity + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _counterBtn({
    required IconData icon,
    required bool isFilled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isFilled
              ? const Color(0xFF0156A7)
              : const Color(0xFF0156A7).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: isFilled ? Colors.white : const Color(0xFF0156A7)),
      ),
    );
  }
}

class _DeliveryAddressCard extends ConsumerWidget {
  const _DeliveryAddressCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addressBookProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Delivery Address',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF040707),
          ),
        ),
        const Gap(8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: addressState.when(
            loading: () => const SizedBox(
              height: 48,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0156A7)),
                ),
              ),
            ),
            error: (_, __) => GestureDetector(
              onTap: () => context.push(Routes.addressBook),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Color(0xFF0156A7), size: 20),
                  Gap(6),
                  Text(
                    'Add delivery address',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF0156A7),
                    ),
                  ),
                ],
              ),
            ),
            data: (data) {
              if (data.addresses.isEmpty) {
                return GestureDetector(
                  onTap: () => context.push(Routes.addressBook),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Color(0xFF0156A7), size: 20),
                      Gap(6),
                      Text(
                        'Add delivery address',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF0156A7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final selectedIndex = ref.watch(selectedAddressIndexProvider)
                  ?? data.defaultAddressIndex;
              final effectiveIndex = selectedIndex < data.addresses.length
                  ? selectedIndex
                  : data.defaultAddressIndex;
              final address = data.addresses[effectiveIndex];

              final typeParts = [address.street, address.city]
                  .where((s) => s.isNotEmpty)
                  .join(', ');
              final subtitleParts = [address.district, address.division]
                  .where((s) => s.isNotEmpty)
                  .join(', ');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0156A7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      address.type?.isNotEmpty == true
                          ? _capitalize(address.type!)
                          : 'Home',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          typeParts.isNotEmpty ? typeParts : 'My Address',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF040707),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push(Routes.addressBook),
                        child: const Text(
                          'Change',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF0156A7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (subtitleParts.isNotEmpty) ...[
                    const Gap(4),
                    Text(
                      subtitleParts,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: Color(0xFF737780),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();
}

class _TipsCard extends StatefulWidget {
  const _TipsCard({required this.tip, required this.onTipChanged});
  final double tip;
  final ValueChanged<double> onTipChanged;

  @override
  State<_TipsCard> createState() => _TipsCardState();
}

class _TipsCardState extends State<_TipsCard> {
  static const _presets = [20, 50, 100];
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(
      text: widget.tip > 0 ? widget.tip.toInt().toString() : '',
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _selectPreset(int amount) {
    final newTip = widget.tip == amount.toDouble() ? 0.0 : amount.toDouble();
    widget.onTipChanged(newTip);
    _ctrl.text = newTip > 0 ? newTip.toInt().toString() : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Tips to Riders',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'OPTIONAL',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 9,
                  color: Color(0xFF856404),
                ),
              ),
            ),
          ],
        ),
        const Gap(8),
        TextField(
          controller: _ctrl,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (v) {
            final parsed = double.tryParse(v) ?? 0;
            widget.onTipChanged(parsed);
          },
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Color(0xFF040707),
          ),
          decoration: InputDecoration(
            prefixText: 'BDT  ',
            prefixStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF737780),
            ),
            hintText: '0.00',
            hintStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFFA0A4AD),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFF0156A7)),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const Gap(10),
        Row(
          children: _presets.map((amt) {
            final selected = widget.tip == amt.toDouble();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => _selectPreset(amt),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF0156A7) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? const Color(0xFF0156A7) : const Color(0xFFD2D3D6),
                    ),
                  ),
                  child: Text(
                    '+BDT $amt',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: selected ? Colors.white : const Color(0xFF040707),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatefulWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.riderTip,
    required this.deliveryCharge,
    required this.deliveryLoading,
    required this.deliveryError,
    required this.onRetryDelivery,
    required this.onDiscountChanged,
  });
  final double subtotal;
  final double riderTip;
  final double? deliveryCharge;
  final bool deliveryLoading;
  final String? deliveryError;
  final VoidCallback onRetryDelivery;
  final ValueChanged<int> onDiscountChanged;

  @override
  State<_SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<_SummaryCard> {
  final _couponCtrl = TextEditingController();
  String _appliedCoupon = '';
  int _discount = 0;

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  void _applyCoupon() {
    final code = _couponCtrl.text.trim().toUpperCase();
    if (code == 'DISCOUNT10') {
      final newDiscount = (widget.subtotal * 0.1).round();
      setState(() {
        _appliedCoupon = code;
        _discount = newDiscount;
      });
      widget.onDiscountChanged(newDiscount);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coupon applied! 10% discount')),
      );
    } else {
      setState(() {
        _appliedCoupon = '';
        _discount = 0;
      });
      widget.onDiscountChanged(0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid coupon code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deliveryAmt = widget.deliveryCharge ?? 0;
    final total = widget.subtotal + widget.riderTip + deliveryAmt - _discount;

    return DuareCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 10,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponCtrl,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color(0xFF040707),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Add Coupon',
                    hintStyle: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Color(0xFFA0A4AD),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Color(0xFF0156A7)),
                    ),
                    suffixIcon: _appliedCoupon.isNotEmpty
                        ? const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 20)
                        : null,
                  ),
                ),
              ),
              const Gap(8),
              SizedBox(
                width: 88,
                height: 52,
                child: PrimaryGradientButton(text: 'Apply', height: 52, borderRadius: 4, onPressed: _applyCoupon),
              ),
            ],
          ),
          if (_appliedCoupon.isNotEmpty) ...[
            const Gap(6),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '✓ "$_appliedCoupon" applied!',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
          const Gap(24),
          _row('Sub-Total', widget.subtotal.toInt()),
          const Gap(12),
          // Delivery charge row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery Charge',
                style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF585C67)),
              ),
              if (widget.deliveryLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0156A7)),
                )
              else if (widget.deliveryError != null)
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onRetryDelivery,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Gap(16),
                        Expanded(
                          child: Text(
                            widget.deliveryError!,
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontFamily: 'Manrope', fontSize: 11, color: Color(0xFFE53935)),
                          ),
                        ),
                        const Gap(4),
                        const Text(
                          'Retry',
                          style: TextStyle(fontFamily: 'Manrope', fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF0156A7)),
                        ),
                      ],
                    ),
                  ),
                )
              else if (widget.deliveryCharge == null)
                const Text(
                  'Add address',
                  style: TextStyle(fontFamily: 'Manrope', fontSize: 12, color: Color(0xFFF9A825)),
                )
              else if (widget.deliveryCharge == 0)
                const Text(
                  'FREE',
                  style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF2E7D32)),
                )
              else
                Text(
                  'BDT ${widget.deliveryCharge!.toInt()}',
                  style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF585C67)),
                ),
            ],
          ),
          if (_discount > 0) ...[
            const Gap(12),
            _discountRow('Discount', _discount),
          ],
          if (widget.riderTip > 0) ...[
            const Gap(12),
            _row('Rider Tips', widget.riderTip.toInt()),
          ],
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color(0xFF040707),
                    ),
                  ),
                  Text(
                    widget.deliveryCharge != null ? 'incl. delivery' : '+ delivery fee',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: Color(0xFF737780),
                    ),
                  ),
                ],
              ),
              Text(
                'BDT ${total.toInt()}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF040707),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF585C67))),
        Text('BDT $amount', style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF585C67))),
      ],
    );
  }

  Widget _discountRow(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w500, fontSize: 14, color: Color(0xFF585C67))),
        Text('- BDT $amount', style: const TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF2E7D32))),
      ],
    );
  }
}
