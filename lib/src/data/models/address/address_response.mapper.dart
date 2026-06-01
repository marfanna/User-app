// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'address_response.dart';

class AddressResponseMapper extends ClassMapperBase<AddressResponse> {
  AddressResponseMapper._();

  static AddressResponseMapper? _instance;
  static AddressResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddressResponseMapper._());
      AddressModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddressResponse';

  static List<AddressModel> _$addresses(AddressResponse v) => v.addresses;
  static const Field<AddressResponse, List<AddressModel>> _f$addresses = Field(
    'addresses',
    _$addresses,
    opt: true,
    def: const [],
  );
  static int _$defaultAddressIndex(AddressResponse v) => v.defaultAddressIndex;
  static const Field<AddressResponse, int> _f$defaultAddressIndex = Field(
    'defaultAddressIndex',
    _$defaultAddressIndex,
    opt: true,
    def: 0,
  );

  @override
  final MappableFields<AddressResponse> fields = const {
    #addresses: _f$addresses,
    #defaultAddressIndex: _f$defaultAddressIndex,
  };

  static AddressResponse _instantiate(DecodingData data) {
    return AddressResponse(
      addresses: data.dec(_f$addresses),
      defaultAddressIndex: data.dec(_f$defaultAddressIndex),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddressResponse fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddressResponse>(map);
  }

  static AddressResponse fromJsonString(String json) {
    return ensureInitialized().decodeJson<AddressResponse>(json);
  }
}

mixin AddressResponseMappable {
  String toJsonString() {
    return AddressResponseMapper.ensureInitialized()
        .encodeJson<AddressResponse>(this as AddressResponse);
  }

  Map<String, dynamic> toJson() {
    return AddressResponseMapper.ensureInitialized().encodeMap<AddressResponse>(
      this as AddressResponse,
    );
  }

  AddressResponseCopyWith<AddressResponse, AddressResponse, AddressResponse>
  get copyWith =>
      _AddressResponseCopyWithImpl<AddressResponse, AddressResponse>(
        this as AddressResponse,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddressResponseMapper.ensureInitialized().stringifyValue(
      this as AddressResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddressResponseMapper.ensureInitialized().equalsValue(
      this as AddressResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return AddressResponseMapper.ensureInitialized().hashValue(
      this as AddressResponse,
    );
  }
}

extension AddressResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddressResponse, $Out> {
  AddressResponseCopyWith<$R, AddressResponse, $Out> get $asAddressResponse =>
      $base.as((v, t, t2) => _AddressResponseCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddressResponseCopyWith<$R, $In extends AddressResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    AddressModel,
    AddressModelCopyWith<$R, AddressModel, AddressModel>
  >
  get addresses;
  $R call({List<AddressModel>? addresses, int? defaultAddressIndex});
  AddressResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _AddressResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddressResponse, $Out>
    implements AddressResponseCopyWith<$R, AddressResponse, $Out> {
  _AddressResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddressResponse> $mapper =
      AddressResponseMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    AddressModel,
    AddressModelCopyWith<$R, AddressModel, AddressModel>
  >
  get addresses => ListCopyWith(
    $value.addresses,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(addresses: v),
  );
  @override
  $R call({List<AddressModel>? addresses, int? defaultAddressIndex}) => $apply(
    FieldCopyWithData({
      if (addresses != null) #addresses: addresses,
      if (defaultAddressIndex != null)
        #defaultAddressIndex: defaultAddressIndex,
    }),
  );
  @override
  AddressResponse $make(CopyWithData data) => AddressResponse(
    addresses: data.get(#addresses, or: $value.addresses),
    defaultAddressIndex: data.get(
      #defaultAddressIndex,
      or: $value.defaultAddressIndex,
    ),
  );

  @override
  AddressResponseCopyWith<$R2, AddressResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddressResponseCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

