// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rejected_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(rejectedOrders)
final rejectedOrdersProvider = RejectedOrdersFamily._();

final class RejectedOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderUIModel>>,
          List<OrderUIModel>,
          FutureOr<List<OrderUIModel>>
        >
    with
        $FutureModifier<List<OrderUIModel>>,
        $FutureProvider<List<OrderUIModel>> {
  RejectedOrdersProvider._({
    required RejectedOrdersFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'rejectedOrdersProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rejectedOrdersHash();

  @override
  String toString() {
    return r'rejectedOrdersProvider'
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
    return rejectedOrders(ref, page: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RejectedOrdersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rejectedOrdersHash() => r'12db4fd57e47cf189d418859c0a7f25c00652ece';

final class RejectedOrdersFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<OrderUIModel>>, int> {
  RejectedOrdersFamily._()
    : super(
        retry: null,
        name: r'rejectedOrdersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  RejectedOrdersProvider call({required int page}) =>
      RejectedOrdersProvider._(argument: page, from: this);

  @override
  String toString() => r'rejectedOrdersProvider';
}
