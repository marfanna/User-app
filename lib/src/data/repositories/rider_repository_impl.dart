import '../../core/base/base.dart';
import '../../domain/entities/franchise_rider_entity.dart';
import '../../domain/entities/rider_profile_entity.dart';
import '../../domain/repositories/rider_repository.dart';
import '../mappers/franchise_rider_mapper.dart';
import '../mappers/rider_profile_mapper.dart';
import '../models/rider/franchise_rider_model.dart';
import '../models/rider/rider_profile_model.dart';
import '../services/network/rest_client.dart';

class RiderRepositoryImpl extends RiderRepository {
  RiderRepositoryImpl({required RestClient remote}) : _remote = remote;

  final RestClient _remote;

  @override
  Future<Result<RiderProfileEntity, Failure>> getRiderProfile() {
    return asyncGuard(() async {
      final response = await _remote.riderProfile();

      return RiderProfileModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      ).toEntity();
    });
  }

  @override
  Future<Result<List<FranchiseRiderEntity>, Failure>> getFranchiseRiders({
    required String franchiseId,
  }) {
    return asyncGuard(() async {
      final response = await _remote.franchiseRiders(franchiseId);
      final riders = response.data['data'] as List<dynamic>;

      return riders.map((e) {
        return FranchiseRiderModel.fromJson(
          e as Map<String, dynamic>,
        ).toEntity();
      }).toList();
    });
  }
}
