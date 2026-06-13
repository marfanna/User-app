import '../../../core/config/app_flavor.dart';

class Endpoints {
  static final base = switch (AppFlavor.instance) {
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

  /// Payments
  static const String initiateBkashPayment = 'payments/bkash/initiate';
  static const String verifyBkashPayment = 'payments/bkash/verify/{paymentID}';
  static const String queryBkashPayment = 'payments/bkash/query/{paymentID}';

  /// Notifications
  static const String notificationsList = 'notifications/list';
  static const String notificationMarkRead = 'notifications/{id}/read';
  static const String notificationMarkAllRead = 'notifications/mark-all-read';
}
