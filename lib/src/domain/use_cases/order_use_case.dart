import '../../core/base/base.dart';
import '../entities/order_entity.dart';
import '../entities/rider_summary_entity.dart';
import '../repositories/order_repository.dart';

class GetPendingOrdersUseCase {
  GetPendingOrdersUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<List<OrderEntity>, Failure>> call({
    required int page,
    int limit = 10,
  }) {
    return _repository.getPendingOrders(page: page, limit: limit);
  }
}

class GetCompletedOrdersUseCase {
  GetCompletedOrdersUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<List<OrderEntity>, Failure>> call({
    required int page,
    int limit = 10,
  }) {
    return _repository.getCompletedOrders(page: page, limit: limit);
  }
}

class GetRejectedOrdersUseCase {
  GetRejectedOrdersUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<List<OrderEntity>, Failure>> call({
    required int page,
    int limit = 10,
  }) {
    return _repository.getRejectedOrders(page: page, limit: limit);
  }
}

class GetOrderUseCase {
  GetOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<OrderEntity, Failure>> call({required String orderId}) {
    return _repository.getOrder(orderId: orderId);
  }
}

class AcceptOrderUseCase {
  AcceptOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<bool, Failure>> call(String orderId) {
    return _repository.acceptOrder(orderId: orderId);
  }
}

class PickUpOrderUseCase {
  PickUpOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<bool, Failure>> call(String orderId) {
    return _repository.pickUpOrder(orderId: orderId);
  }
}

class DeliverOrderUseCase {
  DeliverOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<bool, Failure>> call(String orderId) {
    return _repository.deliverOrder(orderId: orderId);
  }
}

class RejectOrderUseCase {
  RejectOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<bool, Failure>> call({
    required String orderId,
    required String reason,
  }) {
    return _repository.rejectOrder(orderId: orderId, reason: reason);
  }
}

class UndoOrderUseCase {
  UndoOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<bool, Failure>> call({required String orderId}) {
    return _repository.undoOrder(orderId: orderId);
  }
}

class TransferOrderUseCase {
  TransferOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<bool, Failure>> call({
    required String orderId,
    required String toRiderId,
    required String reason,
  }) {
    return _repository.transferOrder(
      orderId: orderId,
      toRiderId: toRiderId,
      reason: reason,
    );
  }
}

class GetRiderSummaryUseCase {
  GetRiderSummaryUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<RiderSummaryEntity, Failure>> call() {
    return _repository.getRiderSummary();
  }
}
