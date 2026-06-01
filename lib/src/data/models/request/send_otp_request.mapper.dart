// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'send_otp_request.dart';

class SendOtpRequestMapper extends ClassMapperBase<SendOtpRequest> {
  SendOtpRequestMapper._();

  static SendOtpRequestMapper? _instance;
  static SendOtpRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SendOtpRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SendOtpRequest';

  static String _$phone(SendOtpRequest v) => v.phone;
  static const Field<SendOtpRequest, String> _f$phone = Field('phone', _$phone);

  @override
  final MappableFields<SendOtpRequest> fields = const {#phone: _f$phone};

  static SendOtpRequest _instantiate(DecodingData data) {
    return SendOtpRequest(phone: data.dec(_f$phone));
  }

  @override
  final Function instantiate = _instantiate;
}

mixin SendOtpRequestMappable {
  String toJsonString() {
    return SendOtpRequestMapper.ensureInitialized().encodeJson<SendOtpRequest>(
      this as SendOtpRequest,
    );
  }

  Map<String, dynamic> toJson() {
    return SendOtpRequestMapper.ensureInitialized().encodeMap<SendOtpRequest>(
      this as SendOtpRequest,
    );
  }
}

