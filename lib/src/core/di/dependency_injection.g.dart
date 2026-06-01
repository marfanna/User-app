// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dependency_injection.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'ad13470fe866595ad0f58a3e26f11048d94ef22e';

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'8d32f5f2810c4705e274d7abbf7432d048f44c22';

@ProviderFor(routerRepository)
final routerRepositoryProvider = RouterRepositoryProvider._();

final class RouterRepositoryProvider
    extends
        $FunctionalProvider<
          RouterRepository,
          RouterRepository,
          RouterRepository
        >
    with $Provider<RouterRepository> {
  RouterRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerRepositoryHash();

  @$internal
  @override
  $ProviderElement<RouterRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RouterRepository create(Ref ref) {
    return routerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RouterRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RouterRepository>(value),
    );
  }
}

String _$routerRepositoryHash() => r'277e8ef0a2084e2932037d567391fefea47aaaf9';

@ProviderFor(localeRepository)
final localeRepositoryProvider = LocaleRepositoryProvider._();

final class LocaleRepositoryProvider
    extends
        $FunctionalProvider<
          LocaleRepository,
          LocaleRepository,
          LocaleRepository
        >
    with $Provider<LocaleRepository> {
  LocaleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocaleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocaleRepository create(Ref ref) {
    return localeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocaleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocaleRepository>(value),
    );
  }
}

String _$localeRepositoryHash() => r'dce98c6324324135160c7e3216c1527dbb923f88';

@ProviderFor(authenticationRepository)
final authenticationRepositoryProvider = AuthenticationRepositoryProvider._();

final class AuthenticationRepositoryProvider
    extends
        $FunctionalProvider<
          AuthenticationRepository,
          AuthenticationRepository,
          AuthenticationRepository
        >
    with $Provider<AuthenticationRepository> {
  AuthenticationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authenticationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authenticationRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthenticationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthenticationRepository create(Ref ref) {
    return authenticationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthenticationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthenticationRepository>(value),
    );
  }
}

String _$authenticationRepositoryHash() =>
    r'7fc3d7b703cb4958b1818c9cc7cdab4e5b00618e';

@ProviderFor(orderRepository)
final orderRepositoryProvider = OrderRepositoryProvider._();

final class OrderRepositoryProvider
    extends
        $FunctionalProvider<OrderRepository, OrderRepository, OrderRepository>
    with $Provider<OrderRepository> {
  OrderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderRepository create(Ref ref) {
    return orderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderRepository>(value),
    );
  }
}

String _$orderRepositoryHash() => r'071339eee7547665a3a657b78262b6f5c4783da4';

@ProviderFor(riderRepository)
final riderRepositoryProvider = RiderRepositoryProvider._();

final class RiderRepositoryProvider
    extends
        $FunctionalProvider<RiderRepository, RiderRepository, RiderRepository>
    with $Provider<RiderRepository> {
  RiderRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'riderRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$riderRepositoryHash();

  @$internal
  @override
  $ProviderElement<RiderRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RiderRepository create(Ref ref) {
    return riderRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RiderRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RiderRepository>(value),
    );
  }
}

String _$riderRepositoryHash() => r'629e979683bdb710a4e3160c3aebdd4dbf68536e';

@ProviderFor(addressRepository)
final addressRepositoryProvider = AddressRepositoryProvider._();

final class AddressRepositoryProvider
    extends
        $FunctionalProvider<
          AddressRepository,
          AddressRepository,
          AddressRepository
        >
    with $Provider<AddressRepository> {
  AddressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressRepositoryHash();

  @$internal
  @override
  $ProviderElement<AddressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddressRepository create(Ref ref) {
    return addressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressRepository>(value),
    );
  }
}

String _$addressRepositoryHash() => r'fd02d19eb60107b8e41295cf469ae0b72f0012a1';

@ProviderFor(bkashRepository)
final bkashRepositoryProvider = BkashRepositoryProvider._();

final class BkashRepositoryProvider
    extends
        $FunctionalProvider<BkashRepository, BkashRepository, BkashRepository>
    with $Provider<BkashRepository> {
  BkashRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bkashRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bkashRepositoryHash();

  @$internal
  @override
  $ProviderElement<BkashRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BkashRepository create(Ref ref) {
    return bkashRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BkashRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BkashRepository>(value),
    );
  }
}

