// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reject_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RejectOrder)
final rejectOrderProvider = RejectOrderFamily._();

final class RejectOrderProvider
    extends $AsyncNotifierProvider<RejectOrder, bool?> {
  RejectOrderProvider._({
    required RejectOrderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rejectOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rejectOrderHash();

  @override
  String toString() {
    return r'rejectOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  RejectOrder create() => RejectOrder();

  @override
  bool operator ==(Object other) {
    return other is RejectOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rejectOrderHash() => r'7146c7e8edcb37531c6393c2739dd85c3466d33c';

final class RejectOrderFamily extends $Family
    with
        $ClassFamilyOverride<
          RejectOrder,
          AsyncValue<bool?>,
          bool?,
          FutureOr<bool?>,
          String
        > {
  RejectOrderFamily._()
    : super(
        retry: null,
        name: r'rejectOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RejectOrderProvider call(String orderId) =>
      RejectOrderProvider._(argument: orderId, from: this);

  @override
  String toString() => r'rejectOrderProvider';
}

abstract class _$RejectOrder extends $AsyncNotifier<bool?> {
  late final _$args = ref.$arg as String;
  String get orderId => _$args;

  FutureOr<bool?> build(String orderId);
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
    element.handleCreate(ref, () => build(_$args));
  }
}
