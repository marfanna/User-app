import 'package:dart_mappable/dart_mappable.dart';

part 'order_model.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class OrderModel with OrderModelMappable {
  const OrderModel({
    this.id,
    this.orderId,
    this.customerId,
    this.shopId,
    this.franchiseId,
    this.items,
    this.subtotal,
    this.deliveryCharge,
    this.discountAmount,
    this.grandTotal,
    this.deliveryAddress,
    this.paymentMethod,
    this.paymentStatus,
    this.status,
    this.assignedRider,
    this.tip,
    this.bonus,
    this.orderDate,
    this.createdAt,
    this.updatedAt,
  });

  @MappableField(key: '_id')
  final String? id;
  final String? orderId;
  final CustomerModel? customerId;
  final ShopModel? shopId;
  final FranchiseModel? franchiseId;
  final List<OrderItemModel>? items;
  final double? subtotal;
  final double? deliveryCharge;
  final double? discountAmount;
  final double? grandTotal;
  final AddressModel? deliveryAddress;
  final String? paymentMethod;
  final String? paymentStatus;
  final String? status;
  final String? assignedRider;
  final double? tip;
  final double? bonus;
  final String? orderDate;
  final String? createdAt;
  final String? updatedAt;

  static final fromJson = OrderModelMapper.fromJson;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class FranchiseModel with FranchiseModelMappable {
  const FranchiseModel({this.id, this.name, this.code});

  @MappableField(key: '_id')
  final String? id;
  final String? name;
  final String? code;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class CustomerModel with CustomerModelMappable {
  const CustomerModel({
    this.id,
    this.phone,
    this.email,
    this.name,
    this.profileImage,
  });

  @MappableField(key: '_id')
  final String? id;
  final String? phone;
  final String? email;
  final String? name;
  final String? profileImage;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class ShopModel with ShopModelMappable {
  const ShopModel({this.id, this.name, this.address, this.contact});

  @MappableField(key: '_id')
  final String? id;
  final String? name;
  final AddressModel? address;
  final ContactModel? contact;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class ContactModel with ContactModelMappable {
  const ContactModel({
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
  final SocialMediaModel? socialMedia;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class SocialMediaModel with SocialMediaModelMappable {
  const SocialMediaModel({this.facebook, this.instagram, this.whatsapp});
  final String? facebook;
  final String? instagram;
  final String? whatsapp;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class OrderItemModel with OrderItemModelMappable {
  const OrderItemModel({
    this.itemId,
    this.itemType,
    this.name,
    this.quantity,
    this.unitPrice,
    this.buyingPrice,
    this.totalPrice,
    this.totalBuyingPrice,
    this.notes,
    this.options,
    this.variant,
  });

  final String? itemId;
  final String? itemType;
  final String? name;
  final int? quantity;
  final double? unitPrice;
  final double? buyingPrice;
  final double? totalPrice;
  final double? totalBuyingPrice;
  final String? notes;
  final List<dynamic>? options;
  final VariantModel? variant;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class VariantModel with VariantModelMappable {
  const VariantModel({this.id, this.name});

  @MappableField(key: '_id')
  final String? id;
  final String? name;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class AddressModel with AddressModelMappable {
  const AddressModel({
    this.id,
    this.type,
    this.street,
    this.city,
    this.district,
    this.division,
    this.landmark,
    this.phone,
    this.coordinates,
  });

  @MappableField(key: '_id')
  final String? id;
  final String? type;
  final String? street;
  final String? city;
  final String? district;
  final String? division;
  final String? landmark;
  final String? phone;
  final PointModel? coordinates;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class PointModel with PointModelMappable {
  const PointModel({this.type, this.coordinates});
  final String? type;
  final List<double>? coordinates;
}
