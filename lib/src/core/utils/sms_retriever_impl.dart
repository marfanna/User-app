import 'package:pinput/pinput.dart';
import 'package:smart_auth/smart_auth.dart';

/// Bridges `smart_auth` to Pinput's [SmsRetriever] so the OTP field autofills
/// on Android. Uses the SMS **User Consent API** (one-tap "Allow" dialog, no
/// app-hash required) — works with the masked DUARE sender. iOS autofills the
/// code natively, so this is only wired on Android devices.
class SmsRetrieverImpl implements SmsRetriever {
  SmsRetrieverImpl(this.smartAuth);

  final SmartAuth smartAuth;

  @override
  Future<void> dispose() => smartAuth.removeSmsListener();

  @override
  Future<String?> getSmsCode() async {
    final res = await smartAuth.getSmsCode();
    if (res.succeed && res.codeFound) {
      return res.code;
    }
    return null;
  }

  @override
  bool get listenForMultipleSms => false;
}
