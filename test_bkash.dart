import 'package:duare_user/src/data/models/bkash/bkash_models.dart';
import 'package:flutter/foundation.dart';

void main() {
  final jsonMap = {
    'paymentId': 'PAY12345',
    'checkoutUrl': 'https://pay.bka.sh/test',
    'amount': 20,
    'currency': 'BDT',
    'expiresAt': '2023-01-01T00:00:00Z',
  };

  try {
    final model = BkashPaymentResponseModelMapper.fromJson(jsonMap);
    debugPrint('SUCCESS!');
    debugPrint('checkoutUrl: ${model.checkoutUrl}');
    debugPrint('amount: ${model.amount}');
  } catch (e, s) {
    debugPrint('ERROR: $e');
    debugPrint('$s');
  }
}
