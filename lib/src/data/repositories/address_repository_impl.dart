import '../../core/base/base.dart';
import '../../domain/entities/address_response_entity.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../models/address/address_response.dart';
import '../services/network/rest_client.dart';

class AddressRepositoryImpl extends AddressRepository {
  AddressRepositoryImpl({required RestClient remote}) : _remote = remote;

  final RestClient _remote;

  @override
  Future<Result<AddressResponseEntity, Failure>> getAddresses() {
    return asyncGuard(() async {
      final response = await _remote.getAddresses();
      final data = response.data;

      final responseModel = AddressResponse.fromJson(data['data'] as Map<String, dynamic>);

      final addresses = responseModel.addresses.map((a) {
        CoordinatesEntity? coords;
        if (a.coordinates?.coordinates != null &&
            a.coordinates!.coordinates!.length >= 2) {
          coords = CoordinatesEntity(
            latitude: a.coordinates!.coordinates![1],
            longitude: a.coordinates!.coordinates![0],
          );
        }
        return AddressEntity(
          id: a.id,
          type: a.type,
          street: a.street ?? '',
          city: a.city ?? '',
          district: a.district ?? '',
          division: a.division ?? '',
          landmark: a.landmark,
          phone: a.phone,
          coordinates: coords,
        );
      }).toList();

      return AddressResponseEntity(
        addresses: addresses,
        defaultAddressIndex: responseModel.defaultAddressIndex,
      );
    });
  }
}
