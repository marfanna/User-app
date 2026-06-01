import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../../core/extensions/validation.dart';
import '../../../../../core/utiliity/validation/validation.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/rounded_back_button.dart';
import '../../../../core/widgets/text/typography.dart';
import '../../../../core/widgets/toast.dart';
import '../riverpod/send_otp_provider.dart';

part '../widgets/login_form.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(sendOtpProvider, (_, next) {
      if (next.value == true) {
        context.pushNamed(Routes.otp, extra: controller.text);
      } else if (next is AsyncError) {
        Toast.error(context, next.error.toString());
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ref.read(sendOtpProvider.notifier).sendOtp(controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sendOtpProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.padding.p16,
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: RoundedBackButton.primary(),
                ),
                Gap(context.dimensions.spacing.s16),
                DisplayText.large(context.locale.pleaseLogin),
                Gap(context.dimensions.spacing.s8),
                BodyText.medium(context.locale.onboardingSubtitle),
                Gap(context.dimensions.spacing.s16),
                Form(
                  key: _formKey,
                  child: _LoginForm(controller: controller),
                ),
                Gap(context.dimensions.spacing.s32),
                PrimaryButton.comfortable(
                  onPressed: state.isLoading ? null : _submit,
                  title: context.locale.continueText,
                  content: state.isLoading
                      ? const CircularProgressIndicator()
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
