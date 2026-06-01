// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TransferOrder)
final transferOrderProvider = TransferOrderFamily._();

final class TransferOrderProvider
    extends $AsyncNotifierProvider<TransferOrder, bool?> {
  TransferOrderProvider._({
    required TransferOrderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transferOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transferOrderHash();

  @override
  String toString() {
    return r'transferOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TransferOrder create() => TransferOrder();

  @override
  bool operator ==(Object other) {
    return other is TransferOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transferOrderHash() => r'85ddd8973761f2c2f85df3924d88ff24814cb5dd';

final class TransferOrderFamily extends $Family
    with
        $ClassFamilyOverride<
          TransferOrder,
          AsyncValue<bool?>,
          bool?,
          FutureOr<bool?>,
          String
        > {
  TransferOrderFamily._()
    : super(
        retry: null,
        name: r'transferOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TransferOrderProvider call(String orderId) =>
      TransferOrderProvider._(argument: orderId, from: this);

  @override
  String toString() => r'transferOrderProvider';
}

abstract class _$TransferOrder extends $AsyncNotifier<bool?> {
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
