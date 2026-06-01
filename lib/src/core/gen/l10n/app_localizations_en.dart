// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get orders => 'Orders';

  @override
  String get leaderboard => 'Ranking';

  @override
  String get logout => 'Logout';

  @override
  String get deliveryArea => 'Delivery Area';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get totalOrder => 'Total Order';

  @override
  String get totalEarning => 'Total Earning';

  @override
  String get pleaseLogin => 'Please Login';

  @override
  String get authenticationRequired => 'Authentication Required';

  @override
  String get otpSentMessage => 'A one-time code has been sent to your number';

  @override
  String get submit => 'Submit';

  @override
  String get enterPhoneNumber => 'Enter your phone number';

  @override
  String get isRequired => 'This field is required';

  @override
  String get validEmail => 'Please enter valid email address';

  @override
  String minLengthValidation(int min) {
    return 'This field must be at least $min characters long';
  }

  @override
  String maxLengthValidation(int max) {
    return 'This field must be at most $max characters long';
  }

  @override
  String get onboardingTitle => 'The Fast\nDelivery App';

  @override
  String get onboardingSubtitle =>
      'Find the best Delivery App in your city and get it delivered to your place!';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueText => 'Continue';

  @override
  String passwordMinLengthValidation(String minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get passwordNumberValidation =>
      'Password must contain at least one number';

  @override
  String get passwordLowerCaseValidation =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordUpperCaseValidation =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordSpecialCharValidation =>
      'Password must contain at least one special character';

  @override
  String get rejectOrderTitle => 'Why are you rejecting this order?';

  @override
  String get rejectOrderSubtitle =>
      'Your feedback helps us improve your experience and match you with better orders.';

  @override
  String get rejectOrderDescriptionLabel => 'Description';

  @override
  String get rejectOrderDescriptionHint => 'Share your reason here…';

  @override
  String get rejectOrder => 'Reject Order';

  @override
  String get orderAccepted => 'Order accepted successfully!';

  @override
  String get orderPickedUp => 'Order picked up successfully!';

  @override
  String get acceptOrder => 'Accept Order';

  @override
  String get pickUpOrder => 'Pick Up Order';

  @override
  String get deliverOrder => 'Deliver Order';

  @override
  String get reject => 'Reject';

  @override
  String get orderDelivered => 'Order Delivered';

  @override
  String get orderRejected => 'Order rejected successfully!';

  @override
  String get undo => 'Undo';

  @override
  String get undoOrderTitle => 'Why are you undoing this order?';

  @override
  String get undoOrderSubtitle =>
      'Your feedback helps us improve your experience.';

  @override
  String get undoOrder => 'Undo Order';

  @override
  String get orderUndone => 'Order undone successfully!';

  @override
  String get qty => 'Qty';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get failedToLoadOrderDetails => 'Failed to load order details.';

  @override
  String get retry => 'Retry';

  @override
  String get transferOrder => 'Transfer Order';

  @override
  String transferOrderTitle(String riderName) {
    return 'Transfer order to $riderName?';
  }

  @override
  String get transferOrderSubtitle =>
      'Please provide a reason for transferring this order.';

  @override
  String get transferOrderReasonLabel => 'Reason';

  @override
  String get transferOrderReasonHint => 'Share your reason here…';

  @override
  String get transfer => 'Transfer';

  @override
  String get orderTransferred => 'Order transferred successfully!';

  @override
  String get noRidersAvailable => 'No riders available in your franchise.';

  @override
  String get failedToLoadRiders => 'Failed to load riders.';
}
