// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'franchise_riders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(franchiseRiders)
final franchiseRidersProvider = FranchiseRidersProvider._();

final class FranchiseRidersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<FranchiseRiderEntity>>,
          List<FranchiseRiderEntity>,
          FutureOr<List<FranchiseRiderEntity>>
        >
    with
        $FutureModifier<List<FranchiseRiderEntity>>,
        $FutureProvider<List<FranchiseRiderEntity>> {
  FranchiseRidersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'franchiseRidersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$franchiseRidersHash();

  @$internal
  @override
  $FutureProviderElement<List<FranchiseRiderEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<FranchiseRiderEntity>> create(Ref ref) {
    return franchiseRiders(ref);
  }
}

String _$franchiseRidersHash() => r'93189d56f86630103995bb1cfe040100fc0c9ca0';
