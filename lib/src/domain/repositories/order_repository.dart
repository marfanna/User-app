import '../../core/base/base.dart';
import '../entities/order_entity.dart';
import '../entities/rider_summary_entity.dart';

abstract class OrderRepository extends Repository {
  Future<Result<List<OrderEntity>, Failure>> getPendingOrders({
    required int page,
    int limit = 10,
  });

  Future<Result<List<OrderEntity>, Failure>> getCompletedOrders({
    required int page,
    int limit = 10,
  });

  Future<Result<List<OrderEntity>, Failure>> getRejectedOrders({
    required int page,
    int limit = 10,
  });

  Future<Result<OrderEntity, Failure>> getOrder({required String orderId});

  Future<Result<bool, Failure>> acceptOrder({required String orderId});

  Future<Result<bool, Failure>> pickUpOrder({required String orderId});

  Future<Result<bool, Failure>> deliverOrder({required String orderId});

  Future<Result<bool, Failure>> rejectOrder({
    required String orderId,
    required String reason,
  });

  Future<Result<bool, Failure>> undoOrder({required String orderId});

  Future<Result<bool, Failure>> transferOrder({
    required String orderId,
    required String toRiderId,
    required String reason,
  });

  Future<Result<RiderSummaryEntity, Failure>> getRiderSummary();
}
