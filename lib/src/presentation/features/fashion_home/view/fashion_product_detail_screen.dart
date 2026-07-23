import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/add_to_cart_animation.dart';
import '../../../core/widgets/button/button.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../../core/widgets/toast.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../../medicine_home/widgets/medicine_cart_fab.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import '../models/fashion_product.dart';
import '../models/fashion_product_args.dart';

/// Fashion product detail. No single-item backend endpoint — everything
/// renders from the nav-extra [args] payload (same as Mart), including the
/// colour×size combo matrix.
///
/// A colour then size must be picked before Add enables, and the charged
/// price is that exact combo's. If the payload has no combos (e.g. opened
/// from the generic Featured feed, which strips them), the screen hydrates
/// them from the shop's product container — the same whole-container
/// endpoint the storefront uses, no new backend surface. Only if the product
/// genuinely has none does it degrade to a plain base-price add.
class FashionProductDetailScreen extends ConsumerStatefulWidget {
  const FashionProductDetailScreen({super.key, this.args});

  final FashionProductArgs? args;

  @override
  ConsumerState<FashionProductDetailScreen> createState() =>
      _FashionProductDetailScreenState();
}

class _FashionProductDetailScreenState
    extends ConsumerState<FashionProductDetailScreen> {
  int _quantity = 1;
  String? _color;
  String? _size;
  final _cartFabKey = GlobalKey();

  late List<FashionVariantCombo> _combos;

  FashionProductArgs get _args => widget.args!;

  @override
  void initState() {
    super.initState();
    _combos = widget.args?.combos ?? const [];
    // Featured/best-selling taps arrive without combos — hydrate from the
    // shop's container so the picker still appears for variant products.
    if (_combos.isEmpty &&
        widget.args != null &&
        widget.args!.shopId.isNotEmpty &&
        widget.args!.productId.isNotEmpty) {
      _hydrateCombos();
    }
  }

  Future<void> _hydrateCombos() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('products/public/shop/${_args.shopId}');
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final items = data?['items'] as List<dynamic>?;
      final match = (items ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(FashionProduct.fromJson)
          .where((p) => p.id == _args.productId)
          .toList();
      if (!mounted || match.isEmpty || match.first.combos.isEmpty) return;
      setState(() => _combos = match.first.combos);
    } catch (_) {
      // Best-effort — stays a plain base-price add on failure.
    }
  }

  List<String> get _colors {
    final seen = <String>{};
    final out = <String>[];
    for (final c in _combos) {
      if (seen.add(c.color)) out.add(c.color);
    }
    return out;
  }

  /// Sizes available for the picked colour.
  List<FashionVariantCombo> get _sizesForColor {
    if (_color == null) return const [];
    return _combos.where((c) => c.color == _color).toList();
  }

  FashionVariantCombo? get _selectedCombo {
    if (_color == null || _size == null) return null;
    for (final c in _combos) {
      if (c.color == _color && c.size == _size) return c;
    }
    return null;
  }

  bool get _hasCombos => _combos.isNotEmpty;

  /// The price to charge: selected combo if chosen, else base "from" price.
  double get _unitPrice => _selectedCombo?.price ?? _args.price;

  bool get _canAdd => !_hasCombos || _selectedCombo != null;

  void _addToCart() {
    final combo = _selectedCombo;
    // Fashion flows the exact combo through the shared cart's variant slot —
    // distinct id ⇒ its own cart line, its price is what checkout charges.
    final variant = combo == null
        ? null
        : MenuItemVariant(
            id: combo.id.isNotEmpty ? combo.id : combo.label,
            name: combo.label,
            price: combo.price,
          );

    ref
        .read(cartProvider.notifier)
        .addItem(
          item: ApiMenuItemData(
            id: _args.productId,
            name: _args.name,
            description: _args.description,
            image: _args.image,
            images: _args.images,
            price: _args.price,
            originalPrice: _args.mrp,
            isAvailable: true,
          ),
          shopName: _args.shopName,
          shopId: _args.shopId,
          quantity: _quantity,
          selectedVariant: variant,
          selectedChoices: const {},
        );

    final screenSize = MediaQuery.of(context).size;
    runAddToCartAnimation(
      context: context,
      cartKey: _cartFabKey,
      startCenter: Offset(screenSize.width / 2, screenSize.height * 0.18),
      image: _args.image,
      fallbackIcon: Icons.checkroom_outlined,
    );
    Toast.success(context, 'Added $_quantity to cart');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final args = widget.args;

    if (args == null) {
      return Scaffold(
        backgroundColor: colors.background.surfaceContainerHigh,
        body: const SafeArea(child: _ErrorView()),
      );
    }

    return Scaffold(
      backgroundColor: colors.background.surfaceContainerHigh,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ImageHeader(image: args.image),
            Padding(
              padding: EdgeInsets.all(context.dimensions.padding.p16),
              child: _Details(
                args: args,
                hasCombos: _hasCombos,
                colors: _colors,
                selectedColor: _color,
                selectedSize: _size,
                sizesForColor: _sizesForColor,
                selectedCombo: _selectedCombo,
                onColor: (c) => setState(() {
                  _color = c;
                  _size = null; // reset size when colour changes
                }),
                onSize: (s) => setState(() => _size = s),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        unitPrice: _unitPrice,
        quantity: _quantity,
        canAdd: _canAdd,
        needsChoice: _hasCombos && _selectedCombo == null,
        onQuantity: (q) => setState(() => _quantity = q),
        onAdd: _addToCart,
      ),
      floatingActionButton: MedicineCartFab(key: _cartFabKey),
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final radius = BorderRadius.only(
      bottomLeft: Radius.circular(dims.radius.r24),
      bottomRight: Radius.circular(dims.radius.r24),
    );

    return Stack(
      children: [
        ClipRRect(
          borderRadius: radius,
          child: Container(
            width: double.infinity,
            height: 300,
            color: colors.background.surfaceContainerHighDim,
            child: image != null && image!.isNotEmpty
                ? Image.network(
                    image!,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    cacheWidth: 1000,
                    errorBuilder: (_, _, _) => _placeholder(context),
                  )
                : _placeholder(context),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + dims.padding.p8,
          left: dims.padding.p16,
          child: const RoundedBackButton.primary(),
        ),
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    final colors = context.color;
    return Center(
      child: Icon(
        Icons.checkroom_outlined,
        size: context.dimensions.size.s64,
        color: colors.icon.secondary,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({
    required this.args,
    required this.hasCombos,
    required this.colors,
    required this.selectedColor,
    required this.selectedSize,
    required this.sizesForColor,
    required this.selectedCombo,
    required this.onColor,
    required this.onSize,
  });

  final FashionProductArgs args;
  final bool hasCombos;
  final List<String> colors;
  final String? selectedColor;
  final String? selectedSize;
  final List<FashionVariantCombo> sizesForColor;
  final FashionVariantCombo? selectedCombo;
  final ValueChanged<String> onColor;
  final ValueChanged<String> onSize;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    // Price shown: the selected combo, else "from" base price.
    final displayPrice = selectedCombo?.price ?? args.price;
    final displayMrp = selectedCombo?.mrp ?? args.mrp;
    final hasDiscount = displayMrp != null && displayMrp > displayPrice;
    final discount = hasDiscount
        ? (((displayMrp - displayPrice) / displayMrp) * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(args.name, style: text.titleLarge),
        Gap(dims.spacing.s8),
        Text(
          args.shopName,
          style: text.bodySmall.copyWith(color: c.text.secondary),
        ),
        Gap(dims.spacing.s16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (hasCombos && selectedCombo == null) ...[
              Text(
                'from ',
                style: text.bodySmall.copyWith(color: c.text.secondary),
              ),
            ],
            Text(
              '৳${displayPrice.toStringAsFixed(0)}',
              style: text.displaySmall.copyWith(color: c.brand.secondary),
            ),
            if (hasDiscount) ...[
              Gap(dims.spacing.s8),
              Text(
                '৳${displayMrp.toStringAsFixed(0)}',
                style: text.bodySmall.copyWith(
                  color: c.text.secondary,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              Gap(dims.spacing.s8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dims.padding.p8,
                  vertical: dims.padding.p4,
                ),
                decoration: BoxDecoration(
                  color: c.success.defaultValue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(dims.radius.r64),
                ),
                child: Text(
                  '-$discount%',
                  style: text.labelSmallSemiBold.copyWith(
                    color: c.success.defaultValue,
                  ),
                ),
              ),
            ],
          ],
        ),

        // Colour picker
        if (colors.isNotEmpty) ...[
          Gap(dims.spacing.s24),
          Text('Colour', style: text.titleMedium),
          Gap(dims.spacing.s12),
          Wrap(
            spacing: dims.spacing.s8,
            runSpacing: dims.spacing.s8,
            children: [
              for (final color in colors)
                _ChoiceChip(
                  label: color,
                  selected: color == selectedColor,
                  onTap: () => onColor(color),
                ),
            ],
          ),
        ],

        // Size picker (depends on chosen colour)
        if (selectedColor != null) ...[
          Gap(dims.spacing.s16),
          Text('Size', style: text.titleMedium),
          Gap(dims.spacing.s12),
          Wrap(
            spacing: dims.spacing.s8,
            runSpacing: dims.spacing.s8,
            children: [
              for (final combo in sizesForColor)
                _ChoiceChip(
                  label: combo.size,
                  selected: combo.size == selectedSize,
                  onTap: () => onSize(combo.size),
                ),
            ],
          ),
        ],

        if (args.description != null && args.description!.isNotEmpty) ...[
          Gap(dims.spacing.s24),
          Text('About this product', style: text.titleMedium),
          Gap(dims.spacing.s8),
          Text(
            args.description!,
            style: text.bodyMedium.copyWith(color: c.text.secondary),
          ),
        ],
        Gap(dims.spacing.s16),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dims.padding.p16,
          vertical: dims.padding.p8,
        ),
        decoration: BoxDecoration(
          color: selected
              ? c.brand.primary.withValues(alpha: 0.1)
              : c.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r64),
          border: Border.all(
            color: selected ? c.brand.primary : c.border.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: text.labelMedium.copyWith(
            color: selected ? c.brand.primary : c.text.primary,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.unitPrice,
    required this.quantity,
    required this.canAdd,
    required this.needsChoice,
    required this.onQuantity,
    required this.onAdd,
  });

  final double unitPrice;
  final int quantity;
  final bool canAdd;
  final bool needsChoice;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final total = unitPrice * quantity;

    return Container(
      padding: EdgeInsets.fromLTRB(
        dims.padding.p16,
        dims.padding.p12,
        dims.padding.p16,
        dims.padding.p12 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: colors.background.surface,
        boxShadow: [
          BoxShadow(
            color: colors.elevation.elevationLow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _QtyStepper(quantity: quantity, onQuantity: onQuantity),
          Gap(dims.spacing.s16),
          Expanded(
            child: PrimaryButton.comfortable(
              title: needsChoice
                  ? 'Select colour & size'
                  : 'Add • ৳${total.toStringAsFixed(0)}',
              onPressed: canAdd ? onAdd : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({required this.quantity, required this.onQuantity});

  final int quantity;
  final ValueChanged<int> onQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dims.radius.r64),
      child: Container(
        width: dims.size.s40,
        height: dims.size.s40,
        alignment: Alignment.center,
        child: Icon(icon, size: dims.size.s20, color: colors.icon.primary),
      ),
    );

    return Container(
      height: dims.size.s56,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(dims.radius.r64),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          btn(
            Icons.remove_rounded,
            quantity > 1 ? () => onQuantity(quantity - 1) : null,
          ),
          Text('$quantity', style: text.titleSmall),
          btn(Icons.add_rounded, () => onQuantity(quantity + 1)),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(dims.padding.p16),
            child: const RoundedBackButton.secondary(),
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: dims.size.s48,
                  color: colors.icon.secondary,
                ),
                Gap(dims.spacing.s12),
                Text(
                  "Couldn't open this product",
                  style: text.bodyMedium.copyWith(color: colors.text.secondary),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
