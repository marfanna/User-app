import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FacebookAppEvents _fbEvents = FacebookAppEvents();
  final _log = Logger();

  /// Fire-and-forget wrapper for Facebook events – failures must never crash.
  /// The SDK calls are async platform-channel calls, so errors surface on the
  /// returned future rather than synchronously.
  void _fb(String event, Future<void> Function() call) {
    try {
      call().catchError((Object e) => _log.e('FB $event failed', error: e));
    } catch (e) {
      _log.e('FB $event failed', error: e);
    }
  }

  String? _lastSearch;

  AnalyticsEventItem _item({
    required String itemId,
    required String itemName,
    double? price,
    int quantity = 1,
    String? category,
  }) {
    return AnalyticsEventItem(
      itemId: itemId,
      itemName: itemName,
      price: price,
      quantity: quantity,
      itemCategory: category,
    );
  }

  Future<void> logViewItem({
    required String itemId,
    required String itemName,
    double? price,
    String? category,
  }) async {
    try {
      await _analytics.logViewItem(
        currency: 'BDT',
        value: price ?? 0,
        items: [
          _item(
            itemId: itemId,
            itemName: itemName,
            price: price,
            category: category,
          ),
        ],
      );
    } catch (e, st) {
      _log.e('GA4 logViewItem failed', error: e, stackTrace: st);
    }
    _fb('ViewContent', () => _fbEvents.logViewContent(
          id: itemId,
          type: 'product',
          currency: 'BDT',
          price: price ?? 0,
          content: {'name': itemName, 'category': ?category},
        ));
  }

  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    double? price,
    int quantity = 1,
    String? category,
  }) async {
    try {
      await _analytics.logAddToCart(
        currency: 'BDT',
        value: (price ?? 0) * quantity,
        items: [
          _item(
            itemId: itemId,
            itemName: itemName,
            price: price,
            quantity: quantity,
            category: category,
          ),
        ],
      );
    } catch (e, st) {
      _log.e('GA4 logAddToCart failed', error: e, stackTrace: st);
    }
    _fb('AddToCart', () => _fbEvents.logAddToCart(
          id: itemId,
          type: 'product',
          currency: 'BDT',
          price: (price ?? 0) * quantity,
          content: {'name': itemName, 'quantity': quantity},
        ));
  }

  Future<void> logBeginCheckout({
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    try {
      await _analytics.logBeginCheckout(
        currency: 'BDT',
        value: value,
        items: items,
      );
    } catch (e, st) {
      _log.e('GA4 logBeginCheckout failed', error: e, stackTrace: st);
    }
    _fb('InitiateCheckout', () => _fbEvents.logInitiatedCheckout(
          totalPrice: value,
          currency: 'BDT',
          contentType: 'product',
          contentId: items.map((i) => i.itemId).whereType<String>().join(','),
          numItems: items.length,
        ));
  }

  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    try {
      await _analytics.logPurchase(
        transactionId: transactionId,
        currency: 'BDT',
        value: value,
        items: items,
      );
    } catch (e, st) {
      _log.e('GA4 logPurchase failed', error: e, stackTrace: st);
    }
    _fb('Purchase', () => _fbEvents.logPurchase(
          amount: value,
          currency: 'BDT',
          parameters: {
            FacebookAppEvents.paramNameContentType: 'product',
            FacebookAppEvents.paramNameNumItems: items.length,
            FacebookAppEvents.paramNameOrderId: transactionId,
          },
        ));
  }

  // ── New events ───────────────────────────────────────────────────────────

  /// Search screens query as the user types; skip repeats of the last term.
  Future<void> logSearch({required String query}) async {
    final term = query.trim().toLowerCase();
    if (term.length < 2 || term == _lastSearch) return;
    _lastSearch = term;
    try {
      await _analytics.logSearch(searchTerm: query);
    } catch (e, st) {
      _log.e('GA4 logSearch failed', error: e, stackTrace: st);
    }
    _fb('Search', () => _fbEvents.logEvent(
          name: 'fb_mobile_search',
          parameters: {
            'fb_search_string': query,
            'fb_success': FacebookAppEvents.paramValueYes,
          },
        ));
  }

  Future<void> logCompleteRegistration() async {
    try {
      await _analytics.logSignUp(signUpMethod: 'phone_otp');
    } catch (e, st) {
      _log.e('GA4 logSignUp failed', error: e, stackTrace: st);
    }
    _fb('CompleteRegistration', () => _fbEvents.logCompletedRegistration(
          registrationMethod: 'phone_otp',
        ));
  }

  Future<void> logAddToWishlist({
    required String itemId,
    required String itemName,
    double? price,
    String? category,
  }) async {
    try {
      await _analytics.logAddToWishlist(
        currency: 'BDT',
        value: price ?? 0,
        items: [
          _item(
            itemId: itemId,
            itemName: itemName,
            price: price,
            category: category,
          ),
        ],
      );
    } catch (e, st) {
      _log.e('GA4 logAddToWishlist failed', error: e, stackTrace: st);
    }
    _fb('AddToWishlist', () => _fbEvents.logAddToWishlist(
          id: itemId,
          type: 'product',
          currency: 'BDT',
          price: price ?? 0,
          content: {'name': itemName, 'category': ?category},
        ));
  }

  AnalyticsEventItem item({
    required String itemId,
    required String itemName,
    double? price,
    int quantity = 1,
    String? category,
  }) =>
      _item(
        itemId: itemId,
        itemName: itemName,
        price: price,
        quantity: quantity,
        category: category,
      );
}
