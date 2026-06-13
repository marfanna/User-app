import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../home/models/shop_data.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';

final favouriteShopsProvider =
    FutureProvider.autoDispose<List<ShopData>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('users/favourite-shops');
  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];

  List<dynamic> list;
  if (raw is List) {
    list = raw;
  } else {
    list = [];
  }

  return list.whereType<Map<String, dynamic>>().map((json) {
    final images = json['images'] as Map<String, dynamic>?;
    final address = json['address'] as Map<String, dynamic>?;
    final pause = json['emergencyPause'] as Map<String, dynamic>?;
    final isPaused = pause?['isPaused'] as bool? ?? false;

    return ShopData(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      logo: images?['logo'] as String? ?? json['logo'] as String?,
      banner: images?['banner'] as String?
          ?? json['coverImage'] as String?,
      area: address?['area'] as String?
          ?? address?['district'] as String?,
      isOpen: !isPaused,
      isPaused: isPaused,
      pauseReason: pause?['pauseReason'] as String?,
    );
  }).toList();
});

final favouriteProductsProvider =
    FutureProvider.autoDispose<List<({ApiMenuItemData item, String shopName, String shopId})>>((ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('users/favourite-products');
  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];

  List<dynamic> list;
  if (raw is List) {
    list = raw;
  } else {
    list = [];
  }

  return list.whereType<Map<String, dynamic>>().map((json) {
    final itemJson = {
      'id': (json['itemId'] ?? json['_id'] ?? json['id'] ?? '') as String,
      'name': (json['name'] ?? '') as String,
      'price': json['price'] ?? 0.0,
      'image': json['image'] as String?,
      'description': json['description'] as String?,
      'isAvailable': true,
    };
    final item = ApiMenuItemData.fromJson(itemJson);
    final shopName = (json['shopName'] ?? '') as String;
    final shopId = (json['shopId'] ?? '') as String;
    return (item: item, shopName: shopName, shopId: shopId);
  }).toList();
});
