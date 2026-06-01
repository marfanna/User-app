import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/models/mappers/rider_profile_ui_model_mapper.dart';
import '../../../core/models/rider_profile_ui_model.dart';

part 'profile_provider.g.dart';

@riverpod
FutureOr<RiderProfileUiModel> riderProfile(Ref ref) async {
  final result = await ref.read(getRiderProfileUseCaseProvider).call();

  return result.when(
    success: (data) => data!.toUiModel(),
    error: (failure) => throw failure.message,
  );
}
