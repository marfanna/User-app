import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/router/router_state/router_state_provider.dart';

part 'delete_account_provider.g.dart';

@riverpod
class DeleteAccount extends _$DeleteAccount {
  @override
  AsyncValue<bool?> build() => const AsyncValue.data(null);

  Future<void> execute() async {
    state = const AsyncValue.loading();

    final result = await ref.read(deleteAccountUseCaseProvider).call();

    state = result.when(
      success: (_) {
        ref.read(resetRepositoryUseCaseProvider).call(ref);
        ref.read(routerStateProvider.notifier).decideNextRoute();
        return const AsyncValue.data(true);
      },
      error: (failure) => AsyncValue.error(failure.message, StackTrace.current),
    );
  }
}
