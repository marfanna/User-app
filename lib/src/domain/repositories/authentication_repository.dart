import '../../core/base/base.dart';

abstract class AuthenticationRepository extends Repository {
  Future<Result<bool, Failure>> sendOtp({required String phone});

  Future<Result<bool, Failure>> verifyOtp({
    required String phone,
    required String otp,
  });

  Future<Result<bool, Failure>> logout();
}
