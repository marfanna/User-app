import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/mappers/order_mapper.dart';
import '../../../../data/models/order/order_model.dart';
import '../../../../domain/entities/order_entity.dart';

final trackOrderProvider =
    FutureProvider.autoDispose.family<OrderEntity, String>((ref, id) async {
  final dio = ref.read(dioProvider);
  try {
    final response = await dio.get('orders/$id');
    final data = response.data['data'] as Map<String, dynamic>;
    return OrderModel.fromJson(data).toEntity();
  } on DioException catch (e) {
    final message = e.response?.data['message'] ?? e.message;
    throw Exception(message);
  } catch (e) {
    throw Exception(e.toString());
  }
});