String _$bkashRepositoryHash() => r'd4b43ed1f5e10a446b6aaf323b2f60fbc8af174c';

@ProviderFor(cacheService)
final cacheServiceProvider = CacheServiceProvider._();

final class CacheServiceProvider
    extends $FunctionalProvider<CacheService, CacheService, CacheService>
    with $Provider<CacheService> {
  CacheServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheServiceHash();

  @$internal
  @override
  $ProviderElement<CacheService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CacheService create(Ref ref) {
    return cacheService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CacheService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CacheService>(value),
    );
  }
}

String _$cacheServiceHash() => r'21a7ce6ef1eab778d1b25d2ff1b8fcc3ca26aac5';

@ProviderFor(restClientService)
final restClientServiceProvider = RestClientServiceProvider._();

final class RestClientServiceProvider
    extends $FunctionalProvider<RestClient, RestClient, RestClient>
    with $Provider<RestClient> {
  RestClientServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'restClientServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$restClientServiceHash();

  @$internal
  @override
  $ProviderElement<RestClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RestClient create(Ref ref) {
    return restClientService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RestClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RestClient>(value),
    );
  }
}

String _$restClientServiceHash() => r'87fbf3f2320c6d4a7dd07f6f9056c6d8f8d90f1f';

/// Locale Use Cases

@ProviderFor(getCurrentLocaleUseCase)
final getCurrentLocaleUseCaseProvider = GetCurrentLocaleUseCaseProvider._();

/// Locale Use Cases

final class GetCurrentLocaleUseCaseProvider
    extends
        $FunctionalProvider<
          GetCurrentLocaleUseCase,
          GetCurrentLocaleUseCase,
          GetCurrentLocaleUseCase
        >
    with $Provider<GetCurrentLocaleUseCase> {
  /// Locale Use Cases
  GetCurrentLocaleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCurrentLocaleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCurrentLocaleUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCurrentLocaleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCurrentLocaleUseCase create(Ref ref) {
    return getCurrentLocaleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCurrentLocaleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCurrentLocaleUseCase>(value),
    );
  }
}

String _$getCurrentLocaleUseCaseHash() =>
    r'0934d94db826e0316dfcdf37515ea53ed385ac39';

@ProviderFor(setCurrentLocaleUseCase)
final setCurrentLocaleUseCaseProvider = SetCurrentLocaleUseCaseProvider._();

final class SetCurrentLocaleUseCaseProvider
    extends
        $FunctionalProvider<
          SetCurrentLocaleUseCase,
          SetCurrentLocaleUseCase,
          SetCurrentLocaleUseCase
        >
    with $Provider<SetCurrentLocaleUseCase> {
  SetCurrentLocaleUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setCurrentLocaleUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setCurrentLocaleUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetCurrentLocaleUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetCurrentLocaleUseCase create(Ref ref) {
    return setCurrentLocaleUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetCurrentLocaleUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetCurrentLocaleUseCase>(value),
    );
  }
}

String _$setCurrentLocaleUseCaseHash() =>
    r'eef8975e559b80a2d395c006d0edc49378928b38';

/// Authentication Use Cases

@ProviderFor(sendOtpUseCase)
final sendOtpUseCaseProvider = SendOtpUseCaseProvider._();

/// Authentication Use Cases

final class SendOtpUseCaseProvider
    extends $FunctionalProvider<SendOtpUseCase, SendOtpUseCase, SendOtpUseCase>
    with $Provider<SendOtpUseCase> {
  /// Authentication Use Cases
  SendOtpUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendOtpUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendOtpUseCaseHash();

  @$internal
  @override
  $ProviderElement<SendOtpUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SendOtpUseCase create(Ref ref) {
    return sendOtpUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendOtpUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendOtpUseCase>(value),
    );
  }
}

String _$sendOtpUseCaseHash() => r'cc517ca14b237a7c676583868c138086cef494e7';

@ProviderFor(verifyOtpUseCase)
final verifyOtpUseCaseProvider = VerifyOtpUseCaseProvider._();

