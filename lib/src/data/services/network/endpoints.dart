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

  /// Rider
  static const String myProfile = 'users/profile';
  static const String addresses = 'users/addresses';

  /// Orders
  static const String myOrders = 'orders/rider/my-orders';
  static const String mySummary = 'orders/rider/my-summary';
  static const String order = 'orders/rider/{orderId}';
  static const String orderStatus = 'orders/rider/{orderId}/{status}';
  static const String transferOrder = 'orders/rider/{orderId}/transfer';

  /// Riders
  static const String franchiseRiders = 'users/franchise/{franchiseId}/riders';

  /// Payments
  static const String initiateBkashPayment = 'payments/bkash/initiate';
  static const String verifyBkashPayment = 'payments/bkash/verify/{paymentID}';
  static const String queryBkashPayment = 'payments/bkash/query/{paymentID}';
}
