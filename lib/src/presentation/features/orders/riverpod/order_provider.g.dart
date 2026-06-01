// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(order)
final orderProvider = OrderFamily._();

final class OrderProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrderDetailsUIModel>,
          OrderDetailsUIModel,
          FutureOr<OrderDetailsUIModel>
        >
    with
        $FutureModifier<OrderDetailsUIModel>,
        $FutureProvider<OrderDetailsUIModel> {
  OrderProvider._({
    required OrderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'orderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$orderHash();

  @override
  String toString() {
    return r'orderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<OrderDetailsUIModel> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OrderDetailsUIModel> create(Ref ref) {
    final argument = this.argument as String;
    return order(ref, orderId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$orderHash() => r'2302e0466a45f6d2da98c1cbf123ff721b3e5908';

final class OrderFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<OrderDetailsUIModel>, String> {
  OrderFamily._()
    : super(
        retry: null,
        name: r'orderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OrderProvider call({required String orderId}) =>
      OrderProvider._(argument: orderId, from: this);

  @override
  String toString() => r'orderProvider';
}
