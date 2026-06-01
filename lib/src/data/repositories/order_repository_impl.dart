import '../../core/base/base.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/rider_summary_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../mappers/order_mapper.dart';
import '../mappers/rider_summary_mapper.dart';
import '../models/order/order_model.dart';
import '../models/order/rider_summary_model.dart';
import '../services/network/rest_client.dart';

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl({required RestClient remote}) : _remote = remote;

  final RestClient _remote;

  @override
  Future<Result<List<OrderEntity>, Failure>> getPendingOrders({
    required int page,
    int limit = 10,
  }) async {
    return asyncGuard(() async {
      final response = await _remote.myOrders(
        page: page,
        limit: limit,
        status: 'assigned,picked_up,pending',
      );

      return _mapOrders(response.data['data'] as List<dynamic>);
    });
  }

  @override
  Future<Result<List<OrderEntity>, Failure>> getCompletedOrders({
    required int page,
    int limit = 10,
  }) async {
    return asyncGuard(() async {
      final response = await _remote.myOrders(
        page: page,
        limit: limit,
        status: 'delivered',
      );

      return _mapOrders(response.data['data'] as List<dynamic>);
    });
  }

  @override
  Future<Result<List<OrderEntity>, Failure>> getRejectedOrders({
    required int page,
    int limit = 10,
  }) async {
    return asyncGuard(() async {
      final response = await _remote.myOrders(
        page: page,
        limit: limit,
        status: 'rejected',
      );

      return _mapOrders(response.data['data'] as List<dynamic>);
    });
  }

  List<OrderEntity> _mapOrders(List<dynamic> ordersData) {
    return ordersData
        .map((e) => OrderModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<Result<OrderEntity, Failure>> getOrder({
    required String orderId,
  }) async {
    return asyncGuard(() async {
      final response = await _remote.order(orderId);

      return OrderModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      ).toEntity();
    });
  }

  @override
  Future<Result<bool, Failure>> acceptOrder({required String orderId}) {
    return asyncGuard(() async {
      await _remote.orderStatus(orderId, 'accept');
      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> pickUpOrder({required String orderId}) {
    return asyncGuard(() async {
      await _remote.orderStatus(
        orderId,
        'status',
        body: {'status': 'picked_up'},
      );
      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> deliverOrder({required String orderId}) {
    return asyncGuard(() async {
      await _remote.orderStatus(
        orderId,
        'status',
        body: {'status': 'delivered'},
      );
      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> rejectOrder({
    required String orderId,
    required String reason,
  }) {
    return asyncGuard(() async {
      await _remote.orderStatus(orderId, 'reject', body: {'reason': reason});
      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> undoOrder({required String orderId}) {
    return asyncGuard(() async {
      await _remote.orderStatus(orderId, 'undo');
      return true;
    });
  }

  @override
  Future<Result<bool, Failure>> transferOrder({
    required String orderId,
    required String toRiderId,
    required String reason,
  }) {
    return asyncGuard(() async {
      await _remote.transferOrder(orderId, {
        'toRiderId': toRiderId,
        'reason': reason,
      });
      return true;
    });
  }

  @override
  Future<Result<RiderSummaryEntity, Failure>> getRiderSummary() {
    return asyncGuard(() async {
      final response = await _remote.mySummary();

      return RiderSummaryModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      ).toEntity();
    });
  }
}
