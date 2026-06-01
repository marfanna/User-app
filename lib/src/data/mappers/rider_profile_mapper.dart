import '../../domain/entities/rider_profile_entity.dart';
import '../models/rider/rider_profile_model.dart';

extension RiderProfileModelToEntity on RiderProfileModel {
  RiderProfileEntity toEntity() {
    final info = riderInfo;

    return RiderProfileEntity(
      id: id ?? '',
      name: name ?? '',
      phone: phone ?? '',
      email: email ?? '',
      status: status ?? '',
      isPhoneVerified: isPhoneVerified ?? false,
      isAvailable: info?.isAvailable ?? false,
      vehicleType: info?.vehicleType,
      franchiseId: franchiseId?.id,
      franchiseName: franchiseId?.name,
      totalDeliveries: info?.totalDeliveries ?? 0,
      completedDeliveries: info?.completedDeliveries ?? 0,
      onTimeDeliveries: info?.onTimeDeliveries ?? 0,
      totalEarnings: info?.totalEarnings ?? 0.0,
      totalTips: info?.totalTips ?? 0.0,
      averageRating: info?.averageRating ?? 0.0,
      currentStreak: info?.currentStreak ?? 0,
      longestStreak: info?.longestStreak ?? 0,
      totalWorkingHours: info?.totalWorkingHours ?? 0.0,
    );
  }
}
