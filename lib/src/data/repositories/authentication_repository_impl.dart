import '../../core/base/exceptions.dart';
import '../../core/base/failure.dart';
import '../../core/base/result.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../models/auth_response.dart';
import '../models/request/send_otp_request.dart';
import '../models/request/verify_otp_request.dart';
import '../services/cache/cache_service.dart';
import '../services/network/rest_client.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  AuthenticationRepositoryImpl({
    required this.remote,
    required this.cacheService,
  });

  final RestClient remote;
  final CacheService cacheService;

  @override
  Future<Result<bool, Failure>> sendOtp({required String phone}) async {
    return asyncGuard(() async {
      final request = SendOtpRequest(phone: phone);

      await remote.sendOtp(request.toJson());

      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return asyncGuard(() async {
      final request = VerifyOtpRequest(phone: phone, otp: otp);
      final response = await remote.verifyOtp(request.toJson());

      final result = AuthResponse.fromJson(response.data['data']);

      if (result.accessToken == null || result.refreshToken == null) {
        throw const CustomException.unauthorized(
          message: 'Invalid response. Try again later.',
        );
      }

      await cacheService.save(CacheKey.accessToken, result.accessToken);
      await cacheService.save(CacheKey.refreshToken, result.refreshToken);
      await cacheService.save(CacheKey.isLoggedIn, true);

      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> logout() {
    return asyncGuard(() async {
      try {
        await remote.logout();
      } catch (_) {
        // Best-effort; proceed with local cleanup regardless.
      }
      await cacheService.clear();
      return true;
    });
  }
}
