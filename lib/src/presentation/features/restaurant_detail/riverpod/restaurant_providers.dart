import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/restaurant_api_models.dart';

final restaurantDetailProvider = FutureProvider.autoDispose
    .family<RestaurantData, String>((ref, restaurantId) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get('shops/public/$restaurantId');
      final data = response.data['data'] as Map<String, dynamic>;
      return RestaurantData.fromJson(data);
    });

final restaurantMenuProvider = FutureProvider.autoDispose
    .family<MenuData, String>((ref, restaurantId) async {
      final dio = ref.read(dioProvider);
      final response = await dio.get('menu/shop/$restaurantId');
      final data = response.data['data'] as Map<String, dynamic>;
      return MenuData.fromJson(data);
    });