final class VerifyOtpUseCaseProvider
    extends
        $FunctionalProvider<
          VerifyOtpUseCase,
          VerifyOtpUseCase,
          VerifyOtpUseCase
        >
    with $Provider<VerifyOtpUseCase> {
  VerifyOtpUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'verifyOtpUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$verifyOtpUseCaseHash();

  @$internal
  @override
  $ProviderElement<VerifyOtpUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VerifyOtpUseCase create(Ref ref) {
    return verifyOtpUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VerifyOtpUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VerifyOtpUseCase>(value),
    );
  }
}

String _$verifyOtpUseCaseHash() => r'a8000e3c84a8ab50df193f40f825988ba17d4c95';

@ProviderFor(getUserLoginStatusUseCase)
final getUserLoginStatusUseCaseProvider = GetUserLoginStatusUseCaseProvider._();

final class GetUserLoginStatusUseCaseProvider
    extends
        $FunctionalProvider<
          GetUserLoginStatusUseCase,
          GetUserLoginStatusUseCase,
          GetUserLoginStatusUseCase
        >
    with $Provider<GetUserLoginStatusUseCase> {
  GetUserLoginStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getUserLoginStatusUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getUserLoginStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetUserLoginStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetUserLoginStatusUseCase create(Ref ref) {
    return getUserLoginStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetUserLoginStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetUserLoginStatusUseCase>(value),
    );
  }
}

String _$getUserLoginStatusUseCaseHash() =>
    r'91a4bb4c1c9791fe7aa17e08cfba6cd238680528';

@ProviderFor(logoutUseCase)
final logoutUseCaseProvider = LogoutUseCaseProvider._();

final class LogoutUseCaseProvider
    extends $FunctionalProvider<LogoutUseCase, LogoutUseCase, LogoutUseCase>
    with $Provider<LogoutUseCase> {
  LogoutUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutUseCaseHash();

  @$internal
  @override
  $ProviderElement<LogoutUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoutUseCase create(Ref ref) {
    return logoutUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoutUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoutUseCase>(value),
    );
  }
}

String _$logoutUseCaseHash() => r'e46d735224033bf72b7b42db70e6bd22a4d070a2';

@ProviderFor(resetRepositoryUseCase)
final resetRepositoryUseCaseProvider = ResetRepositoryUseCaseProvider._();

final class ResetRepositoryUseCaseProvider
    extends
        $FunctionalProvider<
          ResetRepositoryUseCase,
          ResetRepositoryUseCase,
          ResetRepositoryUseCase
        >
    with $Provider<ResetRepositoryUseCase> {
  ResetRepositoryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetRepositoryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetRepositoryUseCaseHash();

  @$internal
  @override
  $ProviderElement<ResetRepositoryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ResetRepositoryUseCase create(Ref ref) {
    return resetRepositoryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResetRepositoryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResetRepositoryUseCase>(value),
    );
  }
}

String _$resetRepositoryUseCaseHash() =>
    r'272d74f8e5d5dea3aaa93eee0393143f03b17eb6';

/// Order Use Cases

@ProviderFor(getPendingOrdersUseCase)
final getPendingOrdersUseCaseProvider = GetPendingOrdersUseCaseProvider._();

/// Order Use Cases

final class GetPendingOrdersUseCaseProvider
    extends
        $FunctionalProvider<
          GetPendingOrdersUseCase,
          GetPendingOrdersUseCase,
          GetPendingOrdersUseCase
        >
    with $Provider<GetPendingOrdersUseCase> {
  /// Order Use Cases
  GetPendingOrdersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getPendingOrdersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getPendingOrdersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetPendingOrdersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetPendingOrdersUseCase create(Ref ref) {
    return getPendingOrdersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetPendingOrdersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetPendingOrdersUseCase>(value),
    );
  }
}

String _$getPendingOrdersUseCaseHash() =>
    r'd4419b3b604089daac7397908e335c9da898e809';

@ProviderFor(getCompletedOrdersUseCase)
final getCompletedOrdersUseCaseProvider = GetCompletedOrdersUseCaseProvider._();

final class GetCompletedOrdersUseCaseProvider
    extends
        $FunctionalProvider<
          GetCompletedOrdersUseCase,
          GetCompletedOrdersUseCase,
          GetCompletedOrdersUseCase
        >
    with $Provider<GetCompletedOrdersUseCase> {
  GetCompletedOrdersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getCompletedOrdersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getCompletedOrdersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetCompletedOrdersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetCompletedOrdersUseCase create(Ref ref) {
    return getCompletedOrdersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetCompletedOrdersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetCompletedOrdersUseCase>(value),
    );
  }
}

