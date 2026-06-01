import 'package:dart_mappable/dart_mappable.dart';

part 'rider_summary_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class RiderSummaryModel with RiderSummaryModelMappable {
  const RiderSummaryModel({
    this.totalCompletedDeliveries,
    this.todayCompletedDeliveries,
    this.todayPurchaseTotal,
  });

  final int? totalCompletedDeliveries;
  final int? todayCompletedDeliveries;
  final int? todayPurchaseTotal;

  static final fromJson = RiderSummaryModelMapper.fromJson;
}
