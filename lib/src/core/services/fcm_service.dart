import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../di/dependency_injection.dart';
import '../../presentation/core/router/router.dart';
import 'order_tracking_notification_service.dart';

final fcmServiceProvider = Provider<FCMService>((ref) {
  return FCMService(ref);
});

class FCMService {

  FCMService(this._ref);
  final Ref _ref;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenRefreshSub;

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

    // Wire notification tap → navigate to track order
    OrderTrackingNotificationService.onNotificationTapped = (orderId) {
      _ref.read(goRouterProvider).push('/track-order/$orderId');
    };
    await OrderTrackingNotificationService.initialize();

    // Foreground FCM → update tracking notification
    FirebaseMessaging.onMessage.listen(_handleOrderTrackingMessage);

    // Handle interaction when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // Handle interaction when app is terminated — intentionally not awaited
    unawaited(
      _messaging.getInitialMessage().then((message) {
        if (message != null) {
          // Delay slightly to ensure router and auth state are ready
          Future.delayed(const Duration(seconds: 2), () {
            _handleMessage(message);
          });
        }
      }),
    );
  }

  void _handleOrderTrackingMessage(RemoteMessage message) {
    final data = message.data;
    final type = data['type'] as String?;
    if (type != 'order_updated' && type != 'order_assigned') return;

    final orderId = data['order_id'] as String?;
    final orderNumber = data['orderNumber'] as String? ?? orderId ?? '';
    final status = data['status'] as String? ??
        (type == 'order_assigned' ? 'assigned' : '');
    if (orderId != null && status.isNotEmpty) {
      OrderTrackingNotificationService.showOrUpdate(
        orderId: orderId,
        orderNumber: orderNumber,
        status: status,
      );
    }

    // Also refresh the track order screen if it's open
    _handleMessage(message);
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('FCM Notification tapped with data: ${message.data}');
    final data = message.data;
    
    // Check if there is an order ID in the payload
    final orderId = data['order_id'];
    if (orderId != null && orderId.toString().isNotEmpty) {
      // Navigate directly to the track order screen
      _ref.read(goRouterProvider).push('/track-order/$orderId');
    }
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
