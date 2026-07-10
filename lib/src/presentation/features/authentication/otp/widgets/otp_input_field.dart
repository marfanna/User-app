part of '../view/otp_verification_page.dart';

class _OTPInputField extends StatelessWidget {
  const _OTPInputField({
    required this.controller,
    this.onCompleted,
    this.smsRetriever,
  });

  final TextEditingController controller;

  /// Fires when all 6 digits are present (typed or SMS-autofilled) so the
  /// caller can auto-submit without a manual tap.
  final ValueChanged<String>? onCompleted;

  /// Android SMS autofill source (User Consent API via smart_auth). iOS fills
  /// the code natively above the keyboard, so this is Android-only.
  final SmsRetriever? smsRetriever;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final padding = context.dimensions.padding.p16 * 2;
    const gap = 8.0;
    final pinWidth = (width - padding - (gap * 5)) / 6;

    return Center(
      child: Pinput(
        controller: controller,
        length: 6,
        // Android: one-tap SMS consent autofill (no app-hash, works with the
        // masked DUARE sender). iOS shows the code above the keyboard natively.
        smsRetriever: smsRetriever,
        onCompleted: onCompleted,
        separatorBuilder: (index) => const Gap(gap),
        defaultPinTheme: PinTheme(
          width: pinWidth,
          height: context.dimensions.size.s56,
          textStyle: context.textStyle.titleMedium,
          decoration: BoxDecoration(
            color: context.color.background.transparent,
            borderRadius: .circular(context.dimensions.radius.r4),
            border: .all(color: context.color.border.disabled),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: pinWidth,
          height: context.dimensions.size.s56,
          textStyle: context.textStyle.titleMedium,
          decoration: BoxDecoration(
            color: context.color.background.transparent,
            borderRadius: .circular(context.dimensions.radius.r4),
            border: .all(
              color: context.color.border.focus,
              width: context.dimensions.size.s2,
            ),
          ),
        ),
      ),
    );
  }
}
