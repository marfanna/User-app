import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/router/router_state/router_state_provider.dart';

part 'logout_provider.g.dart';

@riverpod
class Logout extends _$Logout {
  @override
  AsyncValue<bool?> build() => const AsyncValue.data(null);

  Future<void> execute() async {
    state = const AsyncValue.loading();

    final result = await ref.read(logoutUseCaseProvider).call();

    state = result.when(
      success: (_) {
        ref.read(resetRepositoryUseCaseProvider).call(ref);
        // Cache cleared → isLoggedIn=false → decideNextRoute sets
        // routerState=onboarding synchronously before first await.
        ref.read(routerStateProvider.notifier).decideNextRoute();
        return const AsyncValue.data(true);
      },
      error: (failure) {
        ref.read(routerStateProvider.notifier).decideNextRoute();
        return AsyncValue.error(failure.message, StackTrace.current);
      },
    );
  }
}
