import 'laundry_service_item.dart';

class LaundryServiceArgs {
  const LaundryServiceArgs({
    required this.service,
    required this.shopId,
    required this.shopName,
  });

  final LaundryServiceItem service;
  final String shopId;
  final String shopName;
}
