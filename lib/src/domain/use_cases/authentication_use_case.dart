import '../../core/base/base.dart';
import '../repositories/authentication_repository.dart';

class SendOtpUseCase {
  SendOtpUseCase(this._repository);

  final AuthenticationRepository _repository;

  Future<Result<bool, Failure>> call(String params) {
    return _repository.sendOtp(phone: params);
  }
}

class VerifyOtpUseCase {
  VerifyOtpUseCase(this._repository);

  final AuthenticationRepository _repository;

  Future<Result<bool, Failure>> call({
    required String phone,
    required String otp,
  }) {
    return _repository.verifyOtp(phone: phone, otp: otp);
  }
}

class LogoutUseCase {
  LogoutUseCase(this._repository);

  final AuthenticationRepository _repository;

  Future<Result<void, Failure>> call() {
    return _repository.logout();
  }
}
