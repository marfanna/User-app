import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../theme/theme.dart';

class CompletedOrderAction extends StatelessWidget {
  const CompletedOrderAction({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.done_all_outlined,
          color: context.color.success.defaultValue,
        ),
        Gap(context.dimensions.spacing.s8),
        Text(
          context.locale.orderDelivered,
          style: context.textStyle.bodyMediumRelaxed.copyWith(
            fontWeight: FontWeight.w700,
            color: context.color.success.defaultValue,
          ),
        ),
      ],
    );
  }
}
