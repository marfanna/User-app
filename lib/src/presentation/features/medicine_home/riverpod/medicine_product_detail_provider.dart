import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/medicine_product_detail.dart';

/// Fetches a single medicine product by id (`GET /medicine-products/:id`).
final medicineProductDetailProvider = FutureProvider.autoDispose
    .family<MedicineProductDetail, String>((ref, id) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get('medicine-products/$id');

      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      if (data == null) {
        throw StateError('Product not found');
      }
      return MedicineProductDetail.fromJson(data);
    });
