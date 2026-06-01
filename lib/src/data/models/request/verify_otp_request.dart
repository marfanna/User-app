import 'package:dart_mappable/dart_mappable.dart';

part 'verify_otp_request.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.encode,
)
class VerifyOtpRequest with VerifyOtpRequestMappable {
  const VerifyOtpRequest({required this.phone, required this.otp});

  final String phone;
  final String otp;
}
