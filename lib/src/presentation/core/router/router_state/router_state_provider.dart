import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/cache/cache_service.dart';
import '../../application_state/startup_provider/app_startup_provider.dart';
import '../routes.dart';

part 'router_state_provider.g.dart';

@Riverpod(keepAlive: true)
class RouterState extends _$RouterState {
  @override
  String? build() {
    ref.listen(appStartupProvider, (_, state) {
      if (!(state.isLoading || state.hasError)) {
        decideNextRoute();
      }
    });

    return Routes.initial;
  }

  void decideNextRoute() {
    final isLoggedIn = ref.read(getUserLoginStatusUseCaseProvider).call();

    if (state == Routes.initial) {
      state = Routes.splash;
      Timer(const Duration(milliseconds: 500), () => decideNextRoute());
      return;
    }

    if (!isLoggedIn) {
      state = Routes.onboarding;
      return;
    }

    final cache = ref.read(cacheServiceProvider);
    final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
    state = (franchiseId == null || franchiseId.isEmpty)
        ? Routes.selectArea
        : Routes.home;
  }
}
