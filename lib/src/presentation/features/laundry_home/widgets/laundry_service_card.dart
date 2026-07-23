import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/toast.dart';
import '../../cart/riverpod/cart_provider.dart';
import '../models/laundry_service_args.dart';
import '../riverpod/laundry_provider.dart';

class LaundryServiceCard extends ConsumerStatefulWidget {
  const LaundryServiceCard({
    super.key,
    required this.item,
    this.compact = false,
  });

  final LaundryCatalogItem item;
  final bool compact;

  @override
  ConsumerState<LaundryServiceCard> createState() => _LaundryServiceCardState();
}

class _LaundryServiceCardState extends ConsumerState<LaundryServiceCard> {
  int _quantity = 1;

  void _open() {
    context.push(
      Routes.laundryService,
      extra: LaundryServiceArgs(
        service: widget.item.service,
        shopId: widget.item.shopId,
        shopName: widget.item.shopName,
      ),
    );
  }

  void _add() {
    final service = widget.item.service;
    ref
        .read(cartProvider.notifier)
        .addItem(
          item: service.toApiMenuItem(),
          shopName: widget.item.shopName,
          shopId: widget.item.shopId,
          quantity: _quantity,
          selectedChoices: const {},
        );
    Toast.success(context, 'Added $_quantity item${_quantity == 1 ? '' : 's'}');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final service = widget.item.service;

    return GestureDetector(
      onTap: _open,
      child: Container(
        width: widget.compact ? 172 : double.infinity,
        padding: EdgeInsets.all(dims.padding.p12),
        decoration: BoxDecoration(
          color: colors.background.surface,
          borderRadius: BorderRadius.circular(dims.radius.r16),
          border: Border.all(color: colors.border.divider),
          boxShadow: [
            BoxShadow(
              color: colors.elevation.elevationLow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: widget.compact
            ? _CompactContent(
                item: widget.item,
                quantity: _quantity,
                onQuantity: (value) => setState(() => _quantity = value),
                onAdd: _add,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconBox(category: service.itemCategory),
                  Gap(dims.spacing.s12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleSmall.copyWith(height: 1.18),
                        ),
                        Gap(dims.spacing.s4),
                        Text(
                          service.itemCategory ?? 'Laundry service',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: text.labelMedium.copyWith(
                            color: colors.text.secondary,
                          ),
                        ),
                        if (service.description != null &&
                            service.description!.isNotEmpty) ...[
                          Gap(dims.spacing.s6),
                          Text(
                            service.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelSmall.copyWith(
                              color: colors.text.secondary,
                              height: 1.25,
                            ),
                          ),
                        ],
                        Gap(dims.spacing.s12),
                        Row(
                          children: [
                            Text(
                              'Tk ${service.price.toStringAsFixed(0)}',
                              style: text.titleSmall.copyWith(
                                color: colors.text.primary,
                              ),
                            ),
                            const Spacer(),
                            _QuantityStepper(
                              quantity: _quantity,
                              onQuantity: (value) =>
                                  setState(() => _quantity = value),
                            ),
                            Gap(dims.spacing.s8),
                            _AddButton(onTap: _add),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  const _CompactContent({
    required this.item,
    required this.quantity,
    required this.onQuantity,
    required this.onAdd,
  });

  final LaundryCatalogItem item;
  final int quantity;
  final ValueChanged<int> onQuantity;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final service = item.service;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IconBox(category: service.itemCategory),
        Gap(dims.spacing.s12),
        Text(
          service.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: text.labelLarge.copyWith(height: 1.18),
        ),
        Gap(dims.spacing.s6),
        Text(
          'Tk ${service.price.toStringAsFixed(0)} / item',
          style: text.labelMedium.copyWith(color: colors.text.primary),
        ),
        const Spacer(),
        Row(
          children: [
            _QuantityStepper(quantity: quantity, onQuantity: onQuantity),
            const Spacer(),
            _AddButton(onTap: onAdd),
          ],
        ),
      ],
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({this.category});

  final String? category;

  IconData get _icon {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      width: dims.size.s48,
      height: dims.size.s48,
      decoration: BoxDecoration(
        color: colors.background.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(dims.radius.r12),
        border: Border.all(color: colors.border.divider),
      ),
      child: Icon(_icon, size: dims.size.s24, color: colors.icon.primary),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onQuantity});

  final int quantity;
  final ValueChanged<int> onQuantity;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    Widget button(IconData icon, VoidCallback? onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(dims.radius.r64),
        child: SizedBox(
          width: dims.size.s28,
          height: dims.size.s28,
          child: Icon(icon, size: dims.size.s16, color: colors.icon.primary),
        ),
      );
    }

    return Container(
      height: dims.size.s32,
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
          Text('$quantity', style: context.textStyle.labelMedium),
          button(Icons.add_rounded, () => onQuantity(quantity + 1)),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(dims.radius.r64),
      child: Container(
        width: dims.size.s32,
        height: dims.size.s32,
        decoration: BoxDecoration(
          color: colors.brand.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add_rounded,
          size: dims.size.s20,
          color: colors.icon.inverse,
        ),
      ),
    );
  }
}
