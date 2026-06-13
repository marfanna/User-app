import '../../core/base/base.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository extends Repository {
  Future<Result<OrderEntity, Failure>> getOrder({required String orderId});
}
