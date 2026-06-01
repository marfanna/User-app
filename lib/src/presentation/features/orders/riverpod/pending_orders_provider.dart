import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/events/order_events_provider.dart';
import '../../../core/models/mappers/order_ui_model_mapper.dart';
import '../../../core/models/order_ui_model.dart';

part 'pending_orders_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<OrderUIModel>> pendingOrders(Ref ref, {required int page}) async {
  ref.watch(orderEventsProvider);

  final useCase = ref.read(getPendingOrdersUseCaseProvider);

  final result = await useCase.call(page: page, limit: 5);

  return result.when(
    success: (data) {
      if (data == null) return [];
      return data.map((e) => e.toUIModel()).toList();
    },
    error: (failure) => throw failure.message,
  );
}
