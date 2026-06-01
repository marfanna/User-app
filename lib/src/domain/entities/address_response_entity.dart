import 'order_entity.dart';

class AddressResponseEntity {
  const AddressResponseEntity({
    required this.addresses,
    required this.defaultAddressIndex,
  });

  final List<AddressEntity> addresses;
  final int defaultAddressIndex;
}
