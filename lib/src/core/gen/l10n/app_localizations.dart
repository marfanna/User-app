import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @leaderboard.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get leaderboard;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deliveryArea.
  ///
  /// In en, this message translates to:
  /// **'Delivery Area'**
  String get deliveryArea;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @totalOrder.
  ///
  /// In en, this message translates to:
  /// **'Total Order'**
  String get totalOrder;

  /// No description provided for @totalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get totalEarning;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please Login'**
  String get pleaseLogin;

  /// No description provided for @authenticationRequired.
  ///
  /// In en, this message translates to:
  /// **'Authentication Required'**
  String get authenticationRequired;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'A one-time code has been sent to your number'**
  String get otpSentMessage;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @isRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get isRequired;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get validEmail;

  /// Error message for minimum length validation
  ///
  /// In en, this message translates to:
  /// **'This field must be at least {min} characters long'**
  String minLengthValidation(int min);

  /// Error message for maximum length validation
  ///
  /// In en, this message translates to:
  /// **'This field must be at most {max} characters long'**
  String maxLengthValidation(int max);

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'The Fast\nDelivery App'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find the best Delivery App in your city and get it delivered to your place!'**
  String get onboardingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// Error message for password minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Password must be at least {minLength} characters'**
  String passwordMinLengthValidation(String minLength);

  /// No description provided for @passwordNumberValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordNumberValidation;

  /// No description provided for @passwordLowerCaseValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordLowerCaseValidation;

  /// No description provided for @passwordUpperCaseValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordUpperCaseValidation;

  /// No description provided for @passwordSpecialCharValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get passwordSpecialCharValidation;

  /// No description provided for @rejectOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you rejecting this order?'**
  String get rejectOrderTitle;

  /// No description provided for @rejectOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve your experience and match you with better orders.'**
  String get rejectOrderSubtitle;

  /// No description provided for @rejectOrderDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get rejectOrderDescriptionLabel;

  /// No description provided for @rejectOrderDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Share your reason here…'**
  String get rejectOrderDescriptionHint;

  /// No description provided for @rejectOrder.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get rejectOrder;

  /// No description provided for @orderAccepted.
  ///
  /// In en, this message translates to:
  /// **'Order accepted successfully!'**
  String get orderAccepted;

  /// No description provided for @orderPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Order picked up successfully!'**
  String get orderPickedUp;

  /// No description provided for @acceptOrder.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get acceptOrder;

  /// No description provided for @pickUpOrder.
  ///
  /// In en, this message translates to:
  /// **'Pick Up Order'**
  String get pickUpOrder;

  /// No description provided for @deliverOrder.
  ///
  /// In en, this message translates to:
  /// **'Deliver Order'**
  String get deliverOrder;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Order Delivered'**
  String get orderDelivered;

  /// No description provided for @orderRejected.
  ///
  /// In en, this message translates to:
  /// **'Order rejected successfully!'**
  String get orderRejected;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @undoOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Why are you undoing this order?'**
  String get undoOrderTitle;

  /// No description provided for @undoOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve your experience.'**
  String get undoOrderSubtitle;

  /// No description provided for @undoOrder.
  ///
  /// In en, this message translates to:
  /// **'Undo Order'**
  String get undoOrder;

  /// No description provided for @orderUndone.
  ///
  /// In en, this message translates to:
  /// **'Order undone successfully!'**
  String get orderUndone;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @failedToLoadOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order details.'**
  String get failedToLoadOrderDetails;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @transferOrder.
  ///
  /// In en, this message translates to:
  /// **'Transfer Order'**
  String get transferOrder;

  /// Title for transfer order confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Transfer order to {riderName}?'**
  String transferOrderTitle(String riderName);

  /// No description provided for @transferOrderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason for transferring this order.'**
  String get transferOrderSubtitle;

  /// No description provided for @transferOrderReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get transferOrderReasonLabel;

  /// No description provided for @transferOrderReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Share your reason here…'**
  String get transferOrderReasonHint;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @orderTransferred.
  ///
  /// In en, this message translates to:
  /// **'Order transferred successfully!'**
  String get orderTransferred;

  /// No description provided for @noRidersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No riders available in your franchise.'**
  String get noRidersAvailable;

  /// No description provided for @failedToLoadRiders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load riders.'**
  String get failedToLoadRiders;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
