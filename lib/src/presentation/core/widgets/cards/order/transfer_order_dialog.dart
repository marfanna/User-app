import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/validation.dart';
import '../../../../../core/utiliity/validation/validation.dart';
import '../../../riverpod/order_actions/transfer_order_provider.dart';
import '../../../theme/theme.dart';
import '../../text/typography.dart';
import '../../toast.dart';

class TransferOrderDialog extends ConsumerStatefulWidget {
  const TransferOrderDialog({
    super.key,
    required this.orderId,
    required this.toRiderId,
    required this.toRiderName,
  });

  final String orderId;
  final String toRiderId;
  final String toRiderName;

  static Future<bool?> show(
    BuildContext context, {
    required String orderId,
    required String toRiderId,
    required String toRiderName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        insetPadding: EdgeInsets.all(dialogContext.dimensions.padding.p24),
        child: TransferOrderDialog(
          orderId: orderId,
          toRiderId: toRiderId,
          toRiderName: toRiderName,
        ),
      ),
    );
  }

  @override
  ConsumerState<TransferOrderDialog> createState() =>
      _TransferOrderDialogState();
}

class _TransferOrderDialogState extends ConsumerState<TransferOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual(transferOrderProvider(widget.orderId), (_, next) {
      if (next is AsyncData && next.value == true) {
        context.pop(true);
      } else if (next is AsyncError) {
        Toast.error(context, next.error.toString());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dim = context.dimensions;
    final colors = context.color;
    final isLoading = ref
        .watch(transferOrderProvider(widget.orderId))
        .isLoading;

    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.all(dim.padding.p24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TitleText.large(
                    context.locale.transferOrderTitle(widget.toRiderName),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: dim.spacing.s8),
            BodyText.mediumRelaxedSecondary(
              context.locale.transferOrderSubtitle,
            ),
            SizedBox(height: dim.spacing.s24),
            LabelText.medium(context.locale.transferOrderReasonLabel),
            SizedBox(height: dim.spacing.s8),
            TextFormField(
              controller: _controller,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: context.locale.transferOrderReasonHint,
              ),
              validator: context.validator.apply([RequiredValidation()]),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: dim.spacing.s24),
            FilledButton(
              onPressed: isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: colors.brand.primary,
                foregroundColor: colors.text.inverse,
                shadowColor: colors.elevation.transparent,
                minimumSize: Size(double.infinity, dim.size.s56),
                fixedSize: Size.fromHeight(dim.size.s56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(dim.radius.r4),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator()
                  : TitleText.mediumInverse(context.locale.transfer),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(transferOrderProvider(widget.orderId).notifier)
        .transfer(toRiderId: widget.toRiderId, reason: _controller.text);
  }
}
