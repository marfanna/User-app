enum OrderStatus { assigned, pickedUp, pending }

class OrderUIModel {
  const OrderUIModel({
    required this.id,
    required this.orderDisplayId,
    required this.shopName,
    required this.shopLocation,
    required this.distance,
    required this.customerName,
    required this.deliveryAddress,
    required this.deliveryTime,
    required this.customerProfileImage,
    required this.status,
  });

  final String id;
  final String orderDisplayId;
  final String shopName;
  final String shopLocation;
  final String distance;
  final String customerName;
  final String deliveryAddress;
  final String deliveryTime;
  final String customerProfileImage;
  final OrderStatus status;
}
