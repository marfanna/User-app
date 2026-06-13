import 'package:dio/dio.dart';

import '../../core/base/base.dart';
import '../../domain/repositories/bkash_repository.dart';
import '../models/bkash/bkash_models.dart';
import '../services/network/rest_client.dart';

class BkashRepositoryImpl implements BkashRepository {
  const BkashRepositoryImpl({required this.remote});

  final RestClient remote;

  @override
  Future<Result<BkashPaymentResponseModel, Failure>> initiatePayment({
    required String orderId,
    required double amount,
  }) async {
    try {
      final response = await remote.initiateBkashPayment({
        'orderId': orderId,
        'amount': amount,
      });

      final Map<String, dynamic> body =
          response.data is Map ? response.data as Map<String, dynamic> : {};
      final raw = (body['data'] as Map<String, dynamic>?) ?? body;

      // Manual parse: avoids dart_mappable type-mismatch on `amount` (number vs String)
      // Also covers both key variants returned by the service vs bKash direct
      return Result.success(
        data: BkashPaymentResponseModel(
          paymentID: raw['paymentId'] as String? ?? raw['paymentID'] as String?,
          checkoutUrl: raw['checkoutUrl'] as String? ?? raw['bkashURL'] as String?,
          amount: raw['amount']?.toString(),
          merchantInvoiceNumber: raw['merchantInvoiceNumber'] as String?,
        ),
      );
    } on DioException catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    } catch (e, s) {
      return Result.error(
        Failure(type: FailureType.unknown, message: e.toString(), stackTrace: s),
      );
    }
  }

  @override
  Future<Result<BkashVerificationResponseModel, Failure>> verifyPayment(String paymentId) async {
    try {
      final response = await remote.verifyBkashPayment(paymentId);

      final Map<String, dynamic> body = response.data is Map ? response.data : {};
      final data = body['data'] ?? body;
      return Result.success(data: BkashVerificationResponseModelMapper.fromJson(data));
    } on DioException catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    } catch (e, s) {
      return Result.error(Failure(type: FailureType.unknown, message: e.toString(), stackTrace: s));
    }
  }

  @override
  Future<Result<BkashVerificationResponseModel, Failure>> queryPayment(String paymentId) async {
    try {
      final response = await remote.queryBkashPayment(paymentId);

      final Map<String, dynamic> body = response.data is Map ? response.data : {};
      final data = body['data'] ?? body;
      return Result.success(data: BkashVerificationResponseModelMapper.fromJson(data));
    } on DioException catch (e) {
      return Result.error(Failure.mapExceptionToFailure(e));
    } catch (e, s) {
      return Result.error(Failure(type: FailureType.unknown, message: e.toString(), stackTrace: s));
    }
  }
}
