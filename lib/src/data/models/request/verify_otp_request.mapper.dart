// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'verify_otp_request.dart';

class VerifyOtpRequestMapper extends ClassMapperBase<VerifyOtpRequest> {
  VerifyOtpRequestMapper._();

  static VerifyOtpRequestMapper? _instance;
  static VerifyOtpRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VerifyOtpRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VerifyOtpRequest';

  static String _$phone(VerifyOtpRequest v) => v.phone;
  static const Field<VerifyOtpRequest, String> _f$phone = Field(
    'phone',
    _$phone,
  );
  static String _$otp(VerifyOtpRequest v) => v.otp;
  static const Field<VerifyOtpRequest, String> _f$otp = Field('otp', _$otp);

  @override
  final MappableFields<VerifyOtpRequest> fields = const {
    #phone: _f$phone,
    #otp: _f$otp,
  };

  static VerifyOtpRequest _instantiate(DecodingData data) {
    return VerifyOtpRequest(phone: data.dec(_f$phone), otp: data.dec(_f$otp));
  }

  @override
  final Function instantiate = _instantiate;
}

mixin VerifyOtpRequestMappable {
  String toJsonString() {
    return VerifyOtpRequestMapper.ensureInitialized()
        .encodeJson<VerifyOtpRequest>(this as VerifyOtpRequest);
  }

  Map<String, dynamic> toJson() {
    return VerifyOtpRequestMapper.ensureInitialized()
        .encodeMap<VerifyOtpRequest>(this as VerifyOtpRequest);
  }
}

