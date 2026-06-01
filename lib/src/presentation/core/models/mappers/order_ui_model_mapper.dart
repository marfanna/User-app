import '../../../../core/utiliity/geolocator_util.dart';
import '../../../../domain/entities/order_entity.dart';
import '../order_ui_model.dart';

extension OrderEntityToUIModel on OrderEntity {
  OrderUIModel toUIModel() {
    return OrderUIModel(
      id: id,
      orderDisplayId: orderId,
      shopName: shop?.name ?? 'Unknown Shop',
      shopLocation: _formatAddress(shop?.address),
      distance: _calculateShopDistance(),
      customerName: customer?.name ?? 'Guest',
      customerProfileImage: customer?.profileImage ?? '',
      deliveryAddress: _formatAddress(deliveryAddress),
      deliveryTime: 'Deliver within 30min', // TODO: Format based on orderDate
      status: _mapStatus(status),
    );
  }

  OrderStatus _mapStatus(String status) {
    return switch (status) {
      'assigned' => OrderStatus.assigned,
      'pickedUp' || 'picked_up' => OrderStatus.pickedUp,
      _ => OrderStatus.pending,
    };
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

  String _formatAddress(AddressEntity? address) {
    if (address == null) return 'No address provided';

    // Skipping district and division as they are not needed for now
    final parts = [
      address.street,
      address.city,
      address.district,
    ].where((part) => part.isNotEmpty);

    return parts.isEmpty ? 'No address details' : parts.join(', ');
  }
}
