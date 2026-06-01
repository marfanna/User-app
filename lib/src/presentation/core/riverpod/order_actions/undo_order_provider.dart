import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../events/order_events_provider.dart';

part 'undo_order_provider.g.dart';

@riverpod
class UndoOrder extends _$UndoOrder {
  @override
  FutureOr<bool?> build(String orderId) => null;

  Future<void> undo() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final result = await ref
          .read(undoOrderUseCaseProvider)
          .call(orderId: orderId);

      return result.when(
        success: (data) {
          ref.read(orderEventsProvider.notifier).emit(.undone);
          return data ?? false;
        },
        error: (failure) => throw failure.message,
      );
    });
  }
}
