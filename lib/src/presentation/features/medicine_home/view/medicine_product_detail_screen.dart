import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/button/button.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../../core/widgets/toast.dart';
import '../../../core/router/routes.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../models/medicine_product_args.dart';
import '../models/medicine_product_detail.dart';
import '../riverpod/medicine_product_detail_provider.dart';

/// Medicine product detail page. Loads the full product by id, shows specs +
/// medical info, and adds to cart with a quantity stepper.
class MedicineProductDetailScreen extends ConsumerStatefulWidget {
  const MedicineProductDetailScreen({super.key, required this.args});

  final MedicineProductArgs args;

  @override
  ConsumerState<MedicineProductDetailScreen> createState() =>
      _MedicineProductDetailScreenState();
}

class _MedicineProductDetailScreenState
    extends ConsumerState<MedicineProductDetailScreen> {
  int _quantity = 1;

  void _addToCart(MedicineProductDetail product) {
    ref.read(cartProvider.notifier).addItem(
          item: product.toApiMenuItem(),
          shopName: widget.args.shopName,
          shopId: product.shopId.isNotEmpty
              ? product.shopId
              : widget.args.shopId,
          quantity: _quantity,
          selectedChoices: const {},
        );
    Toast.success(context, 'Added $_quantity to cart');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final async = ref.watch(
      medicineProductDetailProvider(widget.args.productId),
    );

    return Scaffold(
      backgroundColor: colors.background.surfaceContainerHigh,
      body: async.when(
        loading: () => _LoadingView(args: widget.args),
        error: (_, _) => _ErrorView(),
        data: (product) => _LoadedView(
          product: product,
          quantity: _quantity,
          onQuantity: (q) => setState(() => _quantity = q),
          onAdd: () => _addToCart(product),
        ),
      ),
    );
  }
}

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.product,
    required this.quantity,
    required this.onQuantity,
    required this.onAdd,
  });

  final MedicineProductDetail product;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final dims = context.dimensions;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ImageHeader(image: product.image),
                Padding(
                  padding: EdgeInsets.all(dims.padding.p16),
                  child: _Details(product: product),
                ),
              ],
            ),
          ),
        ),
        _BottomBar(
          product: product,
          quantity: quantity,
          onQuantity: onQuantity,
          onAdd: onAdd,
        ),
      ],
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
        Positioned(
          top: MediaQuery.of(context).padding.top + dims.padding.p8,
          right: dims.padding.p16,
          child: const _HeaderCartButton(),
        ),
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    final colors = context.color;
    return Center(
      child: Icon(
        Icons.medication_outlined,
        size: context.dimensions.size.s64,
        color: colors.icon.secondary,
      ),
    );
  }
}

/// Cart shortcut on the product image header (top-right) with a count badge.
class _HeaderCartButton extends ConsumerWidget {
  const _HeaderCartButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final count = ref
        .watch(cartProvider)
        .fold<int>(0, (sum, c) => sum + c.quantity);

