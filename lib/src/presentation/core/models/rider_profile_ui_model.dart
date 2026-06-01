class RiderProfileUiModel {
  const RiderProfileUiModel({
    required this.name,
    required this.phone,
    required this.totalDeliveries,
    required this.totalEarnings,
  });

  final String name;
  final String phone;
  final int totalDeliveries;
  final double totalEarnings;
}
