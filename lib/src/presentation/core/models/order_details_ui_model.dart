import 'order_ui_model.dart';

class OrderItemUIModel {
  const OrderItemUIModel({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.qty,
    required this.portion,
    required this.price,
    required this.unitPrice,
  });

  final String itemId;
  final String name;
  final String quantity; // display string e.g. "1x"
  final int qty;         // raw quantity for cart
  final String portion;
  final String price;    // display string e.g. "৳320"
  final double unitPrice; // raw price for cart
}

class OrderDetailsUIModel {
  const OrderDetailsUIModel({
    required this.id,
    required this.orderDisplayId,
    required this.shopId,
    required this.shopName,
    required this.shopPhone,
    required this.shopLocation,
    this.shopCoordinates,
    required this.distance,
    required this.customerName,
    required this.customerPhones,
    required this.customerProfileImage,
    required this.deliveryAddress,
    this.customerCoordinates,
    required this.deliveryTime,
    required this.orderDate,
    required this.totalPrice,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.subTotal,
    required this.totalBuyingPrice,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.items,
    required this.status,
    required this.isDelivered,
  });

  final String id;
  final String orderDisplayId;
  final String shopId;
  final String shopName;
  final String shopPhone;
  final String shopLocation;
  final ({double lat, double lng})? shopCoordinates;
  final String distance;
  final String customerName;
  final List<String> customerPhones;
  final String customerProfileImage;
  final String deliveryAddress;
  final ({double lat, double lng})? customerCoordinates;
  final String deliveryTime;

  // OrderOverview fields
  final String orderDate;
  final String totalPrice;

  // Payment & pricing
  final String paymentMethod;
  final String paymentStatus;
  final double subTotal;
  final double totalBuyingPrice;
  final double deliveryFee;
  final double discount;
  final double total;

  final List<OrderItemUIModel> items;

  /// Null for non-actionable orders (delivered, rejected), which
  /// hides the action bar on the details screen.
  final OrderStatus? status;

  final bool isDelivered;

  Uri? get directionsUrl {
    if (customerCoordinates == null) return null;

    return Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${customerCoordinates!.lat},${customerCoordinates!.lng}',
    );
  }
}
