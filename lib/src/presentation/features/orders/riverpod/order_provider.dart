import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/mappers/order_mapper.dart';
import '../../../../data/models/order/order_model.dart';
import '../../../core/models/mappers/order_details_ui_model_mapper.dart';
import '../../../core/models/order_details_ui_model.dart';

part 'order_provider.g.dart';

@riverpod
FutureOr<OrderDetailsUIModel> order(Ref ref, {required String orderId}) async {
  final dio = ref.read(dioProvider);
  try {
    final response = await dio.get('orders/$orderId');
    final data = response.data['data'] as Map<String, dynamic>;
    final orderModel = OrderModel.fromJson(data);
    return orderModel.toEntity().toDetailsUIModel();
  } on DioException catch (e) {
    final message = e.response?.data['message'] ?? e.message;
    throw Exception(message);
  } catch (e) {
    throw Exception(e.toString());
  }
}
