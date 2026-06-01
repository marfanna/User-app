class RiderSummaryEntity {
  const RiderSummaryEntity({
    required this.totalCompletedDeliveries,
    required this.todayCompletedDeliveries,
    required this.todayPurchaseTotal,
  });

  final int totalCompletedDeliveries;
  final int todayCompletedDeliveries;
  final int todayPurchaseTotal;
}
