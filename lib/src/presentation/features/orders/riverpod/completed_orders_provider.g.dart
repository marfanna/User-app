// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completedOrders)
final completedOrdersProvider = CompletedOrdersFamily._();

final class CompletedOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderUIModel>>,
          List<OrderUIModel>,
          FutureOr<List<OrderUIModel>>
        >
    with
        $FutureModifier<List<OrderUIModel>>,
        $FutureProvider<List<OrderUIModel>> {
  CompletedOrdersProvider._({
    required CompletedOrdersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'completedOrdersProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$completedOrdersHash();

  @override
  String toString() {
    return r'completedOrdersProvider'
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
    return completedOrders(ref, page: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CompletedOrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$completedOrdersHash() => r'3ea7497f80fb06511057ca45821f10277124523f';

final class CompletedOrdersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<OrderUIModel>>, int> {
  CompletedOrdersFamily._()
    : super(
        retry: null,
        name: r'completedOrdersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  CompletedOrdersProvider call({required int page}) =>
      CompletedOrdersProvider._(argument: page, from: this);

  @override
  String toString() => r'completedOrdersProvider';
}
