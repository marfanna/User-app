import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../gen/assets.gen.dart';
import '../../../theme/theme.dart';
import '../../text/typography.dart';

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({
    super.key,
    required this.name,
    this.phone = '',
    required this.location,
    required this.distance,
    this.onLocationTap,
  });

  final String name;
  final String phone;
  final String location;
  final String distance;
  final VoidCallback? onLocationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: .start,
      children: [
        Container(
          height: context.dimensions.size.s56,
          width: context.dimensions.size.s56,
          clipBehavior: .antiAlias,
          decoration: BoxDecoration(
            color: context.color.background.surfaceVariant,
            borderRadius: .circular(context.dimensions.radius.r8),
          ),
          child: Center(
            child: Icon(Icons.restaurant, color: context.color.icon.primary),
          ),
        ),
        Gap(context.dimensions.spacing.s12),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              TitleText.small(name, maxLines: 1, overflow: .ellipsis),
              Gap(context.dimensions.spacing.s4),
              if (phone.isNotEmpty) ...[
                GestureDetector(
                  onTap: () => launchUrl(Uri(scheme: 'tel', path: phone)),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: context.dimensions.size.s16,
                        color: context.color.brand.primary,
                      ),
                      Gap(context.dimensions.spacing.s4),
                      BodyText.small(phone),
                    ],
                  ),
                ),
                Gap(context.dimensions.spacing.s4),
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
                      Flexible(
                        child: BodyText.small(
                          location,
                          maxLines: 1,
                          overflow: .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (phone.isEmpty) ...[
                GestureDetector(
                  onTap: onLocationTap,
                  child: Row(
                    crossAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: .only(top: context.dimensions.size.s4),
                        child: Assets.icons.locationOutlined.svg(
                          width: context.dimensions.size.s16,
                          height: context.dimensions.size.s16,
                          colorFilter: ColorFilter.mode(
                            context.color.brand.primary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Gap(context.dimensions.spacing.s4),
                      Flexible(
                        child: BodyText.small(
                          location,
                          maxLines: 2,
                          overflow: .ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        Gap(context.dimensions.spacing.s12),
        GestureDetector(
          onTap: onLocationTap,
          child: Container(
            height: context.dimensions.size.s56,
            width: context.dimensions.size.s56,
            clipBehavior: .antiAlias,
            decoration: BoxDecoration(
              color: context.color.background.surfaceContainerHighDim,
              borderRadius: .circular(context.dimensions.radius.r8),
            ),
            child: Center(child: TitleText.smallNunito(distance)),
          ),
        ),
      ],
    );
  }
}
