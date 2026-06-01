import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/gen/assets.gen.dart';
import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/button/button.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/text/typography.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.padding.p16,
            ),
            child: Center(
              child: Column(
                mainAxisSize: .min,
                children: [
                  Gap(context.dimensions.spacing.s64),
                  Assets.logo.duareLogo.image(
                    width: context.dimensions.size.s200,
                  ),
                  Gap(context.dimensions.spacing.s66),
                  Assets.images.rider.image(
                    width: context.dimensions.size.s260,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.dimensions.padding.p16,
          ),
          child: Column(
            mainAxisSize: .min,
            mainAxisAlignment: .end,
            crossAxisAlignment: .start,
            children: [
              DisplayText.large(context.locale.onboardingTitle),
              Gap(context.dimensions.spacing.s8),
              BodyText.medium(context.locale.onboardingSubtitle),
              Gap(context.dimensions.spacing.s40),
              PrimaryButton.comfortable(
                content: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    TitleText.mediumInverse(context.locale.getStarted),
                    Assets.icons.rightArrow.svg(
                      colorFilter: .mode(context.color.icon.inverse, .srcIn),
                    ),
                  ],
                ),
                onPressed: () {
                  context.pushNamed(Routes.login);
                },
              ),
              Gap(context.dimensions.spacing.s16),
            ],
          ),
        ),
      ),
    );
  }
}
