import '../../core/base/base.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrderUseCase {
  GetOrderUseCase({required OrderRepository repository})
    : _repository = repository;

  final OrderRepository _repository;

  Future<Result<OrderEntity, Failure>> call({required String orderId}) {
    return _repository.getOrder(orderId: orderId);
  }
}
