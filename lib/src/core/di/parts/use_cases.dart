part of '../dependency_injection.dart';

/// Locale Use Cases
@riverpod
GetCurrentLocaleUseCase getCurrentLocaleUseCase(Ref ref) {
  return GetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

@riverpod
SetCurrentLocaleUseCase setCurrentLocaleUseCase(Ref ref) {
  return SetCurrentLocaleUseCase(ref.read(localeRepositoryProvider));
}

/// Authentication Use Cases
@riverpod
SendOtpUseCase sendOtpUseCase(Ref ref) {
  return SendOtpUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
VerifyOtpUseCase verifyOtpUseCase(Ref ref) {
  return VerifyOtpUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
GetUserLoginStatusUseCase getUserLoginStatusUseCase(Ref ref) {
  return GetUserLoginStatusUseCase(ref.read(routerRepositoryProvider));
}

@riverpod
LogoutUseCase logoutUseCase(Ref ref) {
  return LogoutUseCase(ref.read(authenticationRepositoryProvider));
}

@riverpod
ResetRepositoryUseCase resetRepositoryUseCase(Ref ref) {
  return const ResetRepositoryUseCase();
}

/// Order Use Cases
@riverpod
GetOrderUseCase getOrderUseCase(Ref ref) {
  return GetOrderUseCase(repository: ref.read(orderRepositoryProvider));
}
