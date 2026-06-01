// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_orders_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(recentOrders)
final recentOrdersProvider = RecentOrdersProvider._();

final class RecentOrdersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<OrderUIModel>>,
          List<OrderUIModel>,
          FutureOr<List<OrderUIModel>>
        >
    with
        $FutureModifier<List<OrderUIModel>>,
        $FutureProvider<List<OrderUIModel>> {
  RecentOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentOrdersHash();

  @$internal
  @override
  $FutureProviderElement<List<OrderUIModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<OrderUIModel>> create(Ref ref) {
    return recentOrders(ref);
  }
}

String _$recentOrdersHash() => r'54667e1a2b4293ce0b599cbba0fa3be3be1172b6';
