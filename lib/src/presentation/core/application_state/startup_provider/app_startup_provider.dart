import 'dart:async';

import 'package:in_app_update/in_app_update.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../localization_provider/localization_provider.dart';

part 'app_startup_provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  ref.onDispose(() {
    ref.invalidate(sharedPreferencesProvider);
  });

  await ref.watch(sharedPreferencesProvider.future);
  await ref.read(localizationProvider.notifier).setCurrentLocal();

  // Check for Play Store updates after routing — never block startup on this.
  unawaited(_checkForUpdate());
}

Future<void> _checkForUpdate() async {
  try {
    // Small delay so the home screen renders first before Play Store is hit.
    await Future.delayed(const Duration(seconds: 3));
    final info = await InAppUpdate.checkForUpdate();
    if (info.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.performImmediateUpdate();
    }
  } catch (_) {
    // Not on Play Store, no network, or debug build — ignore.
  }
}
