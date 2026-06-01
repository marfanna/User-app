import 'package:dart_mappable/dart_mappable.dart';

part 'send_otp_request.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.camelCase,
  generateMethods: GenerateMethods.encode,
)
class SendOtpRequest with SendOtpRequestMappable {
  const SendOtpRequest({required this.phone});

  final String phone;
}
