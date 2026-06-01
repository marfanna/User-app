// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'undo_order_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UndoOrder)
final undoOrderProvider = UndoOrderFamily._();

final class UndoOrderProvider extends $AsyncNotifierProvider<UndoOrder, bool?> {
  UndoOrderProvider._({
    required UndoOrderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'undoOrderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$undoOrderHash();

  @override
  String toString() {
    return r'undoOrderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  UndoOrder create() => UndoOrder();

  @override
  bool operator ==(Object other) {
    return other is UndoOrderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$undoOrderHash() => r'3d305b6be3b9caeff2cc47fe815a530923bb7453';

final class UndoOrderFamily extends $Family
    with
        $ClassFamilyOverride<
          UndoOrder,
          AsyncValue<bool?>,
          bool?,
          FutureOr<bool?>,
          String
        > {
  UndoOrderFamily._()
    : super(
        retry: null,
        name: r'undoOrderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UndoOrderProvider call(String orderId) =>
      UndoOrderProvider._(argument: orderId, from: this);

  @override
  String toString() => r'undoOrderProvider';
}

abstract class _$UndoOrder extends $AsyncNotifier<bool?> {
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
