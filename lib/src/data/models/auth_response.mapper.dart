// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'auth_response.dart';

class AuthResponseMapper extends ClassMapperBase<AuthResponse> {
  AuthResponseMapper._();

  static AuthResponseMapper? _instance;
  static AuthResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AuthResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'AuthResponse';

  static String? _$accessToken(AuthResponse v) => v.accessToken;
  static const Field<AuthResponse, String> _f$accessToken = Field(
    'accessToken',
    _$accessToken,
    opt: true,
  );
  static String? _$refreshToken(AuthResponse v) => v.refreshToken;
  static const Field<AuthResponse, String> _f$refreshToken = Field(
    'refreshToken',
    _$refreshToken,
    opt: true,
  );
  static String? _$expiresIn(AuthResponse v) => v.expiresIn;
  static const Field<AuthResponse, String> _f$expiresIn = Field(
    'expiresIn',
    _$expiresIn,
    opt: true,
  );

  @override
  final MappableFields<AuthResponse> fields = const {
    #accessToken: _f$accessToken,
    #refreshToken: _f$refreshToken,
    #expiresIn: _f$expiresIn,
  };

  static AuthResponse _instantiate(DecodingData data) {
    return AuthResponse(
      accessToken: data.dec(_f$accessToken),
      refreshToken: data.dec(_f$refreshToken),
      expiresIn: data.dec(_f$expiresIn),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AuthResponse fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AuthResponse>(map);
  }

  static AuthResponse fromJsonString(String json) {
    return ensureInitialized().decodeJson<AuthResponse>(json);
  }
}

mixin AuthResponseMappable {}

