import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';

part 'verify_otp_provider.g.dart';

@riverpod
class VerifyOtp extends _$VerifyOtp {
  late final _useCase = ref.read(verifyOtpUseCaseProvider);

  @override
  AsyncValue<bool> build() {
    return const AsyncValue.data(false);
  }

  Future<void> verifyOtp({required String phone, required String otp}) async {
    state = const AsyncValue.loading();

    final result = await _useCase.call(phone: phone, otp: otp);

    state = result.when(
      success: (value) => AsyncValue.data(value ?? false),
      error: (e) => AsyncValue.error(e.message, StackTrace.current),
    );
  }
}
