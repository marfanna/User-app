import 'package:dart_mappable/dart_mappable.dart';

part 'auth_response.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.decode,
)
class AuthResponse with AuthResponseMappable {
  const AuthResponse({this.accessToken, this.refreshToken, this.expiresIn});

  final String? accessToken;
  final String? refreshToken;
  final String? expiresIn;

  static final fromJson = AuthResponseMapper.fromJson;
}
