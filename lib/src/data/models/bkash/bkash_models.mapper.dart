// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'bkash_models.dart';

class BkashPaymentResponseModelMapper
    extends ClassMapperBase<BkashPaymentResponseModel> {
  BkashPaymentResponseModelMapper._();

  static BkashPaymentResponseModelMapper? _instance;
  static BkashPaymentResponseModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = BkashPaymentResponseModelMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'BkashPaymentResponseModel';

  static String? _$paymentID(BkashPaymentResponseModel v) => v.paymentID;
  static const Field<BkashPaymentResponseModel, String> _f$paymentID = Field(
    'paymentID',
    _$paymentID,
    key: r'paymentId',
    opt: true,
  );
  static String? _$checkoutUrl(BkashPaymentResponseModel v) => v.checkoutUrl;
  static const Field<BkashPaymentResponseModel, String> _f$checkoutUrl = Field(
    'checkoutUrl',
    _$checkoutUrl,
    opt: true,
  );
  static String? _$amount(BkashPaymentResponseModel v) => v.amount;
  static const Field<BkashPaymentResponseModel, String> _f$amount = Field(
    'amount',
    _$amount,
    opt: true,
  );
  static String? _$merchantInvoiceNumber(BkashPaymentResponseModel v) =>
      v.merchantInvoiceNumber;
  static const Field<BkashPaymentResponseModel, String>
  _f$merchantInvoiceNumber = Field(
    'merchantInvoiceNumber',
    _$merchantInvoiceNumber,
    opt: true,
  );

  @override
  final MappableFields<BkashPaymentResponseModel> fields = const {
    #paymentID: _f$paymentID,
    #checkoutUrl: _f$checkoutUrl,
    #amount: _f$amount,
    #merchantInvoiceNumber: _f$merchantInvoiceNumber,
  };

  static BkashPaymentResponseModel _instantiate(DecodingData data) {
    return BkashPaymentResponseModel(
      paymentID: data.dec(_f$paymentID),
      checkoutUrl: data.dec(_f$checkoutUrl),
      amount: data.dec(_f$amount),
      merchantInvoiceNumber: data.dec(_f$merchantInvoiceNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BkashPaymentResponseModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BkashPaymentResponseModel>(map);
  }

  static BkashPaymentResponseModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<BkashPaymentResponseModel>(json);
  }
}

mixin BkashPaymentResponseModelMappable {
  String toJsonString() {
    return BkashPaymentResponseModelMapper.ensureInitialized()
        .encodeJson<BkashPaymentResponseModel>(
          this as BkashPaymentResponseModel,
        );
  }

  Map<String, dynamic> toJson() {
    return BkashPaymentResponseModelMapper.ensureInitialized()
        .encodeMap<BkashPaymentResponseModel>(
          this as BkashPaymentResponseModel,
        );
  }

  BkashPaymentResponseModelCopyWith<
    BkashPaymentResponseModel,
    BkashPaymentResponseModel,
    BkashPaymentResponseModel
  >
  get copyWith =>
      _BkashPaymentResponseModelCopyWithImpl<
        BkashPaymentResponseModel,
        BkashPaymentResponseModel
      >(this as BkashPaymentResponseModel, $identity, $identity);
  @override
  String toString() {
    return BkashPaymentResponseModelMapper.ensureInitialized().stringifyValue(
      this as BkashPaymentResponseModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return BkashPaymentResponseModelMapper.ensureInitialized().equalsValue(
      this as BkashPaymentResponseModel,
      other,
    );
  }

  @override
  int get hashCode {
    return BkashPaymentResponseModelMapper.ensureInitialized().hashValue(
      this as BkashPaymentResponseModel,
    );
  }
}

extension BkashPaymentResponseModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BkashPaymentResponseModel, $Out> {
  BkashPaymentResponseModelCopyWith<$R, BkashPaymentResponseModel, $Out>
  get $asBkashPaymentResponseModel => $base.as(
    (v, t, t2) => _BkashPaymentResponseModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class BkashPaymentResponseModelCopyWith<
  $R,
  $In extends BkashPaymentResponseModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? paymentID,
    String? checkoutUrl,
    String? amount,
    String? merchantInvoiceNumber,
  });
  BkashPaymentResponseModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BkashPaymentResponseModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BkashPaymentResponseModel, $Out>
    implements
        BkashPaymentResponseModelCopyWith<$R, BkashPaymentResponseModel, $Out> {
  _BkashPaymentResponseModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BkashPaymentResponseModel> $mapper =
      BkashPaymentResponseModelMapper.ensureInitialized();
  @override
  $R call({
    Object? paymentID = $none,
    Object? checkoutUrl = $none,
    Object? amount = $none,
    Object? merchantInvoiceNumber = $none,
  }) => $apply(
    FieldCopyWithData({
      if (paymentID != $none) #paymentID: paymentID,
      if (checkoutUrl != $none) #checkoutUrl: checkoutUrl,
      if (amount != $none) #amount: amount,
      if (merchantInvoiceNumber != $none)
        #merchantInvoiceNumber: merchantInvoiceNumber,
    }),
  );
  @override
  BkashPaymentResponseModel $make(CopyWithData data) =>
      BkashPaymentResponseModel(
        paymentID: data.get(#paymentID, or: $value.paymentID),
        checkoutUrl: data.get(#checkoutUrl, or: $value.checkoutUrl),
        amount: data.get(#amount, or: $value.amount),
        merchantInvoiceNumber: data.get(
          #merchantInvoiceNumber,
          or: $value.merchantInvoiceNumber,
        ),
      );

  @override
  BkashPaymentResponseModelCopyWith<$R2, BkashPaymentResponseModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BkashPaymentResponseModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class BkashVerificationResponseModelMapper
    extends ClassMapperBase<BkashVerificationResponseModel> {
  BkashVerificationResponseModelMapper._();

  static BkashVerificationResponseModelMapper? _instance;
  static BkashVerificationResponseModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = BkashVerificationResponseModelMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'BkashVerificationResponseModel';

  static String? _$paymentID(BkashVerificationResponseModel v) => v.paymentID;
  static const Field<BkashVerificationResponseModel, String> _f$paymentID =
      Field('paymentID', _$paymentID, key: r'paymentId', opt: true);
  static String? _$trxID(BkashVerificationResponseModel v) => v.trxID;
  static const Field<BkashVerificationResponseModel, String> _f$trxID = Field(
    'trxID',
    _$trxID,
    key: r'trxId',
    opt: true,
  );
  static String? _$transactionStatus(BkashVerificationResponseModel v) =>
      v.transactionStatus;
  static const Field<BkashVerificationResponseModel, String>
  _f$transactionStatus = Field(
    'transactionStatus',
    _$transactionStatus,
    opt: true,
  );
  static String? _$amount(BkashVerificationResponseModel v) => v.amount;
  static const Field<BkashVerificationResponseModel, String> _f$amount = Field(
    'amount',
    _$amount,
    opt: true,
  );
  static String? _$currency(BkashVerificationResponseModel v) => v.currency;
  static const Field<BkashVerificationResponseModel, String> _f$currency =
      Field('currency', _$currency, opt: true);
  static String? _$intent(BkashVerificationResponseModel v) => v.intent;
  static const Field<BkashVerificationResponseModel, String> _f$intent = Field(
    'intent',
    _$intent,
    opt: true,
  );
  static String? _$merchantInvoiceNumber(BkashVerificationResponseModel v) =>
      v.merchantInvoiceNumber;
  static const Field<BkashVerificationResponseModel, String>
  _f$merchantInvoiceNumber = Field(
    'merchantInvoiceNumber',
    _$merchantInvoiceNumber,
    opt: true,
  );

  @override
  final MappableFields<BkashVerificationResponseModel> fields = const {
    #paymentID: _f$paymentID,
    #trxID: _f$trxID,
    #transactionStatus: _f$transactionStatus,
    #amount: _f$amount,
    #currency: _f$currency,
    #intent: _f$intent,
    #merchantInvoiceNumber: _f$merchantInvoiceNumber,
  };

  static BkashVerificationResponseModel _instantiate(DecodingData data) {
    return BkashVerificationResponseModel(
      paymentID: data.dec(_f$paymentID),
      trxID: data.dec(_f$trxID),
      transactionStatus: data.dec(_f$transactionStatus),
      amount: data.dec(_f$amount),
      currency: data.dec(_f$currency),
      intent: data.dec(_f$intent),
      merchantInvoiceNumber: data.dec(_f$merchantInvoiceNumber),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BkashVerificationResponseModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BkashVerificationResponseModel>(map);
  }

  static BkashVerificationResponseModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<BkashVerificationResponseModel>(json);
  }
}

mixin BkashVerificationResponseModelMappable {
  String toJsonString() {
    return BkashVerificationResponseModelMapper.ensureInitialized()
        .encodeJson<BkashVerificationResponseModel>(
          this as BkashVerificationResponseModel,
        );
  }

  Map<String, dynamic> toJson() {
    return BkashVerificationResponseModelMapper.ensureInitialized()
        .encodeMap<BkashVerificationResponseModel>(
          this as BkashVerificationResponseModel,
        );
  }

  BkashVerificationResponseModelCopyWith<
    BkashVerificationResponseModel,
    BkashVerificationResponseModel,
    BkashVerificationResponseModel
  >
  get copyWith =>
      _BkashVerificationResponseModelCopyWithImpl<
        BkashVerificationResponseModel,
        BkashVerificationResponseModel
      >(this as BkashVerificationResponseModel, $identity, $identity);
  @override
  String toString() {
    return BkashVerificationResponseModelMapper.ensureInitialized()
        .stringifyValue(this as BkashVerificationResponseModel);
  }

  @override
  bool operator ==(Object other) {
    return BkashVerificationResponseModelMapper.ensureInitialized().equalsValue(
      this as BkashVerificationResponseModel,
      other,
    );
  }

  @override
  int get hashCode {
    return BkashVerificationResponseModelMapper.ensureInitialized().hashValue(
      this as BkashVerificationResponseModel,
    );
  }
}

extension BkashVerificationResponseModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BkashVerificationResponseModel, $Out> {
  BkashVerificationResponseModelCopyWith<
    $R,
    BkashVerificationResponseModel,
    $Out
  >
  get $asBkashVerificationResponseModel => $base.as(
    (v, t, t2) =>
        _BkashVerificationResponseModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class BkashVerificationResponseModelCopyWith<
  $R,
  $In extends BkashVerificationResponseModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? paymentID,
    String? trxID,
    String? transactionStatus,
    String? amount,
    String? currency,
    String? intent,
    String? merchantInvoiceNumber,
  });
  BkashVerificationResponseModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _BkashVerificationResponseModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BkashVerificationResponseModel, $Out>
    implements
        BkashVerificationResponseModelCopyWith<
          $R,
          BkashVerificationResponseModel,
          $Out
        > {
  _BkashVerificationResponseModelCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<BkashVerificationResponseModel> $mapper =
      BkashVerificationResponseModelMapper.ensureInitialized();
  @override
  $R call({
    Object? paymentID = $none,
    Object? trxID = $none,
    Object? transactionStatus = $none,
    Object? amount = $none,
    Object? currency = $none,
    Object? intent = $none,
    Object? merchantInvoiceNumber = $none,
  }) => $apply(
    FieldCopyWithData({
      if (paymentID != $none) #paymentID: paymentID,
      if (trxID != $none) #trxID: trxID,
      if (transactionStatus != $none) #transactionStatus: transactionStatus,
      if (amount != $none) #amount: amount,
      if (currency != $none) #currency: currency,
      if (intent != $none) #intent: intent,
      if (merchantInvoiceNumber != $none)
        #merchantInvoiceNumber: merchantInvoiceNumber,
    }),
  );
  @override
  BkashVerificationResponseModel $make(CopyWithData data) =>
      BkashVerificationResponseModel(
        paymentID: data.get(#paymentID, or: $value.paymentID),
        trxID: data.get(#trxID, or: $value.trxID),
        transactionStatus: data.get(
          #transactionStatus,
          or: $value.transactionStatus,
        ),
        amount: data.get(#amount, or: $value.amount),
        currency: data.get(#currency, or: $value.currency),
        intent: data.get(#intent, or: $value.intent),
        merchantInvoiceNumber: data.get(
          #merchantInvoiceNumber,
          or: $value.merchantInvoiceNumber,
        ),
      );

  @override
  BkashVerificationResponseModelCopyWith<
    $R2,
    BkashVerificationResponseModel,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BkashVerificationResponseModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

