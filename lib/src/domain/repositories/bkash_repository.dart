import '../../core/base/base.dart';
import '../../data/models/bkash/bkash_models.dart';

abstract class BkashRepository {
  Future<Result<BkashPaymentResponseModel, Failure>> initiatePayment({
    required String orderId,
    required double amount,
  });

  Future<Result<BkashVerificationResponseModel, Failure>> verifyPayment(String paymentId);

  Future<Result<BkashVerificationResponseModel, Failure>> queryPayment(String paymentId);
}
