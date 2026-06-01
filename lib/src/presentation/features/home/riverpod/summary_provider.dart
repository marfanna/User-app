import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/events/order_events_provider.dart';
import '../../../../domain/entities/rider_summary_entity.dart';

part 'summary_provider.g.dart';

@riverpod
FutureOr<RiderSummaryEntity> riderSummary(Ref ref) async {
  ref.watch(orderEventsProvider);

  final result = await ref.read(getRiderSummaryUseCaseProvider).call();

  return result.when(
    success: (data) => data!,
    error: (failure) => throw failure.message,
  );
}
