import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/dependency_injection.dart';
import '../models/customer_order_model.dart';

const _kDismissedKey = 'dismissed_order_reviews';

class OrderReviewNotifier extends Notifier<CustomerOrderModel?> {
  bool _initialized = false;

  @override
  CustomerOrderModel? build() => null;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _findPendingReview();
  }

  Future<void> _findPendingReview() async {
    try {
      final dio = ref.read(dioProvider);
      final prefs = await SharedPreferences.getInstance();
      final dismissed = prefs.getStringList(_kDismissedKey) ?? [];

      final response = await dio.get(
        'orders/my-orders',
        queryParameters: {
          'limit': '10',
          'sortBy': 'createdAt',
          'sortOrder': 'desc',
        },
      );

      final body = response.data;
      List<dynamic> rawList;
      if (body is Map) {
        final data = body['data'];
        if (data is List) {
          rawList = data;
        } else if (data is Map && data['orders'] is List) {
          rawList = data['orders'] as List;
        } else {
          rawList = [];
        }
      } else if (body is List) {
        rawList = body;
      } else {
        rawList = [];
      }

      final orders = rawList
          .whereType<Map<String, dynamic>>()
          .map(CustomerOrderModel.fromJson)
          .toList();

      CustomerOrderModel? pending;
      for (final order in orders) {
        if (order.status == 'delivered') {
          if (!order.isReviewed && !dismissed.contains(order.id)) {
            pending = order;
          }
          break;
        }
      }

      state = pending;
    } catch (_) {
      state = null;
    }
  }

  Future<void> dismiss(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final dismissed = prefs.getStringList(_kDismissedKey) ?? [];
    if (!dismissed.contains(orderId)) {
      dismissed.add(orderId);
      await prefs.setStringList(_kDismissedKey, dismissed);
    }
    state = null;
  }

  Future<void> submitReview({
    required String orderId,
    required String sentiment,
    required int foodRating,
    String? foodReview,
    required int riderRating,
    String? riderReview,
  }) async {
    final dio = ref.read(dioProvider);
    await dio.patch(
      'orders/$orderId/review',
      data: {
        'shopSentiment': sentiment == 'disliked' ? 'didnt_like' : sentiment,
        'shopRating': foodRating,
        if (foodReview != null && foodReview.isNotEmpty)
          'shopComment': foodReview,
        'riderRating': riderRating,
        if (riderReview != null && riderReview.isNotEmpty)
          'riderComment': riderReview,
      },
    );
    await dismiss(orderId);
  }
}

final orderReviewProvider =
    NotifierProvider<OrderReviewNotifier, CustomerOrderModel?>(
  OrderReviewNotifier.new,
);
