import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/button/button.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../../core/widgets/toast.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../../medicine_home/widgets/medicine_cart_fab.dart';
import '../models/laundry_service_args.dart';

class LaundryServiceDetailScreen extends ConsumerStatefulWidget {
  const LaundryServiceDetailScreen({super.key, this.args});

  final LaundryServiceArgs? args;

  @override
  ConsumerState<LaundryServiceDetailScreen> createState() =>
      _LaundryServiceDetailScreenState();
}

class _LaundryServiceDetailScreenState
    extends ConsumerState<LaundryServiceDetailScreen> {
  int _quantity = 1;

  void _addToCart() {
    final args = widget.args!;
    ref
        .read(cartProvider.notifier)
        .addItem(
          item: args.service.toApiMenuItem(),
          shopName: args.shopName,
          shopId: args.shopId,
          quantity: _quantity,
          selectedChoices: const {},
        );
    Toast.success(context, 'Added $_quantity item${_quantity == 1 ? '' : 's'}');
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final colors = context.color;

    if (args == null) {
      return Scaffold(
        backgroundColor: colors.background.surfaceContainerHigh,
        body: const SafeArea(child: _ErrorView()),
      );
    }

    return Scaffold(
      backgroundColor: colors.background.surfaceContainerHigh,
      floatingActionButton: const MedicineCartFab(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(category: args.service.itemCategory),
            Padding(
              padding: EdgeInsets.all(context.dimensions.padding.p16),
              child: _Details(args: args),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _BottomBar(
        price: args.service.price,
        quantity: _quantity,
        onQuantity: (value) => setState(() => _quantity = value),
        onAdd: _addToCart,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.category});

  final String? category;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHighest,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(dims.radius.r24),
          bottomRight: Radius.circular(dims.radius.r24),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              _iconFor(category),
              size: dims.size.s64,
              color: colors.icon.inverse,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + dims.padding.p8,
            left: dims.padding.p16,
            child: const RoundedBackButton.primary(),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String? category) {
    final value = category?.toLowerCase() ?? '';
    if (value.contains('dry')) return Icons.dry_cleaning_outlined;
    if (value.contains('iron') || value.contains('press')) {
      return Icons.iron_outlined;
    }
    if (value.contains('blanket') ||
        value.contains('bedsheet') ||
        value.contains('curtain')) {
      return Icons.king_bed_outlined;
    }
    return Icons.local_laundry_service_outlined;
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.args});

  final LaundryServiceArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final service = args.service;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(service.name, style: text.titleLarge),
        Gap(dims.spacing.s8),
        Text(
          service.itemCategory ?? 'Laundry service',
          style: text.bodySmall.copyWith(color: colors.text.secondary),
        ),
        Gap(dims.spacing.s16),
        Text(
          'Tk ${service.price.toStringAsFixed(0)} / item',
          style: text.displaySmall.copyWith(color: colors.text.primary),
        ),
        if (service.description != null && service.description!.isNotEmpty) ...[
          Gap(dims.spacing.s24),
          Text('About this service', style: text.titleMedium),
          Gap(dims.spacing.s8),
          Text(
            service.description!,
            style: text.bodyMedium.copyWith(color: colors.text.secondary),
          ),
        ],
        Gap(dims.spacing.s24),
        _InfoPanel(shopName: args.shopName),
      ],
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.shopName});

  final String shopName;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      padding: EdgeInsets.all(dims.padding.p16),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r16),
        border: Border.all(color: colors.border.divider),
      ),
      child: Column(
        children: [
          const _InfoRow(
            icon: Icons.two_wheeler_outlined,
            title: 'Pickup',
            value: 'ASAP after checkout',
          ),
          Gap(dims.spacing.s12),
          const _InfoRow(
            icon: Icons.schedule_outlined,
            title: 'Return',
            value: '7-14 days',
          ),
          Gap(dims.spacing.s12),
          _InfoRow(
            icon: Icons.home_work_outlined,
            title: 'Handled by',
            value: shopName,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return Row(
      children: [
        Icon(icon, color: colors.icon.primary, size: dims.size.s20),
        Gap(dims.spacing.s12),
        Text(title, style: text.labelLarge),
        Gap(dims.spacing.s8),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: text.labelMedium.copyWith(color: colors.text.secondary),
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.price,
    required this.quantity,
    required this.onQuantity,
    required this.onAdd,
  });

  final double price;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final total = price * quantity;

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
              title: 'Add · Tk ${total.toStringAsFixed(0)}',
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

    Widget button(IconData icon, VoidCallback? onTap) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dims.radius.r64),
      child: SizedBox(
        width: dims.size.s40,
        height: dims.size.s40,
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
          button(
            Icons.remove_rounded,
            quantity > 1 ? () => onQuantity(quantity - 1) : null,
          ),
          Text('$quantity', style: text.titleSmall),
          button(Icons.add_rounded, () => onQuantity(quantity + 1)),
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
                  "Couldn't open this service",
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
