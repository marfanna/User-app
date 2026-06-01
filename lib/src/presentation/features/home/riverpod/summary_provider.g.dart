// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(riderSummary)
final riderSummaryProvider = RiderSummaryProvider._();

final class RiderSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<RiderSummaryEntity>,
          RiderSummaryEntity,
          FutureOr<RiderSummaryEntity>
        >
    with
        $FutureModifier<RiderSummaryEntity>,
        $FutureProvider<RiderSummaryEntity> {
  RiderSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'riderSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$riderSummaryHash();

  @$internal
  @override
  $FutureProviderElement<RiderSummaryEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RiderSummaryEntity> create(Ref ref) {
    return riderSummary(ref);
  }
}

String _$riderSummaryHash() => r'524efaa16edace6e4f154db443ec1272ae92b644';
