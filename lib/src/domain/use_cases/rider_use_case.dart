import '../../core/base/base.dart';
import '../entities/franchise_rider_entity.dart';
import '../entities/rider_profile_entity.dart';
import '../repositories/rider_repository.dart';

class GetRiderProfileUseCase {
  GetRiderProfileUseCase({required RiderRepository repository})
    : _repository = repository;

  final RiderRepository _repository;

  Future<Result<RiderProfileEntity, Failure>> call() {
    return _repository.getRiderProfile();
  }
}

class GetFranchiseRidersUseCase {
  GetFranchiseRidersUseCase({required RiderRepository repository})
    : _repository = repository;

  final RiderRepository _repository;

  Future<Result<List<FranchiseRiderEntity>, Failure>> call({
    required String franchiseId,
  }) {
    return _repository.getFranchiseRiders(franchiseId: franchiseId);
  }
}
