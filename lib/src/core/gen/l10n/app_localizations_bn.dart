// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get home => 'হোম';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get orders => 'অর্ডারস';

  @override
  String get leaderboard => 'লিডারবোর্ড';

  @override
  String get logout => 'লগআউট';

  @override
  String get deliveryArea => 'ডেলিভারি এলাকা';

  @override
  String get editProfile => 'প্রোফাইল সম্পাদনা';

  @override
  String get totalOrder => 'মোট অর্ডার';

  @override
  String get totalEarning => 'মোট আয়';

  @override
  String get pleaseLogin => 'লগইন করুন';

  @override
  String get authenticationRequired => 'যাচাইকরণ প্রয়োজন';

  @override
  String get otpSentMessage => 'আপনার নম্বরে একটি ওয়ান-টাইম কোড পাঠানো হয়েছে';

  @override
  String get submit => 'জমা দিন';

  @override
  String get enterPhoneNumber => 'আপনার ফোন নম্বর দিন';

  @override
  String get isRequired => 'এই ক্ষেত্রটি প্রয়োজন';

  @override
  String get validEmail => 'অনুগ্রহ করে একটি বৈধ ইমেইল ঠিকানা দিন';

  @override
  String minLengthValidation(int min) {
    return 'এই ক্ষেত্রটি কমপক্ষে $min অক্ষর দীর্ঘ হতে হবে';
  }

  @override
  String maxLengthValidation(int max) {
    return 'এই ক্ষেত্রটি সর্বাধিক $max অক্ষর দীর্ঘ হতে হবে';
  }

  @override
  String get onboardingTitle => 'The Fast\nDelivery App';

  @override
  String get onboardingSubtitle =>
      'Find the best Delivery App in your city and get it delivered to your place!';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get continueText => 'চালিয়ে যান';

  @override
  String passwordMinLengthValidation(String minLength) {
    return 'পাসওয়ার্ড কমপক্ষে $minLength অক্ষর দীর্ঘ হতে হবে';
  }

  @override
  String get passwordNumberValidation =>
      'পাসওয়ার্ডে কমপক্ষে একটি সংখ্যা থাকতে হবে';

  @override
  String get passwordLowerCaseValidation =>
      'পাসওয়ার্ডে কমপক্ষে একটি ছোট হাতের অক্ষর থাকতে হবে';

  @override
  String get passwordUpperCaseValidation =>
      'পাসওয়ার্ডে কমপক্ষে একটি বড় হাতের অক্ষর থাকতে হবে';

  @override
  String get passwordSpecialCharValidation =>
      'পাসওয়ার্ডে কমপক্ষে একটি বিশেষ অক্ষর থাকতে হবে';

  @override
  String get rejectOrderTitle => 'কেন আপনি এই অর্ডারটি প্রত্যাখ্যান করছেন?';

  @override
  String get rejectOrderSubtitle =>
      'আপনার মতামত আমাদের আপনার অভিজ্ঞতা উন্নত করতে এবং আপনার জন্য আরও ভালো অর্ডার খুঁজে পেতে সাহায্য করে।';

  @override
  String get rejectOrderDescriptionLabel => 'বিবরণ';

  @override
  String get rejectOrderDescriptionHint => 'এখানে আপনার কারণ জানান…';

  @override
  String get rejectOrder => 'অর্ডার প্রত্যাখ্যান করুন';

  @override
  String get orderAccepted => 'অর্ডার সফলভাবে গ্রহণ করা হয়েছে!';

  @override
  String get orderPickedUp => 'অর্ডার সফলভাবে পিক আপ করা হয়েছে!';

  @override
  String get acceptOrder => 'অর্ডার গ্রহণ করুন';

  @override
  String get pickUpOrder => 'অর্ডার পিক আপ করুন';

  @override
  String get deliverOrder => 'অর্ডার ডেলিভার করুন';

  @override
  String get reject => 'প্রত্যাখ্যান';

  @override
  String get orderDelivered => 'অর্ডার ডেলিভারি হয়েছে';

  @override
  String get orderRejected => 'অর্ডার সফলভাবে প্রত্যাখ্যান করা হয়েছে!';

  @override
  String get undo => 'আনডু';

  @override
  String get undoOrderTitle => 'কেন আপনি এই অর্ডারটি পূর্বাবস্থায় ফিরাচ্ছেন?';

  @override
  String get undoOrderSubtitle =>
      'আপনার মতামত আমাদের আপনার অভিজ্ঞতা উন্নত করতে সাহায্য করে।';

  @override
  String get undoOrder => 'অর্ডার পূর্বাবস্থায় ফেরান';

  @override
  String get orderUndone => 'অর্ডার সফলভাবে পূর্বাবস্থায় ফেরানো হয়েছে!';

  @override
  String get qty => 'পরিমাণ';

  @override
  String get orderDetails => 'অর্ডার বিবরণ';

  @override
  String get failedToLoadOrderDetails => 'অর্ডার বিবরণ লোড করতে ব্যর্থ হয়েছে।';

  @override
  String get retry => 'পুনরায় চেষ্টা করুন';

  @override
  String get transferOrder => 'অর্ডার ট্রান্সফার';

  @override
  String transferOrderTitle(String riderName) {
    return '$riderName-এর কাছে অর্ডার ট্রান্সফার করবেন?';
  }

  @override
  String get transferOrderSubtitle => 'এই অর্ডার ট্রান্সফার করার কারণ জানান।';

  @override
  String get transferOrderReasonLabel => 'কারণ';

  @override
  String get transferOrderReasonHint => 'এখানে আপনার কারণ জানান…';

  @override
  String get transfer => 'ট্রান্সফার';

  @override
  String get orderTransferred => 'অর্ডার সফলভাবে ট্রান্সফার করা হয়েছে!';

  @override
  String get noRidersAvailable => 'আপনার ফ্র্যাঞ্চাইজিতে কোনো রাইডার নেই।';

  @override
  String get failedToLoadRiders => 'রাইডার লোড করতে ব্যর্থ হয়েছে।';
}
