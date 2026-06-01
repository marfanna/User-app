import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../domain/entities/franchise_rider_entity.dart';

part 'franchise_riders_provider.g.dart';

@riverpod
FutureOr<List<FranchiseRiderEntity>> franchiseRiders(Ref ref) async {
  final riderProfileUseCase = ref.read(getRiderProfileUseCaseProvider);
  final franchiseRidersUseCase = ref.read(getFranchiseRidersUseCaseProvider);

  final profileResult = await riderProfileUseCase.call();

  return profileResult.when(
    success: (profile) async {
      final franchiseId = profile?.franchiseId;
      final currentRiderId = profile?.id;
      if (franchiseId == null) throw 'Franchise ID not available';

      final result = await franchiseRidersUseCase.call(
        franchiseId: franchiseId,
      );

      return result.when(
        success: (riders) {
          return (riders ?? []).where((r) => r.id != currentRiderId).toList();
        },
        error: (failure) => throw failure.message,
      );
    },
    error: (failure) => throw failure.message,
  );
}
