import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/events/order_events_provider.dart';
import '../../../core/models/mappers/order_ui_model_mapper.dart';
import '../../../core/models/order_ui_model.dart';

part 'recent_orders_provider.g.dart';

@riverpod
FutureOr<List<OrderUIModel>> recentOrders(Ref ref) async {
  ref.watch(orderEventsProvider);

  final result = await ref
      .read(getPendingOrdersUseCaseProvider)
      .call(page: 1, limit: 5);

  return result.when(
    success: (data) {
      if (data == null) return [];

      return data.map((e) => e.toUIModel()).toList();
    },
    error: (failure) => throw failure.message,
  );
}