String _$getCompletedOrdersUseCaseHash() =>
    r'8b36885127cf18e63b92c6714ce91e020c9c0e12';

@ProviderFor(getRejectedOrdersUseCase)
final getRejectedOrdersUseCaseProvider = GetRejectedOrdersUseCaseProvider._();

final class GetRejectedOrdersUseCaseProvider
    extends
        $FunctionalProvider<
          GetRejectedOrdersUseCase,
          GetRejectedOrdersUseCase,
          GetRejectedOrdersUseCase
        >
    with $Provider<GetRejectedOrdersUseCase> {
  GetRejectedOrdersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRejectedOrdersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRejectedOrdersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRejectedOrdersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetRejectedOrdersUseCase create(Ref ref) {
    return getRejectedOrdersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRejectedOrdersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRejectedOrdersUseCase>(value),
    );
  }
}

String _$getRejectedOrdersUseCaseHash() =>
    r'2d41dd685f5297a71ff2ab7cff9e23d0af0bfbff';

@ProviderFor(getOrderUseCase)
final getOrderUseCaseProvider = GetOrderUseCaseProvider._();

final class GetOrderUseCaseProvider
    extends
        $FunctionalProvider<GetOrderUseCase, GetOrderUseCase, GetOrderUseCase>
    with $Provider<GetOrderUseCase> {
  GetOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetOrderUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetOrderUseCase create(Ref ref) {
    return getOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetOrderUseCase>(value),
    );
  }
}

String _$getOrderUseCaseHash() => r'ec68d285ec42b3f27705d7768a0a71e45f8b27b4';

@ProviderFor(acceptOrderUseCase)
final acceptOrderUseCaseProvider = AcceptOrderUseCaseProvider._();

final class AcceptOrderUseCaseProvider
    extends
        $FunctionalProvider<
          AcceptOrderUseCase,
          AcceptOrderUseCase,
          AcceptOrderUseCase
        >
    with $Provider<AcceptOrderUseCase> {
  AcceptOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'acceptOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$acceptOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<AcceptOrderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AcceptOrderUseCase create(Ref ref) {
    return acceptOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AcceptOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AcceptOrderUseCase>(value),
    );
  }
}

String _$acceptOrderUseCaseHash() =>
    r'dc042c22706454b7bc370ecb99a41bc0817b4ee1';

@ProviderFor(pickUpOrderUseCase)
final pickUpOrderUseCaseProvider = PickUpOrderUseCaseProvider._();

final class PickUpOrderUseCaseProvider
    extends
        $FunctionalProvider<
          PickUpOrderUseCase,
          PickUpOrderUseCase,
          PickUpOrderUseCase
        >
    with $Provider<PickUpOrderUseCase> {
  PickUpOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pickUpOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pickUpOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<PickUpOrderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PickUpOrderUseCase create(Ref ref) {
    return pickUpOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PickUpOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PickUpOrderUseCase>(value),
    );
  }
}

String _$pickUpOrderUseCaseHash() =>
    r'e6a3171a36b9e9a8c2d8c2589b8a63c53bce9a25';

@ProviderFor(deliverOrderUseCase)
final deliverOrderUseCaseProvider = DeliverOrderUseCaseProvider._();

final class DeliverOrderUseCaseProvider
    extends
        $FunctionalProvider<
          DeliverOrderUseCase,
          DeliverOrderUseCase,
          DeliverOrderUseCase
        >
    with $Provider<DeliverOrderUseCase> {
  DeliverOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliverOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliverOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<DeliverOrderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeliverOrderUseCase create(Ref ref) {
    return deliverOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeliverOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeliverOrderUseCase>(value),
    );
  }
}

String _$deliverOrderUseCaseHash() =>
    r'71f7b2b390af0d49f33d42038c321dec3a2acab2';

@ProviderFor(rejectOrderUseCase)
final rejectOrderUseCaseProvider = RejectOrderUseCaseProvider._();

final class RejectOrderUseCaseProvider
    extends
        $FunctionalProvider<
          RejectOrderUseCase,
          RejectOrderUseCase,
          RejectOrderUseCase
        >
    with $Provider<RejectOrderUseCase> {
  RejectOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rejectOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rejectOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<RejectOrderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RejectOrderUseCase create(Ref ref) {
    return rejectOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RejectOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RejectOrderUseCase>(value),
    );
  }
}

