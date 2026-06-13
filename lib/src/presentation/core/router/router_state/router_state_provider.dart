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
        unawaited(decideNextRoute());
      }
    });

    return Routes.initial;
  }

  Future<void> decideNextRoute() async {
    final isLoggedIn = ref.read(getUserLoginStatusUseCaseProvider).call();

    if (state == Routes.initial) {
      state = Routes.splash;
      Timer(
        const Duration(milliseconds: 500),
        () => unawaited(decideNextRoute()),
      );
      return;
    }

    if (!isLoggedIn) {
      state = Routes.onboarding;
      return;
    }

    final cache = ref.read(cacheServiceProvider);
    final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);

    if (franchiseId == null || franchiseId.isEmpty) {
      state = Routes.selectArea;
      return;
    }

    // Validate cached franchise ID is still active in the backend.
    // If the ID was deleted or changed in the DB, user gets blank home screen.
    // On API failure (offline) we trust the cached ID and go home anyway.
    final isValid = await _isFranchiseValid(franchiseId);
    if (!isValid) {
      await cache.remove([
        CacheKey.selectedFranchiseId,
        CacheKey.selectedFranchiseName,
      ]);
    }
    state = isValid ? Routes.home : Routes.selectArea;
  }

  Future<bool> _isFranchiseValid(String franchiseId) async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('franchises/get-all-franchise');
      final body = response.data as Map<String, dynamic>;
      final raw = body['data'];
      final list = raw is List
          ? raw
          : (raw is Map && raw['franchises'] is List
              ? raw['franchises'] as List<dynamic>
              : <dynamic>[]);
      return list
          .whereType<Map<String, dynamic>>()
          .any((f) =>
              f['_id']?.toString() == franchiseId &&
              f['isActive'] == true);
    } catch (_) {
      return true;
    }
  }
}
