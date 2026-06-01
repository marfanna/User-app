// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(riderProfile)
final riderProfileProvider = RiderProfileProvider._();

final class RiderProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<RiderProfileUiModel>,
          RiderProfileUiModel,
          FutureOr<RiderProfileUiModel>
        >
    with
        $FutureModifier<RiderProfileUiModel>,
        $FutureProvider<RiderProfileUiModel> {
  RiderProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'riderProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$riderProfileHash();

  @$internal
  @override
  $FutureProviderElement<RiderProfileUiModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RiderProfileUiModel> create(Ref ref) {
    return riderProfile(ref);
  }
}

String _$riderProfileHash() => r'a190ac3bee607ae4fdec30faa662ff3e08245b8d';
