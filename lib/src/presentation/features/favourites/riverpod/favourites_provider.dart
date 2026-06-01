import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../home/models/shop_data.dart';

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
