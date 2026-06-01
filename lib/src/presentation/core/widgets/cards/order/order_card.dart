import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../models/order_ui_model.dart';
import '../../../riverpod/order_actions/undo_order_provider.dart';
import '../../../riverpod/order_actions/update_order_provider.dart';
import '../../../router/routes.dart';
import '../../../theme/theme.dart';
import '../../../widgets/toast.dart';
import 'completed_order_action.dart';
import 'customer_info.dart';
import 'new_order_actions.dart';
import 'reject_order_dialog.dart';
import 'restaurant_info.dart';

enum OrderCardVariant { newOrder, completed, rejected }

class OrderCard extends ConsumerStatefulWidget {
  const OrderCard({super.key, required this.variant, required this.model});

  final OrderCardVariant variant;
  final OrderUIModel model;

  @override
  ConsumerState<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<OrderCard> {
  /// Guards toast feedback to this instance only.
  /// Both home and order tabs keep [OrderCard]s alive simultaneously via
  /// [StatefulShellRoute.indexedStack], meaning two instances share the same
  /// [updateOrderProvider]. Without this flag, both [ref.listen] callbacks
  /// would fire and show duplicate toasts.
  bool _updateDidTrigger = false;
  bool _undoDidTrigger = false;

  UpdateOrderStatus get _updateStatus => switch (widget.model.status) {
    OrderStatus.pending => UpdateOrderStatus.accept,
    OrderStatus.assigned => UpdateOrderStatus.pickUp,
    OrderStatus.pickedUp => UpdateOrderStatus.deliver,
  };

  UpdateOrderProvider get _provider =>
      updateOrderProvider(widget.model.id, _updateStatus);

  @override
  void initState() {
    super.initState();

    ref.listenManual(_provider, (_, next) {
      if (!_updateDidTrigger || next is AsyncLoading) return;
      _updateDidTrigger = false;

      if (next is AsyncData && next.value == true) {
        final message = switch (widget.model.status) {
          OrderStatus.pending => context.locale.orderAccepted,
          OrderStatus.assigned => context.locale.orderPickedUp,
          OrderStatus.pickedUp => context.locale.orderDelivered,
        };
        Toast.success(context, message);
      }

      if (next is AsyncError) {
        Toast.error(context, next.error.toString());
      }
    });

    ref.listenManual(undoOrderProvider(widget.model.id), (_, next) {
      if (!_undoDidTrigger || next is AsyncLoading) return;
      _undoDidTrigger = false;

      if (next is AsyncData && next.value == true) {
        Toast.success(context, context.locale.orderUndone);
      }

      if (next is AsyncError) {
        Toast.error(context, next.error.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        Routes.orderDetails,
        pathParameters: {'id': widget.model.id},
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.85,
        padding: EdgeInsets.all(context.dimensions.padding.p10),
        decoration: BoxDecoration(
          color: context.color.background.surface,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r10),
          boxShadow: [
            BoxShadow(
              color: context.color.elevation.elevationLow,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          spacing: context.dimensions.spacing.s12,
          mainAxisSize: MainAxisSize.min,
          children: [
            RestaurantInfo(
              name: widget.model.shopName,
              location: widget.model.shopLocation,
              distance: widget.model.distance,
            ),
            CustomerInfo(
              name: widget.model.customerName,
              orderId: widget.model.orderDisplayId,
              address: widget.model.deliveryAddress,
              time: widget.model.deliveryTime,
              profileImage: widget.model.customerProfileImage,
            ),
            if (widget.variant == .newOrder) ...[
              NewOrderActions(
                orderId: widget.model.id,
                orderStatus: widget.model.status,
                updateStatus: _updateStatus,
                onAction: _executeAction,
                onRejectPressed: _openRejectDialog,
                onUndoPressed: _undoOrder,
              ),
            ] else if (widget.variant == .completed) ...[
              const CompletedOrderAction(),
            ],
          ],
        ),
      ),
    );
  }

  void _executeAction() {
    _updateDidTrigger = true;
    ref.read(_provider.notifier).execute();
  }

  void _openRejectDialog() {
    RejectOrderDialog.show(context, orderId: widget.model.id);
  }

  void _undoOrder() {
    _undoDidTrigger = true;
    ref.read(undoOrderProvider(widget.model.id).notifier).undo();
  }
}
