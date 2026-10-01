import 'package:flutter/foundation.dart';

import '../../../core/config/app_flavor.dart';

class Endpoints {
  /// Point the app at a local backend without editing this file:
  ///   flutter run --dart-define=API_BASE=http://192.168.0.107:5000/api/v1/
  ///
  /// Ignored in release builds on purpose — a shipped app can only ever reach
  /// staging or prod. Hardcoding a LAN address here is what shipped 2.4.3+23
  /// to the Play Store with no working API.
  static const _override = String.fromEnvironment('API_BASE');

  static final base = (!kReleaseMode && _override.isNotEmpty)
      ? _override
      : switch (AppFlavor.instance) {
          AppFlavor.staging => 'https://api-stg.duare.net/api/v1/',
          AppFlavor.prod => 'https://api-v2.duare.net/api/v1/',
        };

  /// Authentication
  static const String sendOtp = 'auth/send-otp';
  static const String verifyOtp = 'auth/verify-otp';
  static const String refreshToken = 'auth/refresh-token';
  static const String logout = 'auth/logout';
  static const String registerFCMToken = 'users/fcm/register';

  /// Profile
  static const String myProfile = 'users/profile';
  static const String addresses = 'users/addresses';
  static const String createAddress = 'users/addresses/add';

  /// Orders
  static const String order = 'orders/{orderId}';
  static const String myDisputes = 'orders/my-disputes';
  static const String createDispute = 'orders/{orderId}/dispute';

  /// Payments
  static const String initiateBkashPayment = 'payments/bkash/initiate';
  static const String verifyBkashPayment = 'payments/bkash/verify/{paymentID}';
  static const String queryBkashPayment = 'payments/bkash/query/{paymentID}';

  /// Notifications
  static const String notificationsList = 'notifications/list';
  static const String notificationMarkRead = 'notifications/{id}/read';
  static const String notificationMarkAllRead = 'notifications/mark-all-read';
}
