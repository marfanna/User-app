import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/shop_category_model.dart';

// Provides the active shop categories from the backend
final categoriesProvider = FutureProvider.autoDispose<List<ShopCategoryModel>>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('shop-category/active');

  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  List<dynamic> list;
  if (raw is List) {
    list = raw;
  } else {
    list = [];
  }

  return list
      .whereType<Map<String, dynamic>>()
      .map(ShopCategoryModel.fromJson)
      .toList();
});

// Provides the currently selected category value, default to 'restaurant'
// StateProvider was removed in Riverpod 3.x — use NotifierProvider instead
class SelectedCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'restaurant';

  void select(String category) => state = category;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String>(
      SelectedCategoryNotifier.new,
    );
