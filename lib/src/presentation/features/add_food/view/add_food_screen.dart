import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import '../../cart/riverpod/cart_provider.dart';

class AddFoodArgs {
  const AddFoodArgs({
    required this.item,
    required this.shopName,
    required this.shopId,
  });

  final ApiMenuItemData item;
  final String shopName;
  final String shopId;
}

class AddFoodScreen extends ConsumerStatefulWidget {
  const AddFoodScreen({super.key, required this.args});

  final AddFoodArgs args;

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  int _imageIndex = 0;
  int _quantity = 1;
  MenuItemVariant? _selectedVariant;
  final Map<String, String> _selectedChoices = {};

  ApiMenuItemData get item => widget.args.item;

  List<String> get _images {
    final all = item.images.where((u) => u.isNotEmpty).toList();
    if (all.isEmpty && item.image != null && item.image!.isNotEmpty) {
      return [item.image!];
    }
    return all;
  }

  double get _basePrice {
    if (_selectedVariant != null) return _selectedVariant!.price;
    return item.price;
  }

  double get _optionsTotal {
    double total = 0;
    for (final opt in item.options) {
      final choiceId = _selectedChoices[opt.id];
      if (choiceId != null) {
        final choice = opt.choices.where((c) => c.id == choiceId).firstOrNull;
        if (choice != null) total += choice.price;
      }
    }
    return total;
  }

  double get _totalPrice => (_basePrice + _optionsTotal) * _quantity;

