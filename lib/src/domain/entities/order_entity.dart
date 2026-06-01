class OrderEntity {
  const OrderEntity({
    required this.id,
    required this.orderId,
    this.customer,
    this.shop,
    this.franchise,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.discountAmount,
    required this.grandTotal,
    this.deliveryAddress,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    this.assignedRider,
    required this.tip,
    required this.bonus,
    this.orderDate,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String orderId;
  final CustomerEntity? customer;
  final ShopEntity? shop;
  final FranchiseEntity? franchise;
  final List<OrderItemEntity> items;
  final double subtotal;
  final double deliveryCharge;
  final double discountAmount;
  final double grandTotal;
  final AddressEntity? deliveryAddress;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final String? assignedRider;
  final double tip;
  final double bonus;
  final DateTime? orderDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}

class FranchiseEntity {
  const FranchiseEntity({
    required this.id,
    required this.name,
    required this.code,
  });

  final String id;
  final String name;
  final String code;
}

class CustomerEntity {
  const CustomerEntity({
    required this.id,
    required this.phone,
    this.email,
    required this.name,
    required this.profileImage,
  });

  final String id;
  final String phone;
  final String? email;
  final String name;
  final String profileImage;
}

class ShopEntity {
  const ShopEntity({
    required this.id,
    required this.name,
    this.address,
    this.primaryPhone,
    this.contact,
  });

  final String id;
  final String name;
  final AddressEntity? address;
  final String? primaryPhone;
  final ContactEntity? contact;
}

class ContactEntity {
  const ContactEntity({
    this.primaryPhone,
    this.secondaryPhone,
    this.email,
    this.website,
    this.socialMedia,
  });

  final String? primaryPhone;
  final String? secondaryPhone;
  final String? email;
  final String? website;
  final SocialMediaEntity? socialMedia;
}

class SocialMediaEntity {
  const SocialMediaEntity({this.facebook, this.instagram, this.whatsapp});
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
}

class OrderItemEntity {
  const OrderItemEntity({
    required this.itemId,
    this.itemType,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.buyingPrice,
    required this.totalPrice,
    this.totalBuyingPrice,
    this.notes,
    this.options,
    this.variant,
  });

  final String itemId;
  final String? itemType;
  final String name;
  final int quantity;
  final double unitPrice;
  final double? buyingPrice;
  final double totalPrice;
  final double? totalBuyingPrice;
  final String? notes;
  final List<dynamic>? options;
  final VariantEntity? variant;
}

class VariantEntity {
  const VariantEntity({required this.id, required this.name});

  final String id;
  final String name;
}

class AddressEntity {
  const AddressEntity({
    this.id,
    this.type,
    required this.street,
    required this.city,
    required this.district,
    required this.division,
    this.landmark,
    this.phone,
    this.coordinates,
  });

  final String? id;
  final String? type;
  final String street;
  final String city;
  final String district;
  final String division;
  final String? landmark;
  final String? phone;
  final CoordinatesEntity? coordinates;
}

class CoordinatesEntity {
  const CoordinatesEntity({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}
