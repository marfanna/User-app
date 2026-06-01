import '../../../../domain/entities/rider_profile_entity.dart';
import '../rider_profile_ui_model.dart';

extension RiderProfileEntityToUiModel on RiderProfileEntity {
  RiderProfileUiModel toUiModel() {
    return RiderProfileUiModel(
      name: name,
      phone: phone,
      totalDeliveries: totalDeliveries,
      totalEarnings: totalEarnings,
    );
  }
}