String _$rejectOrderUseCaseHash() =>
    r'8ee4026301612eae5e5168530e097cacf111268c';

@ProviderFor(undoOrderUseCase)
final undoOrderUseCaseProvider = UndoOrderUseCaseProvider._();

final class UndoOrderUseCaseProvider
    extends
        $FunctionalProvider<
          UndoOrderUseCase,
          UndoOrderUseCase,
          UndoOrderUseCase
        >
    with $Provider<UndoOrderUseCase> {
  UndoOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'undoOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$undoOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<UndoOrderUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UndoOrderUseCase create(Ref ref) {
    return undoOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UndoOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UndoOrderUseCase>(value),
    );
  }
}

String _$undoOrderUseCaseHash() => r'a14166825cf2090637c3788a181c5646e09f658a';

@ProviderFor(getRiderSummaryUseCase)
final getRiderSummaryUseCaseProvider = GetRiderSummaryUseCaseProvider._();

final class GetRiderSummaryUseCaseProvider
    extends
        $FunctionalProvider<
          GetRiderSummaryUseCase,
          GetRiderSummaryUseCase,
          GetRiderSummaryUseCase
        >
    with $Provider<GetRiderSummaryUseCase> {
  GetRiderSummaryUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRiderSummaryUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRiderSummaryUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRiderSummaryUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetRiderSummaryUseCase create(Ref ref) {
    return getRiderSummaryUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRiderSummaryUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRiderSummaryUseCase>(value),
    );
  }
}

String _$getRiderSummaryUseCaseHash() =>
    r'435ceb07f44ec08f4b9dbf03dbfc2988b94eb395';

@ProviderFor(transferOrderUseCase)
final transferOrderUseCaseProvider = TransferOrderUseCaseProvider._();

final class TransferOrderUseCaseProvider
    extends
        $FunctionalProvider<
          TransferOrderUseCase,
          TransferOrderUseCase,
          TransferOrderUseCase
        >
    with $Provider<TransferOrderUseCase> {
  TransferOrderUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transferOrderUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transferOrderUseCaseHash();

  @$internal
  @override
  $ProviderElement<TransferOrderUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransferOrderUseCase create(Ref ref) {
    return transferOrderUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransferOrderUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransferOrderUseCase>(value),
    );
  }
}

String _$transferOrderUseCaseHash() =>
    r'577ed30952f33bf7587b397386a05a99e48ca3c8';

/// Rider Use Cases

@ProviderFor(getRiderProfileUseCase)
final getRiderProfileUseCaseProvider = GetRiderProfileUseCaseProvider._();

/// Rider Use Cases

final class GetRiderProfileUseCaseProvider
    extends
        $FunctionalProvider<
          GetRiderProfileUseCase,
          GetRiderProfileUseCase,
          GetRiderProfileUseCase
        >
    with $Provider<GetRiderProfileUseCase> {
  /// Rider Use Cases
  GetRiderProfileUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getRiderProfileUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getRiderProfileUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetRiderProfileUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetRiderProfileUseCase create(Ref ref) {
    return getRiderProfileUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetRiderProfileUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetRiderProfileUseCase>(value),
    );
  }
}

String _$getRiderProfileUseCaseHash() =>
    r'6cc628ecfaf45c4979720540c24810e6b2d698e5';

@ProviderFor(getFranchiseRidersUseCase)
final getFranchiseRidersUseCaseProvider = GetFranchiseRidersUseCaseProvider._();

final class GetFranchiseRidersUseCaseProvider
    extends
        $FunctionalProvider<
          GetFranchiseRidersUseCase,
          GetFranchiseRidersUseCase,
          GetFranchiseRidersUseCase
        >
    with $Provider<GetFranchiseRidersUseCase> {
  GetFranchiseRidersUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getFranchiseRidersUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getFranchiseRidersUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetFranchiseRidersUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetFranchiseRidersUseCase create(Ref ref) {
    return getFranchiseRidersUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetFranchiseRidersUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetFranchiseRidersUseCase>(value),
    );
  }
}

String _$getFranchiseRidersUseCaseHash() =>
    r'3fb5d3f3769c6e5d0f7cec732e31d5c6d9a0af13';
