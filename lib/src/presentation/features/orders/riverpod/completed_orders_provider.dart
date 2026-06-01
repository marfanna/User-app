import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/models/mappers/order_ui_model_mapper.dart';
import '../../../core/models/order_ui_model.dart';

part 'completed_orders_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<OrderUIModel>> completedOrders(
  Ref ref, {
  required int page,
}) async {
  final result = await ref
      .read(getCompletedOrdersUseCaseProvider)
      .call(page: page, limit: 5);

  return result.when(
    success: (data) {
      if (data == null) return [];

      return data.map((e) => e.toUIModel()).toList();
    },
    error: (failure) => throw failure.message,
  );
}
