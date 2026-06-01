import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import '../../text/typography.dart';

class PaymentMethodInfo extends StatelessWidget {
  const PaymentMethodInfo({
    super.key,
    required this.method,
    required this.status,
    required this.amount,
  });

  final String method;
  final String status;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: context.dimensions.size.s44,
          width: context.dimensions.size.s44,
          decoration: BoxDecoration(
            color: context.color.background.surfaceVariant,
            borderRadius: BorderRadius.circular(context.dimensions.radius.r8),
          ),
          child: Icon(
            Icons.payments_outlined,
            color: context.color.icon.primary,
          ),
        ),
        SizedBox(width: context.dimensions.spacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyText.medium(method),
              LabelText.mediumSecondary(status),
            ],
          ),
        ),
        TitleText.small(amount),
      ],
    );
  }
}
