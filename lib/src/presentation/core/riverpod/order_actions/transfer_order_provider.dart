import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../events/order_events_provider.dart';

part 'transfer_order_provider.g.dart';

@riverpod
class TransferOrder extends _$TransferOrder {
  @override
  FutureOr<bool?> build(String orderId) => null;

  Future<void> transfer({
    required String toRiderId,
    required String reason,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(transferOrderUseCaseProvider)
          .call(orderId: orderId, toRiderId: toRiderId, reason: reason);

      return result.when(
        success: (data) {
          ref.read(orderEventsProvider.notifier).emit(OrderEvent.transferred);
          return data ?? false;
        },
        error: (failure) => throw failure.message,
      );
    });
  }
}
