import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../events/order_events_provider.dart';

part 'update_order_provider.g.dart';

enum UpdateOrderStatus { accept, pickUp, deliver }

@riverpod
class UpdateOrder extends _$UpdateOrder {
  @override
  FutureOr<bool?> build(String orderId, UpdateOrderStatus status) => null;

  Future<void> execute() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = switch (status) {
        .accept => await ref.read(acceptOrderUseCaseProvider)(orderId),
        .pickUp => await ref.read(pickUpOrderUseCaseProvider)(orderId),
        .deliver => await ref.read(deliverOrderUseCaseProvider)(orderId),
      };

      return result.when(
        success: (data) {
          ref.read(orderEventsProvider.notifier).emit(.updated);
          return data ?? false;
        },
        error: (failure) => throw failure.message,
      );
    });
  }
}
