import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/add_to_cart_animation.dart';
import '../../../core/widgets/button/button.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../../core/widgets/toast.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../../medicine_home/widgets/medicine_cart_fab.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import '../models/mart_product_args.dart';

/// Mart product detail. No single-item backend endpoint exists (unlike
/// Medicine) — everything renders from the nav-extra [args] payload, no
/// fetch, no pull-to-refresh, no cold deep-link support.
class MartProductDetailScreen extends ConsumerStatefulWidget {
  const MartProductDetailScreen({super.key, this.args});

  final MartProductArgs? args;

  @override
  ConsumerState<MartProductDetailScreen> createState() =>
      _MartProductDetailScreenState();
}

class _MartProductDetailScreenState
    extends ConsumerState<MartProductDetailScreen> {
  int _quantity = 1;
  final _cartFabKey = GlobalKey();

  void _addToCart() {
    final args = widget.args!;
    ref.read(cartProvider.notifier).addItem(
          item: ApiMenuItemData(
            id: args.productId,
            name: args.name,
            description: args.description,
            image: args.image,
            images: args.image != null ? [args.image!] : const [],
            price: args.price,
            originalPrice: args.mrp,
            isAvailable: true,
          ),
          shopName: args.shopName,
          shopId: args.shopId,
          quantity: _quantity,
          selectedChoices: const {},
        );
    final screenSize = MediaQuery.of(context).size;
    runAddToCartAnimation(
      context: context,
      cartKey: _cartFabKey,
      startCenter: Offset(screenSize.width / 2, screenSize.height * 0.18),
      image: args.image,
      fallbackIcon: Icons.shopping_basket_outlined,
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
              child: _Details(args: args),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        args: args,
        quantity: _quantity,
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
        Icons.shopping_basket_outlined,
        size: context.dimensions.size.s64,
        color: colors.icon.secondary,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.args});

  final MartProductArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final hasDiscount = args.mrp != null && args.mrp! > args.price;
    final discount = hasDiscount
        ? (((args.mrp! - args.price) / args.mrp!) * 100).round()
        : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(args.name, style: text.titleLarge),
        Gap(dims.spacing.s8),
        Text(
          args.shopName,
          style: text.bodySmall.copyWith(color: colors.text.secondary),
        ),
        Gap(dims.spacing.s16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '৳${args.price.toStringAsFixed(0)}',
              style: text.displaySmall.copyWith(color: colors.brand.secondary),
            ),
            if (hasDiscount) ...[
              Gap(dims.spacing.s8),
              Text(
                '৳${args.mrp!.toStringAsFixed(0)}',
                style: text.bodySmall.copyWith(
                  color: colors.text.secondary,
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
                  color: colors.success.defaultValue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(dims.radius.r64),
                ),
                child: Text(
                  '-$discount%',
                  style: text.labelSmallSemiBold.copyWith(
                    color: colors.success.defaultValue,
                  ),
                ),
              ),
            ],
          ],
        ),
        if (args.description != null && args.description!.isNotEmpty) ...[
          Gap(dims.spacing.s24),
          Text('About this product', style: text.titleMedium),
          Gap(dims.spacing.s8),
          Text(
            args.description!,
            style: text.bodyMedium.copyWith(color: colors.text.secondary),
          ),
        ],
        Gap(dims.spacing.s16),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.args,
    required this.quantity,
    required this.onQuantity,
    required this.onAdd,
  });

  final MartProductArgs args;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final total = args.price * quantity;

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
              title: 'Add • ৳${total.toStringAsFixed(0)}',
              onPressed: onAdd,
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
                  style: text.bodyMedium.copyWith(
                    color: colors.text.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
