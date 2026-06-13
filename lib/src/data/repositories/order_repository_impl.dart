import '../../core/base/base.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../mappers/order_mapper.dart';
import '../models/order/order_model.dart';
import '../services/network/rest_client.dart';

class OrderRepositoryImpl extends OrderRepository {
  OrderRepositoryImpl({required RestClient remote}) : _remote = remote;

  final RestClient _remote;

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
}
