import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/events/order_events_provider.dart';
import '../../../core/models/mappers/order_ui_model_mapper.dart';
import '../../../core/models/order_ui_model.dart';

part 'rejected_orders_provider.g.dart';

@Riverpod(keepAlive: true)
FutureOr<List<OrderUIModel>> rejectedOrders(
  Ref ref, {
  required int page,
}) async {
  ref.watch(orderEventsProvider.select((e) => e?.$1 == OrderEvent.rejected));

  final result = await ref
      .read(getRejectedOrdersUseCaseProvider)
      .call(page: page, limit: 5);

  return result.when(
    success: (data) {
      if (data == null) return [];

      return data.map((e) => e.toUIModel()).toList();
    },
    error: (failure) => throw failure.message,
  );
}
