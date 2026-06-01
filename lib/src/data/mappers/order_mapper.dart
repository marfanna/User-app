import '../../domain/entities/order_entity.dart';
import '../models/order/order_model.dart';

extension OrderModelToEntity on OrderModel {
  OrderEntity toEntity() {
    return OrderEntity(
      id: id ?? '',
      orderId: orderId ?? '',
      customer: customerId?.toEntity(),
      shop: shopId?.toEntity(),
      franchise: franchiseId?.toEntity(),
      items: items?.map((e) => e.toEntity()).toList() ?? [],
      subtotal: subtotal ?? 0.0,
      deliveryCharge: deliveryCharge ?? 0.0,
      discountAmount: discountAmount ?? 0.0,
      grandTotal: grandTotal ?? 0.0,
      deliveryAddress: deliveryAddress?.toEntity(),
      paymentMethod: paymentMethod ?? '',
      paymentStatus: paymentStatus ?? '',
      status: status ?? '',
      assignedRider: assignedRider,
      tip: tip ?? 0.0,
      bonus: bonus ?? 0.0,
      orderDate: DateTime.tryParse(orderDate ?? ''),
      createdAt: DateTime.tryParse(createdAt ?? ''),
      updatedAt: DateTime.tryParse(updatedAt ?? ''),
    );
  }
}

extension FranchiseModelToEntity on FranchiseModel {
  FranchiseEntity toEntity() {
    return FranchiseEntity(id: id ?? '', name: name ?? '', code: code ?? '');
  }
}

extension CustomerModelToEntity on CustomerModel {
  CustomerEntity toEntity() {
    return CustomerEntity(
      id: id ?? '',
      phone: phone ?? '',
      email: email,
      name: name ?? '',
      profileImage: profileImage ?? '',
    );
  }
}

extension ShopModelToEntity on ShopModel {
  ShopEntity toEntity() {
    return ShopEntity(
      id: id ?? '',
      name: name ?? '',
      address: address?.toEntity(),
      primaryPhone: contact?.primaryPhone,
      contact: contact?.toEntity(),
    );
  }
}

extension ContactModelToEntity on ContactModel {
  ContactEntity toEntity() {
    return ContactEntity(
      primaryPhone: primaryPhone,
      secondaryPhone: secondaryPhone,
      email: email,
      website: website,
      socialMedia: socialMedia?.toEntity(),
    );
  }
}

extension SocialMediaModelToEntity on SocialMediaModel {
  SocialMediaEntity toEntity() {
    return SocialMediaEntity(
      facebook: facebook,
      instagram: instagram,
      whatsapp: whatsapp,
    );
  }
}

extension OrderItemModelToEntity on OrderItemModel {
  OrderItemEntity toEntity() {
    return OrderItemEntity(
      itemId: itemId ?? '',
      itemType: itemType,
      name: name ?? '',
      quantity: quantity ?? 0,
      unitPrice: unitPrice ?? 0.0,
      buyingPrice: buyingPrice,
      totalPrice: totalPrice ?? 0.0,
      totalBuyingPrice: totalBuyingPrice,
      notes: notes,
      options: options,
      variant: variant?.toEntity(),
    );
  }
}

extension VariantModelToEntity on VariantModel {
  VariantEntity toEntity() {
    return VariantEntity(id: id ?? '', name: name ?? '');
  }
}

extension AddressModelToEntity on AddressModel {
  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      type: type,
      street: street ?? '',
      city: city ?? '',
      district: district ?? '',
      division: division ?? '',
      landmark: landmark,
      phone: phone,
      coordinates: coordinates?.toEntity(),
    );
  }
}

extension PointModelToEntity on PointModel {
  CoordinatesEntity toEntity() {
    return CoordinatesEntity(
      latitude: (coordinates != null && coordinates!.length >= 2)
          ? coordinates![1]
          : 0.0,
      longitude: (coordinates != null && coordinates!.length >= 2)
          ? coordinates![0]
          : 0.0,
    );
  }
}
