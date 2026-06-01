import '../../domain/entities/rider_summary_entity.dart';
import '../models/order/rider_summary_model.dart';

extension RiderSummaryModelToEntity on RiderSummaryModel {
  RiderSummaryEntity toEntity() {
    return RiderSummaryEntity(
      totalCompletedDeliveries: totalCompletedDeliveries ?? 0,
      todayCompletedDeliveries: todayCompletedDeliveries ?? 0,
      todayPurchaseTotal: todayPurchaseTotal ?? 0,
    );
  }
}
