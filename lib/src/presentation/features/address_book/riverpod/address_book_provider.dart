import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/address_response_entity.dart';

part 'address_book_provider.g.dart';

@riverpod
Future<AddressResponseEntity> addressBook(Ref ref) async {
  final repository = ref.read(addressRepositoryProvider);
  final result = await repository.getAddresses();

  return result.when(
    success: (data) => data!,
    error: (error) => throw error,
  );
}

/// Holds the user-selected address index; null = use API defaultAddressIndex.
@riverpod
class SelectedAddressIndex extends _$SelectedAddressIndex {
  @override
  int? build() => null;
}
