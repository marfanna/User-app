import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/dependency_injection.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(ref);
});

class FCMService {
  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSub;

  FCMService(this._ref);

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    try {
      final token = await _messaging.getToken();
      if (token != null) await _sendTokenToBackend(token);
    } catch (e) {
      debugPrint('FCM: failed to get token: $e');
    }

    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub =
        _messaging.onTokenRefresh.listen(_sendTokenToBackend);
  }

  Future<void> _sendTokenToBackend(String token) async {
    try {
      final client = _ref.read(restClientServiceProvider);

      final deviceType = switch (defaultTargetPlatform) {
        TargetPlatform.android => 'android',
        TargetPlatform.iOS => 'ios',
        _ => 'unknown',
      };

      await client.registerFCMToken({
        'fcmToken': token,
        'deviceType': deviceType,
        // deviceId omitted — backend generates a stable unique ID
      });
    } catch (e) {
      debugPrint('FCM: failed to register token: $e');
    }
  }
}
