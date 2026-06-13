import 'package:dart_mappable/dart_mappable.dart';

part 'bkash_models.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class BkashPaymentResponseModel with BkashPaymentResponseModelMappable {
  const BkashPaymentResponseModel({
    this.paymentID,
    this.checkoutUrl,
    this.amount,
    this.merchantInvoiceNumber,
  });

  final String? paymentID;
  final String? checkoutUrl;
  final String? amount;
  final String? merchantInvoiceNumber;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class BkashVerificationResponseModel
    with BkashVerificationResponseModelMappable {
  const BkashVerificationResponseModel({
    this.paymentID,
    this.trxID,
    this.transactionStatus,
    this.amount,
    this.currency,
    this.intent,
    this.merchantInvoiceNumber,
  });

  final String? paymentID;
  final String? trxID;
  final String? transactionStatus;
  final String? amount;
  final String? currency;
  final String? intent;
  final String? merchantInvoiceNumber;
}
