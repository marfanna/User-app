import '../../domain/entities/franchise_rider_entity.dart';
import '../models/rider/franchise_rider_model.dart';

extension FranchiseRiderModelToEntity on FranchiseRiderModel {
  FranchiseRiderEntity toEntity() {
    return FranchiseRiderEntity(
      id: id ?? '',
      name: name ?? '',
      phone: phone ?? '',
    );
  }
}
