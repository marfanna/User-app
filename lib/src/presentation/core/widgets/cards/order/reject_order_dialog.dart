import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/validation.dart';
import '../../../../../core/utiliity/validation/validation.dart';
import '../../../riverpod/order_actions/reject_order_provider.dart';
import '../../../theme/theme.dart';
import '../../text/typography.dart';
import '../../toast.dart';

class RejectOrderDialog extends ConsumerStatefulWidget {
  const RejectOrderDialog({super.key, required this.orderId});

  final String orderId;

  static Future<bool?> show(BuildContext context, {required String orderId}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        insetPadding: EdgeInsets.all(dialogContext.dimensions.padding.p24),
        child: RejectOrderDialog(orderId: orderId),
      ),
    );
  }

  @override
  ConsumerState<RejectOrderDialog> createState() => _RejectOrderDialogState();
}

class _RejectOrderDialogState extends ConsumerState<RejectOrderDialog> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.listenManual(rejectOrderProvider(widget.orderId), (_, next) {
      if (next is AsyncData && next.value == true) {
        context.pop(true);
        Toast.success(context, context.locale.orderRejected);
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
    final isLoading = ref.watch(rejectOrderProvider(widget.orderId)).isLoading;

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
                  child: TitleText.large(context.locale.rejectOrderTitle),
                ),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: dim.spacing.s8),
            BodyText.mediumRelaxedSecondary(context.locale.rejectOrderSubtitle),
            SizedBox(height: dim.spacing.s24),
            LabelText.medium(context.locale.rejectOrderDescriptionLabel),
            SizedBox(height: dim.spacing.s8),
            TextFormField(
              controller: _controller,
              minLines: 3,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: context.locale.rejectOrderDescriptionHint,
              ),
              validator: context.validator.apply([RequiredValidation()]),
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: dim.spacing.s24),
            FilledButton(
              onPressed: isLoading ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: colors.error.defaultValue,
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
                  : TitleText.mediumInverse(context.locale.rejectOrder),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(rejectOrderProvider(widget.orderId).notifier)
        .reject(reason: _controller.text);
  }
}
