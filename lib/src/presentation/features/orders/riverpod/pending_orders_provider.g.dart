// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pendingOrders)
final pendingOrdersProvider = PendingOrdersFamily._();

final class PendingOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderUIModel>>,
          List<OrderUIModel>,
          FutureOr<List<OrderUIModel>>
        >
    with
        $FutureModifier<List<OrderUIModel>>,
        $FutureProvider<List<OrderUIModel>> {
  PendingOrdersProvider._({
    required PendingOrdersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'pendingOrdersProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$pendingOrdersHash();

  @override
  String toString() {
    return r'pendingOrdersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<OrderUIModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderUIModel>> create(Ref ref) {
    final argument = this.argument as int;
    return pendingOrders(ref, page: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PendingOrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$pendingOrdersHash() => r'e85baf3304e2c6e55fdca1527e5023e7b18bce9d';

final class PendingOrdersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<OrderUIModel>>, int> {
  PendingOrdersFamily._()
    : super(
        retry: null,
        name: r'pendingOrdersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PendingOrdersProvider call({required int page}) =>
      PendingOrdersProvider._(argument: page, from: this);

  @override
  String toString() => r'pendingOrdersProvider';
}
