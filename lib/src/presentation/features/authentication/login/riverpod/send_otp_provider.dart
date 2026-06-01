import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/base/result.dart';
import '../../../../../core/di/dependency_injection.dart';

part 'send_otp_provider.g.dart';

@riverpod
class SendOtp extends _$SendOtp {
  late final _useCase = ref.read(sendOtpUseCaseProvider);

  @override
  AsyncValue<bool> build() {
    return const AsyncValue.data(false);
  }

  Future<void> sendOtp(String phone) async {
    state = const AsyncValue.loading();

    final result = await _useCase.call(phone);

    state = result.when(
      success: (value) => AsyncValue.data(value ?? false),
      error: (e) => AsyncValue.error(e.message, StackTrace.current),
    );
  }
}
