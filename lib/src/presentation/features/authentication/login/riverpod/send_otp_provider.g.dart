// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendOtp)
final sendOtpProvider = SendOtpProvider._();

final class SendOtpProvider
    extends $NotifierProvider<SendOtp, AsyncValue<bool>> {
  SendOtpProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendOtpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendOtpHash();

  @$internal
  @override
  SendOtp create() => SendOtp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<bool> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<bool>>(value),
    );
  }
}

String _$sendOtpHash() => r'b5d81d8968a561673018047e96dced01382a64b3';

abstract class _$SendOtp extends $Notifier<AsyncValue<bool>> {
  AsyncValue<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, AsyncValue<bool>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, AsyncValue<bool>>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
