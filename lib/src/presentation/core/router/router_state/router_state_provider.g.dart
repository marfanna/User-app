// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router_state_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RouterState)
final routerStateProvider = RouterStateProvider._();

final class RouterStateProvider
    extends $NotifierProvider<RouterState, String?> {
  RouterStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerStateHash();

  @$internal
  @override
  RouterState create() => RouterState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$routerStateHash() => r'67b7570b4476f7b088f0ed4c08d8f132f54075b0';

abstract class _$RouterState extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
