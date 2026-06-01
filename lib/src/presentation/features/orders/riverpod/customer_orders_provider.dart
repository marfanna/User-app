import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/customer_order_model.dart';

final customerOrdersProvider =
    FutureProvider.autoDispose<List<CustomerOrderModel>>((ref) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        'orders/my-orders',
        queryParameters: {
          'limit': '50',
          'sortBy': 'createdAt',
          'sortOrder': 'desc',
        },
      );

      final body = response.data;
      List<dynamic> list;
      if (body is List) {
        list = body;
      } else if (body is Map) {
        final data = body['data'];
        if (data is List) {
          list = data;
        } else if (data is Map && data['orders'] is List) {
          list = data['orders'] as List;
        } else {
          list = [];
        }
      } else {
        list = [];
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map(CustomerOrderModel.fromJson)
          .toList();
    });
