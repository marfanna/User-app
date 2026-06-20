// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_state_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckoutDeliveryCharge)
final checkoutDeliveryChargeProvider = CheckoutDeliveryChargeProvider._();

final class CheckoutDeliveryChargeProvider
    extends $NotifierProvider<CheckoutDeliveryCharge, double?> {
  CheckoutDeliveryChargeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutDeliveryChargeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutDeliveryChargeHash();

  @$internal
  @override
  CheckoutDeliveryCharge create() => CheckoutDeliveryCharge();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double?>(value),
    );
  }
}

String _$checkoutDeliveryChargeHash() =>
    r'52e91136e3435bb2dc9369f2e9e03bbc224ffcd2';

abstract class _$CheckoutDeliveryCharge extends $Notifier<double?> {
  double? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double?, double?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double?, double?>,
              double?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CheckoutRiderTip)
final checkoutRiderTipProvider = CheckoutRiderTipProvider._();

final class CheckoutRiderTipProvider
    extends $NotifierProvider<CheckoutRiderTip, double> {
  CheckoutRiderTipProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutRiderTipProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutRiderTipHash();

  @$internal
  @override
  CheckoutRiderTip create() => CheckoutRiderTip();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$checkoutRiderTipHash() => r'a586f843b08ca53f311ab29744b16c4d17e7864b';

abstract class _$CheckoutRiderTip extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(CheckoutDiscount)
final checkoutDiscountProvider = CheckoutDiscountProvider._();

final class CheckoutDiscountProvider
    extends $NotifierProvider<CheckoutDiscount, int> {
  CheckoutDiscountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutDiscountProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutDiscountHash();

  @$internal
  @override
  CheckoutDiscount create() => CheckoutDiscount();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$checkoutDiscountHash() => r'3ec6e050829b2b928f86ff74e4e72fb2f5cf5b08';

abstract class _$CheckoutDiscount extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
