import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';

class CustomerProfile {
  const CustomerProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.profileImage,
  });
  final String id;
  final String name;
  final String phone;
  final String? profileImage;
}

final customerProfileProvider = FutureProvider.autoDispose<CustomerProfile>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('users/profile');
  final body = response.data;
  final data = body is Map ? (body['data'] ?? body) : body;
  return CustomerProfile(
    id: data['_id'] as String? ?? data['id'] as String? ?? '',
    name: data['name'] as String? ?? data['fullName'] as String? ?? '',
    phone:
        data['phone'] as String? ??
        data['phoneNumber'] as String? ??
        data['mobile'] as String? ??
        '',
    profileImage: data['profileImage'] as String?,
  );
});
