// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DisputeNotifier)
final disputeProvider = DisputeNotifierProvider._();

final class DisputeNotifierProvider
    extends $NotifierProvider<DisputeNotifier, DisputeState> {
  DisputeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disputeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disputeNotifierHash();

  @$internal
  @override
  DisputeNotifier create() => DisputeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DisputeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DisputeState>(value),
    );
  }
}

String _$disputeNotifierHash() => r'e134494660458af9c90cef4717ae83b365cf8ddc';

abstract class _$DisputeNotifier extends $Notifier<DisputeState> {
  DisputeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<DisputeState, DisputeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DisputeState, DisputeState>,
              DisputeState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(myDisputes)
final myDisputesProvider = MyDisputesProvider._();

final class MyDisputesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DisputeTicket>>,
          List<DisputeTicket>,
          FutureOr<List<DisputeTicket>>
        >
    with
        $FutureModifier<List<DisputeTicket>>,
        $FutureProvider<List<DisputeTicket>> {
  MyDisputesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myDisputesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myDisputesHash();

  @$internal
  @override
  $FutureProviderElement<List<DisputeTicket>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DisputeTicket>> create(Ref ref) {
    return myDisputes(ref);
  }
}

String _$myDisputesHash() => r'1488f42a928278d280c9e0d6a7e102723303b257';
