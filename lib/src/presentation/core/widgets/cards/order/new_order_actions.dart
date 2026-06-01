import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../models/order_ui_model.dart';
import '../../../riverpod/order_actions/undo_order_provider.dart';
import '../../../riverpod/order_actions/update_order_provider.dart';
import '../../../theme/theme.dart';
import '../../button/reject_button.dart';
import '../../button/swipe_to_action_button.dart';
import '../../button/undo_button.dart';
import '../../circular_loading_indicator.dart';

class NewOrderActions extends ConsumerWidget {
  const NewOrderActions({
    super.key,
    required this.orderId,
    required this.orderStatus,
    required this.updateStatus,
    required this.onAction,
    required this.onRejectPressed,
    required this.onUndoPressed,
  });

  final String orderId;
  final OrderStatus orderStatus;
  final UpdateOrderStatus updateStatus;
  final VoidCallback? onAction;
  final VoidCallback? onRejectPressed;
  final VoidCallback? onUndoPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final undoIsLoading = ref.watch(
      undoOrderProvider(orderId).select((s) => s.isLoading),
    );
    final updateIsLoading = ref.watch(
      updateOrderProvider(orderId, updateStatus).select((s) => s.isLoading),
    );

    return Row(
      children: [
        if (orderStatus == OrderStatus.assigned) ...[
          UndoButton(
            title: context.locale.undo,
            onPressed: undoIsLoading ? null : onUndoPressed,
            content: undoIsLoading
                ? CircularLoadingIndicator(
                    color: context.color.brand.defaultValue,
                  )
                : null,
          ),
          Gap(context.dimensions.spacing.s8),
        ],
        Expanded(
          child: SwipeToActionButton(
            title: switch (orderStatus) {
              .pending => context.locale.acceptOrder,
              .assigned => context.locale.pickUpOrder,
              .pickedUp => context.locale.deliverOrder,
            },
            onPressed: updateIsLoading ? null : onAction,
            content: updateIsLoading ? const CircularLoadingIndicator() : null,
          ),
        ),
        if (orderStatus == OrderStatus.pending) ...[
          Gap(context.dimensions.spacing.s8),
          RejectButton(
            title: context.locale.reject,
            onPressed: onRejectPressed,
          ),
        ],
      ],
    );
  }
}
