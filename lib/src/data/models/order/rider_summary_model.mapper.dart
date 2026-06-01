// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'rider_summary_model.dart';

class RiderSummaryModelMapper extends ClassMapperBase<RiderSummaryModel> {
  RiderSummaryModelMapper._();

  static RiderSummaryModelMapper? _instance;
  static RiderSummaryModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = RiderSummaryModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'RiderSummaryModel';

  static int? _$totalCompletedDeliveries(RiderSummaryModel v) =>
      v.totalCompletedDeliveries;
  static const Field<RiderSummaryModel, int> _f$totalCompletedDeliveries =
      Field('totalCompletedDeliveries', _$totalCompletedDeliveries, opt: true);
  static int? _$todayCompletedDeliveries(RiderSummaryModel v) =>
      v.todayCompletedDeliveries;
  static const Field<RiderSummaryModel, int> _f$todayCompletedDeliveries =
      Field('todayCompletedDeliveries', _$todayCompletedDeliveries, opt: true);
  static int? _$todayPurchaseTotal(RiderSummaryModel v) => v.todayPurchaseTotal;
  static const Field<RiderSummaryModel, int> _f$todayPurchaseTotal = Field(
    'todayPurchaseTotal',
    _$todayPurchaseTotal,
    opt: true,
  );

  @override
  final MappableFields<RiderSummaryModel> fields = const {
    #totalCompletedDeliveries: _f$totalCompletedDeliveries,
    #todayCompletedDeliveries: _f$todayCompletedDeliveries,
    #todayPurchaseTotal: _f$todayPurchaseTotal,
  };

  static RiderSummaryModel _instantiate(DecodingData data) {
    return RiderSummaryModel(
      totalCompletedDeliveries: data.dec(_f$totalCompletedDeliveries),
      todayCompletedDeliveries: data.dec(_f$todayCompletedDeliveries),
      todayPurchaseTotal: data.dec(_f$todayPurchaseTotal),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static RiderSummaryModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<RiderSummaryModel>(map);
  }

  static RiderSummaryModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<RiderSummaryModel>(json);
  }
}

mixin RiderSummaryModelMappable {
  String toJsonString() {
    return RiderSummaryModelMapper.ensureInitialized()
        .encodeJson<RiderSummaryModel>(this as RiderSummaryModel);
  }

  Map<String, dynamic> toJson() {
    return RiderSummaryModelMapper.ensureInitialized()
        .encodeMap<RiderSummaryModel>(this as RiderSummaryModel);
  }

  RiderSummaryModelCopyWith<
    RiderSummaryModel,
    RiderSummaryModel,
    RiderSummaryModel
  >
  get copyWith =>
      _RiderSummaryModelCopyWithImpl<RiderSummaryModel, RiderSummaryModel>(
        this as RiderSummaryModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return RiderSummaryModelMapper.ensureInitialized().stringifyValue(
      this as RiderSummaryModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return RiderSummaryModelMapper.ensureInitialized().equalsValue(
      this as RiderSummaryModel,
      other,
    );
  }

  @override
  int get hashCode {
    return RiderSummaryModelMapper.ensureInitialized().hashValue(
      this as RiderSummaryModel,
    );
  }
}

extension RiderSummaryModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, RiderSummaryModel, $Out> {
  RiderSummaryModelCopyWith<$R, RiderSummaryModel, $Out>
  get $asRiderSummaryModel => $base.as(
    (v, t, t2) => _RiderSummaryModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class RiderSummaryModelCopyWith<
  $R,
  $In extends RiderSummaryModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? totalCompletedDeliveries,
    int? todayCompletedDeliveries,
    int? todayPurchaseTotal,
  });
  RiderSummaryModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _RiderSummaryModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, RiderSummaryModel, $Out>
    implements RiderSummaryModelCopyWith<$R, RiderSummaryModel, $Out> {
  _RiderSummaryModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<RiderSummaryModel> $mapper =
      RiderSummaryModelMapper.ensureInitialized();
  @override
  $R call({
    Object? totalCompletedDeliveries = $none,
    Object? todayCompletedDeliveries = $none,
    Object? todayPurchaseTotal = $none,
  }) => $apply(
    FieldCopyWithData({
      if (totalCompletedDeliveries != $none)
        #totalCompletedDeliveries: totalCompletedDeliveries,
      if (todayCompletedDeliveries != $none)
        #todayCompletedDeliveries: todayCompletedDeliveries,
      if (todayPurchaseTotal != $none) #todayPurchaseTotal: todayPurchaseTotal,
    }),
  );
  @override
  RiderSummaryModel $make(CopyWithData data) => RiderSummaryModel(
    totalCompletedDeliveries: data.get(
      #totalCompletedDeliveries,
      or: $value.totalCompletedDeliveries,
    ),
    todayCompletedDeliveries: data.get(
      #todayCompletedDeliveries,
      or: $value.todayCompletedDeliveries,
    ),
    todayPurchaseTotal: data.get(
      #todayPurchaseTotal,
      or: $value.todayPurchaseTotal,
    ),
  );

  @override
  RiderSummaryModelCopyWith<$R2, RiderSummaryModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _RiderSummaryModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

