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
GetPendingOrdersUseCase getPendingOrdersUseCase(Ref ref) {
  return GetPendingOrdersUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
GetCompletedOrdersUseCase getCompletedOrdersUseCase(Ref ref) {
  return GetCompletedOrdersUseCase(
    repository: ref.read(orderRepositoryProvider),
  );
}

@riverpod
GetRejectedOrdersUseCase getRejectedOrdersUseCase(Ref ref) {
  return GetRejectedOrdersUseCase(
    repository: ref.read(orderRepositoryProvider),
  );
}

@riverpod
GetOrderUseCase getOrderUseCase(Ref ref) {
  return GetOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
AcceptOrderUseCase acceptOrderUseCase(Ref ref) {
  return AcceptOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
PickUpOrderUseCase pickUpOrderUseCase(Ref ref) {
  return PickUpOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
DeliverOrderUseCase deliverOrderUseCase(Ref ref) {
  return DeliverOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
RejectOrderUseCase rejectOrderUseCase(Ref ref) {
  return RejectOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
UndoOrderUseCase undoOrderUseCase(Ref ref) {
  return UndoOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
GetRiderSummaryUseCase getRiderSummaryUseCase(Ref ref) {
  return GetRiderSummaryUseCase(repository: ref.read(orderRepositoryProvider));
}

@riverpod
TransferOrderUseCase transferOrderUseCase(Ref ref) {
  return TransferOrderUseCase(repository: ref.read(orderRepositoryProvider));
}

/// Rider Use Cases
@riverpod
GetRiderProfileUseCase getRiderProfileUseCase(Ref ref) {
  return GetRiderProfileUseCase(repository: ref.read(riderRepositoryProvider));
}

@riverpod
GetFranchiseRidersUseCase getFranchiseRidersUseCase(Ref ref) {
  return GetFranchiseRidersUseCase(
    repository: ref.read(riderRepositoryProvider),
  );
}
