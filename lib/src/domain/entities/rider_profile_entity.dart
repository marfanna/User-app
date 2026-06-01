class RiderProfileEntity {
  const RiderProfileEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.status,
    required this.isPhoneVerified,
    required this.totalDeliveries,
    required this.completedDeliveries,
    required this.onTimeDeliveries,
    required this.totalEarnings,
    required this.totalTips,
    required this.averageRating,
    required this.currentStreak,
    required this.longestStreak,
    required this.totalWorkingHours,
    required this.isAvailable,
    this.vehicleType,
    this.franchiseId,
    this.franchiseName,
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final String status;
  final bool isPhoneVerified;
  final bool isAvailable;
  final String? vehicleType;
  final String? franchiseId;
  final String? franchiseName;
  final int totalDeliveries;
  final int completedDeliveries;
  final int onTimeDeliveries;
  final double totalEarnings;
  final double totalTips;
  final double averageRating;
  final int currentStreak;
  final int longestStreak;
  final double totalWorkingHours;
}
