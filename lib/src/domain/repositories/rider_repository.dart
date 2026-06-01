import '../../core/base/base.dart';
import '../entities/franchise_rider_entity.dart';
import '../entities/rider_profile_entity.dart';

abstract class RiderRepository extends Repository {
  Future<Result<RiderProfileEntity, Failure>> getRiderProfile();

  Future<Result<List<FranchiseRiderEntity>, Failure>> getFranchiseRiders({
    required String franchiseId,
  });
}
