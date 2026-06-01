import 'package:intl/intl.dart';

import '../../../../core/utiliity/geolocator_util.dart';
import '../../../../domain/entities/order_entity.dart';
import '../order_details_ui_model.dart';
import '../order_ui_model.dart';

extension OrderEntityToDetailsUIModel on OrderEntity {
  OrderDetailsUIModel toDetailsUIModel() {
    final date = orderDate ?? createdAt;
    final formattedDate = date != null
        ? DateFormat('dd MMM, hh:mm a').format(date.toLocal())
        : 'Unknown Date';

    return OrderDetailsUIModel(
      id: id,
      orderDisplayId: orderId,
      shopId: shop?.id ?? '',
      shopName: shop?.name ?? 'Unknown Shop',
      shopPhone: shop?.contact?.primaryPhone ?? '',
      shopLocation: _formatAddress(shop?.address),
      shopCoordinates: _toCoordinateRecord(shop?.address?.coordinates),
      distance: _calculateShopDistance(),
      customerName: customer?.name ?? 'Guest',
      customerPhones: _resolveCustomerPhones(),
      customerProfileImage: customer?.profileImage ?? '',
      deliveryAddress: _formatAddress(deliveryAddress),
      customerCoordinates: _toCoordinateRecord(deliveryAddress?.coordinates),
      // TODO: Format based on exact delivery window if applicable
      deliveryTime: 'Deliver within 30min',
      orderDate: formattedDate,
      totalPrice: '৳${grandTotal.toStringAsFixed(0)}',
      paymentMethod: _formatPaymentMethod(paymentMethod),
      paymentStatus: _formatPaymentStatus(paymentStatus),
      subTotal: subtotal,
      totalBuyingPrice: items.fold(
        0.0,
        (sum, item) => sum + (item.totalBuyingPrice ?? 0),
      ),
      deliveryFee: deliveryCharge,
      discount: discountAmount,
      total: grandTotal,
      items: items.map((item) {
        return OrderItemUIModel(
          itemId: item.itemId,
          name: item.name,
          quantity: '${item.quantity}x',
          qty: item.quantity,
          portion: item.variant?.name ?? '',
          price: '৳${item.totalPrice.toStringAsFixed(0)}',
          unitPrice: item.unitPrice,
        );
      }).toList(),
      status: _mapActionableStatus(status),
      isDelivered: status == 'delivered',
    );
  }

  /// Returns the actionable [OrderStatus] for active orders, or
  /// null for non-actionable statuses (delivered, rejected, etc.)
  /// which hides the action bar on the details screen.
  OrderStatus? _mapActionableStatus(String status) {
    return switch (status) {
      'pending' => OrderStatus.pending,
      'assigned' => OrderStatus.assigned,
      'pickedUp' || 'picked_up' => OrderStatus.pickedUp,
      _ => null,
    };
  }

  List<String> _resolveCustomerPhones() {
    final phones = <String>{};
    final primary = customer?.phone;
    if (primary != null && primary.isNotEmpty) phones.add(primary);
    final secondary = deliveryAddress?.phone;
    if (secondary != null && secondary.isNotEmpty) phones.add(secondary);
    return phones.toList();
  }

  String _calculateShopDistance() {
    final shopCoords = shop?.address?.coordinates;
    final customerCoords = deliveryAddress?.coordinates;

    if (shopCoords == null || customerCoords == null) {
      return 'N/A';
    }

    final distance = GeolocatorUtil.calculateDistance(
      shopCoords.latitude,
      shopCoords.longitude,
      customerCoords.latitude,
      customerCoords.longitude,
    );

    return '${distance.toStringAsFixed(1)}\nKm';
  }

  ({double lat, double lng})? _toCoordinateRecord(CoordinatesEntity? coords) {
    if (coords == null) return null;
    return (lat: coords.latitude, lng: coords.longitude);
  }

  String _formatPaymentMethod(String method) {
    return switch (method) {
      'cash_on_delivery' => 'Cash on Delivery',
      'online' => 'Online Payment',
      _ => method,
    };
  }

  String _formatPaymentStatus(String status) {
    return switch (status) {
      'pending' => 'Pending',
      'paid' => 'Paid',
      'failed' => 'Failed',
      _ => status,
    };
  }

  String _formatAddress(AddressEntity? address) {
    if (address == null) return 'No address provided';

    final parts = [
      address.street,
      address.city,
      address.district,
    ].where((part) => part.isNotEmpty);

    return parts.isEmpty ? 'No address details' : parts.join(', ');
  }
}
