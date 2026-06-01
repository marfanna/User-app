part of '../dependency_injection.dart';

@Riverpod(keepAlive: true)
RouterRepository routerRepository(Ref ref) {
  return RouterRepositoryImpl(cacheService: ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
LocaleRepository localeRepository(Ref ref) {
  return LocaleRepositoryImpl(ref.read(cacheServiceProvider));
}

@Riverpod(keepAlive: true)
AuthenticationRepository authenticationRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    remote: ref.read(restClientServiceProvider),
    cacheService: ref.read(cacheServiceProvider),
  );
}

@Riverpod(keepAlive: true)
OrderRepository orderRepository(Ref ref) {
  return OrderRepositoryImpl(remote: ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
RiderRepository riderRepository(Ref ref) {
  return RiderRepositoryImpl(remote: ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
AddressRepository addressRepository(Ref ref) {
  return AddressRepositoryImpl(remote: ref.read(restClientServiceProvider));
}

@Riverpod(keepAlive: true)
BkashRepository bkashRepository(Ref ref) {
  return BkashRepositoryImpl(remote: ref.read(restClientServiceProvider));
}
