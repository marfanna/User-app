import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../events/order_events_provider.dart';

part 'reject_order_provider.g.dart';

@riverpod
class RejectOrder extends _$RejectOrder {
  @override
  FutureOr<bool?> build(String orderId) => null;

  Future<void> reject({required String reason}) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(rejectOrderUseCaseProvider)
          .call(orderId: orderId, reason: reason);

      return result.when(
        success: (data) {
          ref.read(orderEventsProvider.notifier).emit(.rejected);
          return data ?? false;
        },
        error: (failure) => throw failure.message,
      );
    });
  }
}
