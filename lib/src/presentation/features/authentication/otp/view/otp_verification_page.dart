import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/extensions/app_localization.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/button/button.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/rounded_back_button.dart';
import '../../../../core/widgets/text/typography.dart';
import '../../../../core/widgets/toast.dart';
import '../../../../../core/services/fcm_service.dart';
import '../riverpod/verify_otp_provider.dart';

part '../widgets/otp_input_field.dart';

class OTPVerificationPage extends ConsumerStatefulWidget {
  const OTPVerificationPage({super.key, required this.phone});

  final String phone;

  @override
  ConsumerState<OTPVerificationPage> createState() =>
      _OTPVerificationPageState();
}

class _OTPVerificationPageState extends ConsumerState<OTPVerificationPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    ref.listenManual(verifyOtpProvider, (_, next) {
      if (next.value == true) {
        ref.read(fcmServiceProvider).initialize();
        context.goNamed(Routes.enterName);
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

  void _submit() {
    if (_controller.text.length == 6) {
      ref
          .read(verifyOtpProvider.notifier)
          .verifyOtp(phone: widget.phone, otp: _controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(verifyOtpProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.padding.p16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: RoundedBackButton.primary(),
                ),
                Gap(context.dimensions.spacing.s16),
                DisplayText.large(context.locale.authenticationRequired),
                Gap(context.dimensions.spacing.s8),
                BodyText.medium(context.locale.otpSentMessage),
                Gap(context.dimensions.spacing.s32),
                _OTPInputField(controller: _controller),
                Gap(context.dimensions.spacing.s32),
                PrimaryButton.comfortable(
                  onPressed: state.isLoading ? null : _submit,
                  title: context.locale.submit,
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
