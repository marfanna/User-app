// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CartNotifier)
final cartProvider = CartNotifierProvider._();

final class CartNotifierProvider
    extends $NotifierProvider<CartNotifier, List<CartItemModel>> {
  CartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartNotifierHash();

  @$internal
  @override
  CartNotifier create() => CartNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CartItemModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CartItemModel>>(value),
    );
  }
}

String _$cartNotifierHash() => r'98b2af176b20604e1d88c9e007604620389fde83';

abstract class _$CartNotifier extends $Notifier<List<CartItemModel>> {
  List<CartItemModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<CartItemModel>, List<CartItemModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CartItemModel>, List<CartItemModel>>,
              List<CartItemModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