  @override
  void initState() {
    super.initState();
    if (item.variants.isNotEmpty) {
      _selectedVariant = item.variants.firstWhere(
        (v) => v.isDefault,
        orElse: () => item.variants.first,
      );
    }
    for (final opt in item.options) {
      final def = opt.choices.where((c) => c.isDefault).firstOrNull;
      if (def != null) _selectedChoices[opt.id] = def.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = _images;
    final cartItems = ref.watch(cartProvider);
    final cartCount = cartItems.fold<int>(0, (sum, c) => sum + c.quantity);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageSection(context, images),
                      _buildContent(context),
                    ],
                  ),
                ),
              ),
              _buildBottomBar(context),
            ],
          ),

          // Floating cart button
          if (cartCount > 0)
            Positioned(
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 80,
              child: GestureDetector(
                onTap: () => context.push(Routes.cart),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-0.24, -0.24),
                      end: Alignment(0.99, 0.99),
                      colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(1, 86, 167, 0.35),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 24),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF4444),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context, List<String> images) {
    return Container(
      width: double.infinity,
      height: 307,
      decoration: const BoxDecoration(
        color: Color(0xFFE8E8E8),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          // Full-bleed cover image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: images.isNotEmpty
                ? Image.network(
                    images[_imageIndex],
                    width: double.infinity,
                    height: 307,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFE0E0E0),
                      child: const Icon(Icons.restaurant, size: 64, color: Color(0xFFC0C0C0)),
                    ),
                  )
                : Container(
                    color: const Color(0xFFE0E0E0),
                    child: const Icon(Icons.restaurant, size: 64, color: Color(0xFFC0C0C0)),
                  ),
          ),

          // Dark gradient overlay for legibility
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x44000000), Color(0x00000000), Color(0x55000000)],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: const RoundedBackButton.primary(),
          ),

          // Favourite button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 18,
                color: Color(0xFF040707),
              ),
            ),
          ),

          // Left nav arrow
          if (images.length > 1)
            Positioned(
              left: 16,
              top: 0,
              bottom: 40,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_imageIndex > 0) setState(() => _imageIndex--);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_left, color: Color(0xFF1C1B1F), size: 24),
                  ),
                ),
              ),
            ),

          // Right nav arrow
          if (images.length > 1)
            Positioned(
              right: 16,
              top: 0,
              bottom: 40,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (_imageIndex < images.length - 1) setState(() => _imageIndex++);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(-0.27, -0.27),
                        radius: 1.0,
                        colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),

          // Dot indicators
          if (images.length > 1)
            Positioned(
              bottom: 14,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (i) {
                  final active = i == _imageIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(4),

          // Name row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.name,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1.28,
                    letterSpacing: -1,
                    color: Color(0xFF040707),
                  ),
                ),
              ),
            ],
          ),
          const Gap(6),

          // Price row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'BDT ${_totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  height: 1.28,
                  color: Color(0xFF0156A7),
                ),
              ),
              if (item.originalPrice != null && item.originalPrice! > item.price) ...[
                const Gap(8),
                Text(
                  'BDT ${item.originalPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFFA0A4AD),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const Gap(4),

          Text(
            widget.args.shopName,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF737780),
            ),
          ),
          const Gap(16),

          // Meta info: prep time + calories
          if (item.preparationTime != null || item.calories != null)
            _buildMetaInfoRow(),

          // Dietary info badges
          if (item.dietaryInfo.isNotEmpty) ...[
            _buildDietaryBadges(),
            const Gap(12),
          ],

          // Allergens
          if (item.allergens.isNotEmpty) ...[
            _buildAllergens(),
            const Gap(12),
          ],

          // Variants dropdown
          if (item.variants.isNotEmpty) ...[
            _buildVariantDropdown(),
            const Gap(16),
          ],

          // Description
          if (item.description != null && item.description!.isNotEmpty) ...[
            const Text(
              'Description',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                height: 1.28,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(12),
            Text(
              item.description!,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w500,
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(16),
          ],

          // Options
          ...item.options.map((opt) => _buildOptionGroup(opt)),

          // Quantity
          _buildQuantityRow(),
          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildMetaInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          if (item.preparationTime != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule_outlined, size: 16, color: Color(0xFF737780)),
                const Gap(4),
                Text(
                  '${item.preparationTime} min',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xFF737780),
                  ),
                ),
              ],
            ),
          if (item.calories != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bolt, size: 16, color: Color(0xFF737780)),
                const Gap(4),
                Text(
                  '${item.calories} cal',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xFF737780),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDietaryBadges() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: item.dietaryInfo.map((tag) {
        final isVegetarian = tag.toLowerCase().contains('vegetarian') ||
            tag.toLowerCase().contains('veg');
        final isSpicy = tag.toLowerCase().contains('spicy') ||
            tag.toLowerCase().contains('hot');
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isVegetarian
                ? const Color(0xFFE8F5E9)
                : isSpicy
                    ? const Color(0xFFFFF3E0)
                    : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isVegetarian
                  ? const Color(0xFF81C784)
                  : isSpicy
                      ? const Color(0xFFFF9800)
                      : const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isVegetarian
                    ? Icons.eco_outlined
                    : isSpicy
                        ? Icons.local_fire_department_outlined
                        : Icons.info_outline,
                size: 14,
                color: isVegetarian
                    ? const Color(0xFF2E7D32)
                    : isSpicy
                        ? const Color(0xFFE65100)
                        : const Color(0xFF737780),
              ),
              const Gap(4),
              Text(
                tag,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: isVegetarian
                      ? const Color(0xFF2E7D32)
                      : isSpicy
                          ? const Color(0xFFE65100)
                          : const Color(0xFF737780),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAllergens() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Allergens',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Color(0xFF585C67),
          ),
        ),
        const Gap(6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: item.allergens.map((a) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFEF9A9A)),
              ),
              child: Text(
                a,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Color(0xFFC62828),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVariantDropdown() {
    return GestureDetector(
      onTap: () => _showVariantSheet(),
      child: Container(
        width: double.infinity,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD2D3D6)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _selectedVariant?.name ?? 'Size',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  letterSpacing: -0.5,
                  color: _selectedVariant != null
                      ? const Color(0xFF040707)
                      : const Color(0xFF585C67),
                ),
              ),
            ),
            const Icon(Icons.expand_more, color: Color(0xFF1C1B1F), size: 24),
          ],
        ),
      ),
    );
  }

  void _showVariantSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Size',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(16),
            ...item.variants.map(
              (v) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio<String>(
                  value: v.id,
                  groupValue: _selectedVariant?.id,
                  activeColor: const Color(0xFF0156A7),
                  onChanged: (val) {
                    setState(() {
                      _selectedVariant = item.variants.firstWhere((x) => x.id == val);
                    });
                    Navigator.pop(context);
                  },
                ),
                title: Text(
                  v.name,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF040707),
                  ),
                ),
                trailing: Text(
                  'BDT ${v.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF585C67),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionGroup(MenuItemOption opt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          opt.name,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.28,
            color: Color(0xFF040707),
          ),
        ),
        const Gap(12),
        ...opt.choices.map((choice) {
          final selected = _selectedChoices[opt.id] == choice.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (opt.type == 'radio') {
                    _selectedChoices[opt.id] = choice.id;
                  } else {
                    if (selected) {
                      _selectedChoices.remove(opt.id);
                    } else {
                      _selectedChoices[opt.id] = choice.id;
                    }
                  }
                });
              },
              child: Row(
                children: [
                  if (opt.type == 'radio')
                    Radio<bool>(
                      value: true,
                      groupValue: selected ? true : null,
                      activeColor: const Color(0xFF0156A7),
                      onChanged: (_) {
                        setState(() => _selectedChoices[opt.id] = choice.id);
                      },
                    )
                  else
                    Checkbox(
                      value: selected,
                      activeColor: const Color(0xFF0156A7),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            _selectedChoices[opt.id] = choice.id;
                          } else {
                            _selectedChoices.remove(opt.id);
                          }
                        });
                      },
                    ),
                  const Gap(0),
                  Expanded(
                    child: Text(
                      choice.name,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.5,
                        color: Color(0xFF040707),
                      ),
                    ),
                  ),
                  if (choice.price > 0)
                    Text(
                      '+ BDT ${choice.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.56,
                        color: Color(0xFF585C67),
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
        const Gap(4),
      ],
    );
  }

  Widget _buildQuantityRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Select Quantity',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.28,
            color: Color(0xFF040707),
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (_quantity > 1) setState(() => _quantity--);
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0156A7).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove, color: Color(0xFF0156A7), size: 20),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Text(
                '$_quantity',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Color(0xFF040707),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => setState(() => _quantity++),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.27, -0.27),
                    radius: 1.0,
                    colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      color: Colors.white,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment(-0.27, -0.27),
              radius: 1.5,
              colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextButton(
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(
                item: item,
                shopName: widget.args.shopName,
                shopId: widget.args.shopId,
                quantity: _quantity,
                selectedVariant: _selectedVariant,
                selectedChoices: _selectedChoices,
              );
              _runAddToCartAnimation(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add To Cart',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    letterSpacing: -0.5,
                    color: Colors.white,
                  ),
                ),
                Icon(Icons.trending_flat, color: Colors.white, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _runAddToCartAnimation(BuildContext context) {
    final overlayState = Overlay.of(context);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final image = _images.isNotEmpty ? _images[_imageIndex] : null;

    // Start: image center area
    const startSize = 180.0;
    final startLeft = size.width / 2 - startSize / 2;
    final startTop = size.height * 0.18;

    // End: floating cart button (right:16, bottom: padding.bottom+80, size:56)
    const endSize = 56.0;
    final endLeft = size.width - 16 - endSize;
    final endTop = size.height - padding.bottom - 80 - endSize;

    OverlayEntry? entry;
    entry = OverlayEntry(
      builder: (context) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
          onEnd: () => entry?.remove(),
          builder: (context, value, child) {
            final currentSize = startSize + (endSize - startSize) * value;
            final top = startTop + (endTop - startTop) * value;
            final left = startLeft + (endLeft - startLeft) * value;
            final opacity = value > 0.85 ? 1.0 - (value - 0.85) / 0.15 : 1.0;
            return Positioned(
              top: top,
              left: left,
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: currentSize,
                  height: currentSize,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 12)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(currentSize / 2),
                    child: image != null
                        ? Image.network(image, fit: BoxFit.cover)
                        : const Icon(Icons.restaurant, color: Color(0xFFC0C0C0)),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlayState.insert(entry);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to cart!'),
        backgroundColor: const Color(0xFF0156A7),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
