import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final _log = Logger();

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