    return GestureDetector(
      onTap: () => context.push(Routes.cart),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: dims.size.s40,
            height: dims.size.s40,
            decoration: BoxDecoration(
              color: colors.background.surfaceContainer,
              borderRadius: BorderRadius.circular(dims.radius.r12),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              color: colors.icon.primary,
              size: dims.size.s20,
            ),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: dims.size.s20,
                height: dims.size.s20,
                decoration: BoxDecoration(
                  color: colors.brand.secondary,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.icon.inverse, width: 1.5),
                ),
                alignment: Alignment.center,
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: text.labelSmall.copyWith(
                    color: colors.icon.inverse,
                    fontWeight: FontWeight.w700,
                    fontSize: 9,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.product});

  final MedicineProductDetail product;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(product.name, style: text.titleLarge)),
            Gap(dims.spacing.s12),
            _StockBadge(inStock: product.inStock),
          ],
        ),
        if (product.companyName != null &&
            product.companyName!.isNotEmpty) ...[
          Gap(dims.spacing.s4),
          Text(
            product.companyName!,
            style: text.bodySmall.copyWith(color: colors.text.secondary),
          ),
        ],
        if (product.genericName != null &&
            product.genericName!.isNotEmpty) ...[
          Gap(dims.spacing.s8),
          _LabeledRow(label: 'Generic', value: product.genericName!),
        ],
        if (product.specs.isNotEmpty) ...[
          Gap(dims.spacing.s12),
          Wrap(
            spacing: dims.spacing.s8,
            runSpacing: dims.spacing.s8,
            children: [
              for (final s in product.specs)
                _SpecChip(label: s.label, value: s.value),
            ],
          ),
        ],
        Gap(dims.spacing.s16),
        _PriceRow(product: product),
        if (product.description != null &&
            product.description!.isNotEmpty) ...[
          Gap(dims.spacing.s24),
          _Section(
            title: 'About this product',
            body: product.description!,
          ),
        ],
        if (product.medicalInfo.isNotEmpty) ...[
          Gap(dims.spacing.s24),
          Text('Medical Information', style: text.titleMedium),
          Gap(dims.spacing.s12),
          _MedicalCard(info: product.medicalInfo),
        ],
        Gap(dims.spacing.s16),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.product});

  final MedicineProductDetail product;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    final discount = product.hasDiscount
        ? (((product.mrp! - product.price) / product.mrp!) * 100).round()
        : 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '৳${product.price.toStringAsFixed(0)}',
          style: text.displaySmall.copyWith(color: colors.brand.secondary),
        ),
        if (product.hasDiscount) ...[
          Gap(dims.spacing.s8),
          Text(
            '৳${product.mrp!.toStringAsFixed(0)}',
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
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.inStock});

  final bool inStock;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final color =
        inStock ? colors.success.defaultValue : colors.error.defaultValue;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dims.padding.p8,
        vertical: dims.padding.p4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(dims.radius.r64),
      ),
      child: Text(
        inStock ? 'In stock' : 'Out of stock',
        style: text.labelSmallSemiBold.copyWith(color: color),
      ),
    );
  }
}

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dims.padding.p12,
        vertical: dims.padding.p8,
      ),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r64),
        border: Border.all(color: colors.border.divider),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: text.labelMedium.copyWith(color: colors.text.secondary),
            ),
            TextSpan(text: value, style: text.labelLarge),
          ],
        ),
      ),
    );
  }
}

class _LabeledRow extends StatelessWidget {
  const _LabeledRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: text.bodySmall.copyWith(color: colors.text.secondary),
        ),
        Gap(dims.spacing.s4),
        Expanded(child: Text(value, style: text.bodySmall)),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: text.titleMedium),
        Gap(dims.spacing.s8),
        Text(
          body,
          style: text.bodyMedium.copyWith(color: colors.text.secondary),
        ),
      ],
    );
  }
}

class _MedicalCard extends StatelessWidget {
  const _MedicalCard({required this.info});

  final List<({String label, String body})> info;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dims.padding.p16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < info.length; i++) ...[
            if (i > 0) ...[
              Gap(dims.spacing.s12),
              Divider(height: 1, color: colors.border.divider),
              Gap(dims.spacing.s12),
            ],
            Text(info[i].label, style: text.labelLarge),
            Gap(dims.spacing.s4),
            Text(
              info[i].body,
              style: text.bodyMedium.copyWith(color: colors.text.secondary),
            ),
          ],
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.product,
    required this.quantity,
    required this.onQuantity,
    required this.onAdd,
  });

  final MedicineProductDetail product;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final total = product.price * quantity;

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
          _QtyStepper(
            quantity: quantity,
            enabled: product.inStock,
            onQuantity: onQuantity,
          ),
          Gap(dims.spacing.s16),
          Expanded(
            child: PrimaryButton.comfortable(
              title: product.inStock
                  ? 'Add • ৳${total.toStringAsFixed(0)}'
                  : 'Unavailable',
              onPressed: product.inStock ? onAdd : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.quantity,
    required this.enabled,
    required this.onQuantity,
  });

  final int quantity;
  final bool enabled;
  final ValueChanged<int> onQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
      onTap: enabled ? onTap : null,
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

class _LoadingView extends StatelessWidget {
  const _LoadingView({required this.args});

  final MedicineProductArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    Widget bar(double w, double h) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighDim,
        borderRadius: BorderRadius.circular(dims.radius.r4),
      ),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageHeader(image: args.image),
          Padding(
            padding: EdgeInsets.all(dims.padding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bar(220, 22),
                Gap(dims.spacing.s12),
                bar(140, 16),
                Gap(dims.spacing.s24),
                bar(120, 28),
                Gap(dims.spacing.s24),
                bar(double.infinity, 14),
                Gap(dims.spacing.s8),
                bar(double.infinity, 14),
                Gap(dims.spacing.s8),
                bar(200, 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return SafeArea(
      child: Column(
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
                    "Couldn't load this product",
                    style: text.bodyMedium.copyWith(
                      color: colors.text.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
