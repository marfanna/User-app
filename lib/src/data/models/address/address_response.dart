import 'package:dart_mappable/dart_mappable.dart';

import '../order/order_model.dart';

part 'address_response.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class AddressResponse with AddressResponseMappable {
  const AddressResponse({
    this.addresses = const [],
    this.defaultAddressIndex = 0,
  });

  final List<AddressModel> addresses;
  final int defaultAddressIndex;

  static final fromJson = AddressResponseMapper.fromJson;
}
