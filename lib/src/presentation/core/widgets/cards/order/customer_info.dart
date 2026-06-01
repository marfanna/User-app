import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../gen/assets.gen.dart';
import '../../../theme/theme.dart';
import '../../text/typography.dart';

class CustomerInfo extends StatelessWidget {
  const CustomerInfo({
    super.key,
    required this.name,
    this.phones,
    this.orderId = '',
    required this.address,
    required this.time,
    this.profileImage = '',
    this.addressMaxLines = 1,
    this.onLocationTap,
  });

  final String name;
  final List<String>? phones;
  final String orderId;
  final String address;
  final String time;
  final String profileImage;
  final int addressMaxLines;
  final VoidCallback? onLocationTap;

  @override
  Widget build(BuildContext context) {
    final showPhoneRow = phones != null;
    return Container(
      padding: EdgeInsets.all(context.dimensions.padding.p10),
      decoration: BoxDecoration(
        color: context.color.background.surfaceContainerHigh,
        borderRadius: .circular(context.dimensions.radius.r10),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: .start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.color.background.surfaceVariant,
                child: const Icon(Icons.person, size: 24),
              ),
              Gap(context.dimensions.spacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    BodyText.small(name, maxLines: 1, overflow: .ellipsis),
                    if (orderId.isNotEmpty) ...[
                      LabelText.mediumSecondary(
                        'Order Id: $orderId',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (showPhoneRow) _PhoneRow(phones: phones!),
                  ],
                ),
              ),
            ],
          ),
          Gap(context.dimensions.spacing.s8),
          if (showPhoneRow) ...[
            GestureDetector(
              onTap: onLocationTap,
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: context.dimensions.size.s16,
                    color: context.color.brand.primary,
                  ),
                  Gap(context.dimensions.spacing.s4),
                  Expanded(
                    child: BodyText.mediumRelaxedSecondary(
                      address,
                      maxLines: addressMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            GestureDetector(
              onTap: onLocationTap,
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: context.dimensions.padding.p4,
                      horizontal: context.dimensions.padding.p6,
                    ),
                    decoration: BoxDecoration(
                      color: context.color.background.surfaceContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Assets.icons.location.svg(
                      colorFilter: ColorFilter.mode(
                        context.color.brand.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Gap(context.dimensions.spacing.s4),
                  Expanded(
                    child: BodyText.mediumRelaxedSecondary(
                      address,
                      maxLines: addressMaxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PhoneRow extends StatelessWidget {
  const _PhoneRow({required this.phones});

  final List<String> phones;

  @override
  Widget build(BuildContext context) {
    if (phones.isEmpty) {
      return Row(
        children: [
          Icon(
            Icons.phone_outlined,
            size: context.dimensions.size.s16,
            color: context.color.brand.primary,
          ),
          Gap(context.dimensions.spacing.s4),
          const BodyText.small('N/A'),
        ],
      );
    }

    return Row(
      children: [
        Icon(
          Icons.phone_outlined,
          size: context.dimensions.size.s16,
          color: context.color.brand.primary,
        ),
        Gap(context.dimensions.spacing.s4),
        for (var i = 0; i < phones.length; i++) ...[
          if (i > 0) const BodyText.small(' | '),
          GestureDetector(
            onTap: () => launchUrl(Uri(scheme: 'tel', path: phones[i])),
            child: BodyText.small(phones[i]),
          ),
        ],
      ],
    );
  }
}
