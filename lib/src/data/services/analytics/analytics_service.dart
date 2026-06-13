import 'package:firebase_analytics/firebase_analytics.dart';

/// Thin wrapper over FirebaseAnalytics for the customer-facing e-commerce funnel.
/// Events flow into the same GA4 property as the web app, split automatically
/// by data stream (Android vs iOS vs Web).
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

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
    await _analytics.logViewItem(
      currency: 'BDT',
      value: price ?? 0,
      items: [_item(itemId: itemId, itemName: itemName, price: price, category: category)],
    );
  }

  Future<void> logAddToCart({
    required String itemId,
    required String itemName,
    double? price,
    int quantity = 1,
    String? category,
  }) async {
    await _analytics.logAddToCart(
      currency: 'BDT',
      value: (price ?? 0) * quantity,
      items: [_item(itemId: itemId, itemName: itemName, price: price, quantity: quantity, category: category)],
    );
  }

  Future<void> logBeginCheckout({
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logBeginCheckout(currency: 'BDT', value: value, items: items);
  }

  Future<void> logPurchase({
    required String transactionId,
    required double value,
    required List<AnalyticsEventItem> items,
  }) async {
    await _analytics.logPurchase(
      transactionId: transactionId,
      currency: 'BDT',
      value: value,
      items: items,
    );
  }

  AnalyticsEventItem item({
    required String itemId,
    required String itemName,
    double? price,
    int quantity = 1,
    String? category,
  }) =>
      _item(itemId: itemId, itemName: itemName, price: price, quantity: quantity, category: category);
}
