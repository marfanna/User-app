// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_position_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userPosition)
final userPositionProvider = UserPositionProvider._();

final class UserPositionProvider
    extends
        $FunctionalProvider<
          AsyncValue<Position?>,
          Position?,
          FutureOr<Position?>
        >
    with $FutureModifier<Position?>, $FutureProvider<Position?> {
  UserPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPositionHash();

  @$internal
  @override
  $FutureProviderElement<Position?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Position?> create(Ref ref) {
    return userPosition(ref);
  }
}

String _$userPositionHash() => r'46a4c196414eabca576ef9686d68c4f38525de90';
