import '../../core/base/base.dart';
import '../entities/address_response_entity.dart';

abstract class AddressRepository extends Repository {
  Future<Result<AddressResponseEntity, Failure>> getAddresses();
}
