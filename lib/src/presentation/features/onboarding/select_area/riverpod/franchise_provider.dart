import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../models/franchise_model.dart';

final franchisesProvider = FutureProvider.autoDispose<List<FranchiseModel>>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('franchises/get-all-franchise');
  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  List<dynamic> list;
  if (raw is List) {
    list = raw;
  } else if (raw is Map && raw['franchises'] is List) {
    list = raw['franchises'] as List;
  } else {
    list = [];
  }
  return list
      .whereType<Map<String, dynamic>>()
      .map(FranchiseModel.fromJson)
      .where((f) => f.isActive)
      .toList();
});
