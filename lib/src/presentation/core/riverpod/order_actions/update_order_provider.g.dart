// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdateOrder)
final updateOrderProvider = UpdateOrderFamily._();

final class UpdateOrderProvider
    extends $AsyncNotifierProvider<UpdateOrder, bool?> {
  UpdateOrderProvider._({
    required UpdateOrderFamily super.from,
    required (String, UpdateOrderStatus) super.argument,
  }) : super(
         retry: null,
         name: r'updateOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$updateOrderHash();

  @override
  String toString() {
    return r'updateOrderProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  UpdateOrder create() => UpdateOrder();

  @override
  bool operator ==(Object other) {
    return other is UpdateOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$updateOrderHash() => r'30152b7f4c91db320320503d42c303eab4d97b43';

final class UpdateOrderFamily extends $Family
    with
        $ClassFamilyOverride<
          UpdateOrder,
          AsyncValue<bool?>,
          bool?,
          FutureOr<bool?>,
          (String, UpdateOrderStatus)
        > {
  UpdateOrderFamily._()
    : super(
        retry: null,
        name: r'updateOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UpdateOrderProvider call(String orderId, UpdateOrderStatus status) =>
      UpdateOrderProvider._(argument: (orderId, status), from: this);

  @override
  String toString() => r'updateOrderProvider';
}

abstract class _$UpdateOrder extends $AsyncNotifier<bool?> {
  late final _$args = ref.$arg as (String, UpdateOrderStatus);
  String get orderId => _$args.$1;
  UpdateOrderStatus get status => _$args.$2;

  FutureOr<bool?> build(String orderId, UpdateOrderStatus status);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool?>, bool?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool?>, bool?>,
              AsyncValue<bool?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
