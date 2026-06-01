// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_book_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(addressBook)
final addressBookProvider = AddressBookProvider._();

final class AddressBookProvider
    extends
        $FunctionalProvider<
          AsyncValue<AddressResponseEntity>,
          AddressResponseEntity,
          FutureOr<AddressResponseEntity>
        >
    with
        $FutureModifier<AddressResponseEntity>,
        $FutureProvider<AddressResponseEntity> {
  AddressBookProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressBookProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressBookHash();

  @$internal
  @override
  $FutureProviderElement<AddressResponseEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AddressResponseEntity> create(Ref ref) {
    return addressBook(ref);
  }
}

String _$addressBookHash() => r'a5d1ed27ac8ce62df5d0b96db85bfc2ef8095a8f';

/// Holds the user-selected address index; null = use API defaultAddressIndex.

@ProviderFor(SelectedAddressIndex)
final selectedAddressIndexProvider = SelectedAddressIndexProvider._();

/// Holds the user-selected address index; null = use API defaultAddressIndex.
final class SelectedAddressIndexProvider
    extends $NotifierProvider<SelectedAddressIndex, int?> {
  /// Holds the user-selected address index; null = use API defaultAddressIndex.
  SelectedAddressIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedAddressIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedAddressIndexHash();

  @$internal
  @override
  SelectedAddressIndex create() => SelectedAddressIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$selectedAddressIndexHash() =>
    r'1f7abcbdbc4f44934d138e9650199da926a33315';

/// Holds the user-selected address index; null = use API defaultAddressIndex.

abstract class _$SelectedAddressIndex extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
