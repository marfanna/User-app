// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_events_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderEvents)
final orderEventsProvider = OrderEventsProvider._();

final class OrderEventsProvider
    extends $NotifierProvider<OrderEvents, (OrderEvent, int)?> {
  OrderEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderEventsHash();

  @$internal
  @override
  OrderEvents create() => OrderEvents();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((OrderEvent, int)? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(OrderEvent, int)?>(value),
    );
  }
}

String _$orderEventsHash() => r'541e985c5b052b9f56a56f74c8aa6a3cf814905d';

abstract class _$OrderEvents extends $Notifier<(OrderEvent, int)?> {
  (OrderEvent, int)? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<(OrderEvent, int)?, (OrderEvent, int)?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<(OrderEvent, int)?, (OrderEvent, int)?>,
              (OrderEvent, int)?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
