// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'order_model.dart';

class OrderModelMapper extends ClassMapperBase<OrderModel> {
  OrderModelMapper._();

  static OrderModelMapper? _instance;
  static OrderModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OrderModelMapper._());
      CustomerModelMapper.ensureInitialized();
      ShopModelMapper.ensureInitialized();
      FranchiseModelMapper.ensureInitialized();
      OrderItemModelMapper.ensureInitialized();
      AddressModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OrderModel';

  static String? _$id(OrderModel v) => v.id;
  static const Field<OrderModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$orderId(OrderModel v) => v.orderId;
  static const Field<OrderModel, String> _f$orderId = Field(
    'orderId',
    _$orderId,
    opt: true,
  );
  static CustomerModel? _$customerId(OrderModel v) => v.customerId;
  static const Field<OrderModel, CustomerModel> _f$customerId = Field(
    'customerId',
    _$customerId,
    opt: true,
  );
  static ShopModel? _$shopId(OrderModel v) => v.shopId;
  static const Field<OrderModel, ShopModel> _f$shopId = Field(
    'shopId',
    _$shopId,
    opt: true,
  );
  static FranchiseModel? _$franchiseId(OrderModel v) => v.franchiseId;
  static const Field<OrderModel, FranchiseModel> _f$franchiseId = Field(
    'franchiseId',
    _$franchiseId,
    opt: true,
  );
  static List<OrderItemModel>? _$items(OrderModel v) => v.items;
  static const Field<OrderModel, List<OrderItemModel>> _f$items = Field(
    'items',
    _$items,
    opt: true,
  );
  static double? _$subtotal(OrderModel v) => v.subtotal;
  static const Field<OrderModel, double> _f$subtotal = Field(
    'subtotal',
    _$subtotal,
    opt: true,
  );
  static double? _$deliveryCharge(OrderModel v) => v.deliveryCharge;
  static const Field<OrderModel, double> _f$deliveryCharge = Field(
    'deliveryCharge',
    _$deliveryCharge,
    opt: true,
  );
  static double? _$discountAmount(OrderModel v) => v.discountAmount;
  static const Field<OrderModel, double> _f$discountAmount = Field(
    'discountAmount',
    _$discountAmount,
    opt: true,
  );
  static double? _$grandTotal(OrderModel v) => v.grandTotal;
  static const Field<OrderModel, double> _f$grandTotal = Field(
    'grandTotal',
    _$grandTotal,
    opt: true,
  );
  static AddressModel? _$deliveryAddress(OrderModel v) => v.deliveryAddress;
  static const Field<OrderModel, AddressModel> _f$deliveryAddress = Field(
    'deliveryAddress',
    _$deliveryAddress,
    opt: true,
  );
  static String? _$paymentMethod(OrderModel v) => v.paymentMethod;
  static const Field<OrderModel, String> _f$paymentMethod = Field(
    'paymentMethod',
    _$paymentMethod,
    opt: true,
  );
  static String? _$paymentStatus(OrderModel v) => v.paymentStatus;
  static const Field<OrderModel, String> _f$paymentStatus = Field(
    'paymentStatus',
    _$paymentStatus,
    opt: true,
  );
  static String? _$status(OrderModel v) => v.status;
  static const Field<OrderModel, String> _f$status = Field(
    'status',
    _$status,
    opt: true,
  );
  static dynamic _$assignedRider(OrderModel v) => v.assignedRider;
  static const Field<OrderModel, dynamic> _f$assignedRider = Field(
    'assignedRider',
    _$assignedRider,
    opt: true,
  );
  static double? _$tip(OrderModel v) => v.tip;
  static const Field<OrderModel, double> _f$tip = Field(
    'tip',
    _$tip,
    opt: true,
  );
  static double? _$bonus(OrderModel v) => v.bonus;
  static const Field<OrderModel, double> _f$bonus = Field(
    'bonus',
    _$bonus,
    opt: true,
  );
  static String? _$orderDate(OrderModel v) => v.orderDate;
  static const Field<OrderModel, String> _f$orderDate = Field(
    'orderDate',
    _$orderDate,
    opt: true,
  );
  static String? _$createdAt(OrderModel v) => v.createdAt;
  static const Field<OrderModel, String> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    opt: true,
  );
  static String? _$updatedAt(OrderModel v) => v.updatedAt;
  static const Field<OrderModel, String> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    opt: true,
  );
  static String? _$confirmedAt(OrderModel v) => v.confirmedAt;
  static const Field<OrderModel, String> _f$confirmedAt = Field(
    'confirmedAt',
    _$confirmedAt,
    opt: true,
  );
  static String? _$preparingAt(OrderModel v) => v.preparingAt;
  static const Field<OrderModel, String> _f$preparingAt = Field(
    'preparingAt',
    _$preparingAt,
    opt: true,
  );
  static String? _$pickedUpAt(OrderModel v) => v.pickedUpAt;
  static const Field<OrderModel, String> _f$pickedUpAt = Field(
    'pickedUpAt',
    _$pickedUpAt,
    opt: true,
  );
  static String? _$deliveredAt(OrderModel v) => v.deliveredAt;
  static const Field<OrderModel, String> _f$deliveredAt = Field(
    'deliveredAt',
    _$deliveredAt,
    opt: true,
  );

  @override
  final MappableFields<OrderModel> fields = const {
    #id: _f$id,
    #orderId: _f$orderId,
    #customerId: _f$customerId,
    #shopId: _f$shopId,
    #franchiseId: _f$franchiseId,
    #items: _f$items,
    #subtotal: _f$subtotal,
    #deliveryCharge: _f$deliveryCharge,
    #discountAmount: _f$discountAmount,
    #grandTotal: _f$grandTotal,
    #deliveryAddress: _f$deliveryAddress,
    #paymentMethod: _f$paymentMethod,
    #paymentStatus: _f$paymentStatus,
    #status: _f$status,
    #assignedRider: _f$assignedRider,
    #tip: _f$tip,
    #bonus: _f$bonus,
    #orderDate: _f$orderDate,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #confirmedAt: _f$confirmedAt,
    #preparingAt: _f$preparingAt,
    #pickedUpAt: _f$pickedUpAt,
    #deliveredAt: _f$deliveredAt,
  };

  static OrderModel _instantiate(DecodingData data) {
    return OrderModel(
      id: data.dec(_f$id),
      orderId: data.dec(_f$orderId),
      customerId: data.dec(_f$customerId),
      shopId: data.dec(_f$shopId),
      franchiseId: data.dec(_f$franchiseId),
      items: data.dec(_f$items),
      subtotal: data.dec(_f$subtotal),
      deliveryCharge: data.dec(_f$deliveryCharge),
      discountAmount: data.dec(_f$discountAmount),
      grandTotal: data.dec(_f$grandTotal),
      deliveryAddress: data.dec(_f$deliveryAddress),
      paymentMethod: data.dec(_f$paymentMethod),
      paymentStatus: data.dec(_f$paymentStatus),
      status: data.dec(_f$status),
      assignedRider: data.dec(_f$assignedRider),
      tip: data.dec(_f$tip),
      bonus: data.dec(_f$bonus),
      orderDate: data.dec(_f$orderDate),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      confirmedAt: data.dec(_f$confirmedAt),
      preparingAt: data.dec(_f$preparingAt),
      pickedUpAt: data.dec(_f$pickedUpAt),
      deliveredAt: data.dec(_f$deliveredAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OrderModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OrderModel>(map);
  }

  static OrderModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<OrderModel>(json);
  }
}

mixin OrderModelMappable {
  String toJsonString() {
    return OrderModelMapper.ensureInitialized().encodeJson<OrderModel>(
      this as OrderModel,
    );
  }

  Map<String, dynamic> toJson() {
    return OrderModelMapper.ensureInitialized().encodeMap<OrderModel>(
      this as OrderModel,
    );
  }

  OrderModelCopyWith<OrderModel, OrderModel, OrderModel> get copyWith =>
      _OrderModelCopyWithImpl<OrderModel, OrderModel>(
        this as OrderModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return OrderModelMapper.ensureInitialized().stringifyValue(
      this as OrderModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return OrderModelMapper.ensureInitialized().equalsValue(
      this as OrderModel,
      other,
    );
  }

  @override
  int get hashCode {
    return OrderModelMapper.ensureInitialized().hashValue(this as OrderModel);
  }
}

extension OrderModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OrderModel, $Out> {
  OrderModelCopyWith<$R, OrderModel, $Out> get $asOrderModel =>
      $base.as((v, t, t2) => _OrderModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OrderModelCopyWith<$R, $In extends OrderModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CustomerModelCopyWith<$R, CustomerModel, CustomerModel>? get customerId;
  ShopModelCopyWith<$R, ShopModel, ShopModel>? get shopId;
  FranchiseModelCopyWith<$R, FranchiseModel, FranchiseModel>? get franchiseId;
  ListCopyWith<
    $R,
    OrderItemModel,
    OrderItemModelCopyWith<$R, OrderItemModel, OrderItemModel>
  >?
  get items;
  AddressModelCopyWith<$R, AddressModel, AddressModel>? get deliveryAddress;
  $R call({
    String? id,
    String? orderId,
    CustomerModel? customerId,
    ShopModel? shopId,
    FranchiseModel? franchiseId,
    List<OrderItemModel>? items,
    double? subtotal,
    double? deliveryCharge,
    double? discountAmount,
    double? grandTotal,
    AddressModel? deliveryAddress,
    String? paymentMethod,
    String? paymentStatus,
    String? status,
    dynamic assignedRider,
    double? tip,
    double? bonus,
    String? orderDate,
    String? createdAt,
    String? updatedAt,
    String? confirmedAt,
    String? preparingAt,
    String? pickedUpAt,
    String? deliveredAt,
  });
  OrderModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _OrderModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OrderModel, $Out>
    implements OrderModelCopyWith<$R, OrderModel, $Out> {
  _OrderModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OrderModel> $mapper =
      OrderModelMapper.ensureInitialized();
  @override
  CustomerModelCopyWith<$R, CustomerModel, CustomerModel>? get customerId =>
      $value.customerId?.copyWith.$chain((v) => call(customerId: v));
  @override
  ShopModelCopyWith<$R, ShopModel, ShopModel>? get shopId =>
      $value.shopId?.copyWith.$chain((v) => call(shopId: v));
  @override
  FranchiseModelCopyWith<$R, FranchiseModel, FranchiseModel>? get franchiseId =>
      $value.franchiseId?.copyWith.$chain((v) => call(franchiseId: v));
  @override
  ListCopyWith<
    $R,
    OrderItemModel,
    OrderItemModelCopyWith<$R, OrderItemModel, OrderItemModel>
  >?
  get items => $value.items != null
      ? ListCopyWith(
          $value.items!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(items: v),
        )
      : null;
  @override
  AddressModelCopyWith<$R, AddressModel, AddressModel>? get deliveryAddress =>
      $value.deliveryAddress?.copyWith.$chain((v) => call(deliveryAddress: v));
  @override
  $R call({
    Object? id = $none,
    Object? orderId = $none,
    Object? customerId = $none,
    Object? shopId = $none,
    Object? franchiseId = $none,
    Object? items = $none,
    Object? subtotal = $none,
    Object? deliveryCharge = $none,
    Object? discountAmount = $none,
    Object? grandTotal = $none,
    Object? deliveryAddress = $none,
    Object? paymentMethod = $none,
    Object? paymentStatus = $none,
    Object? status = $none,
    Object? assignedRider = $none,
    Object? tip = $none,
    Object? bonus = $none,
    Object? orderDate = $none,
    Object? createdAt = $none,
    Object? updatedAt = $none,
    Object? confirmedAt = $none,
    Object? preparingAt = $none,
    Object? pickedUpAt = $none,
    Object? deliveredAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (orderId != $none) #orderId: orderId,
      if (customerId != $none) #customerId: customerId,
      if (shopId != $none) #shopId: shopId,
      if (franchiseId != $none) #franchiseId: franchiseId,
      if (items != $none) #items: items,
      if (subtotal != $none) #subtotal: subtotal,
      if (deliveryCharge != $none) #deliveryCharge: deliveryCharge,
      if (discountAmount != $none) #discountAmount: discountAmount,
      if (grandTotal != $none) #grandTotal: grandTotal,
      if (deliveryAddress != $none) #deliveryAddress: deliveryAddress,
      if (paymentMethod != $none) #paymentMethod: paymentMethod,
      if (paymentStatus != $none) #paymentStatus: paymentStatus,
      if (status != $none) #status: status,
      if (assignedRider != $none) #assignedRider: assignedRider,
      if (tip != $none) #tip: tip,
      if (bonus != $none) #bonus: bonus,
      if (orderDate != $none) #orderDate: orderDate,
      if (createdAt != $none) #createdAt: createdAt,
      if (updatedAt != $none) #updatedAt: updatedAt,
      if (confirmedAt != $none) #confirmedAt: confirmedAt,
      if (preparingAt != $none) #preparingAt: preparingAt,
      if (pickedUpAt != $none) #pickedUpAt: pickedUpAt,
      if (deliveredAt != $none) #deliveredAt: deliveredAt,
    }),
  );
  @override
  OrderModel $make(CopyWithData data) => OrderModel(
    id: data.get(#id, or: $value.id),
    orderId: data.get(#orderId, or: $value.orderId),
    customerId: data.get(#customerId, or: $value.customerId),
    shopId: data.get(#shopId, or: $value.shopId),
    franchiseId: data.get(#franchiseId, or: $value.franchiseId),
    items: data.get(#items, or: $value.items),
    subtotal: data.get(#subtotal, or: $value.subtotal),
    deliveryCharge: data.get(#deliveryCharge, or: $value.deliveryCharge),
    discountAmount: data.get(#discountAmount, or: $value.discountAmount),
    grandTotal: data.get(#grandTotal, or: $value.grandTotal),
    deliveryAddress: data.get(#deliveryAddress, or: $value.deliveryAddress),
    paymentMethod: data.get(#paymentMethod, or: $value.paymentMethod),
    paymentStatus: data.get(#paymentStatus, or: $value.paymentStatus),
    status: data.get(#status, or: $value.status),
    assignedRider: data.get(#assignedRider, or: $value.assignedRider),
    tip: data.get(#tip, or: $value.tip),
    bonus: data.get(#bonus, or: $value.bonus),
    orderDate: data.get(#orderDate, or: $value.orderDate),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    confirmedAt: data.get(#confirmedAt, or: $value.confirmedAt),
    preparingAt: data.get(#preparingAt, or: $value.preparingAt),
    pickedUpAt: data.get(#pickedUpAt, or: $value.pickedUpAt),
    deliveredAt: data.get(#deliveredAt, or: $value.deliveredAt),
  );

  @override
  OrderModelCopyWith<$R2, OrderModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _OrderModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class CustomerModelMapper extends ClassMapperBase<CustomerModel> {
  CustomerModelMapper._();

  static CustomerModelMapper? _instance;
  static CustomerModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CustomerModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CustomerModel';

  static String? _$id(CustomerModel v) => v.id;
  static const Field<CustomerModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$phone(CustomerModel v) => v.phone;
  static const Field<CustomerModel, String> _f$phone = Field(
    'phone',
    _$phone,
    opt: true,
  );
  static String? _$email(CustomerModel v) => v.email;
  static const Field<CustomerModel, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$name(CustomerModel v) => v.name;
  static const Field<CustomerModel, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$profileImage(CustomerModel v) => v.profileImage;
  static const Field<CustomerModel, String> _f$profileImage = Field(
    'profileImage',
    _$profileImage,
    opt: true,
  );

  @override
  final MappableFields<CustomerModel> fields = const {
    #id: _f$id,
    #phone: _f$phone,
    #email: _f$email,
    #name: _f$name,
    #profileImage: _f$profileImage,
  };

  static CustomerModel _instantiate(DecodingData data) {
    return CustomerModel(
      id: data.dec(_f$id),
      phone: data.dec(_f$phone),
      email: data.dec(_f$email),
      name: data.dec(_f$name),
      profileImage: data.dec(_f$profileImage),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CustomerModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CustomerModel>(map);
  }

  static CustomerModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<CustomerModel>(json);
  }
}

mixin CustomerModelMappable {
  String toJsonString() {
    return CustomerModelMapper.ensureInitialized().encodeJson<CustomerModel>(
      this as CustomerModel,
    );
  }

  Map<String, dynamic> toJson() {
    return CustomerModelMapper.ensureInitialized().encodeMap<CustomerModel>(
      this as CustomerModel,
    );
  }

  CustomerModelCopyWith<CustomerModel, CustomerModel, CustomerModel>
  get copyWith => _CustomerModelCopyWithImpl<CustomerModel, CustomerModel>(
    this as CustomerModel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return CustomerModelMapper.ensureInitialized().stringifyValue(
      this as CustomerModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return CustomerModelMapper.ensureInitialized().equalsValue(
      this as CustomerModel,
      other,
    );
  }

  @override
  int get hashCode {
    return CustomerModelMapper.ensureInitialized().hashValue(
      this as CustomerModel,
    );
  }
}

extension CustomerModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CustomerModel, $Out> {
  CustomerModelCopyWith<$R, CustomerModel, $Out> get $asCustomerModel =>
      $base.as((v, t, t2) => _CustomerModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CustomerModelCopyWith<$R, $In extends CustomerModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? phone,
    String? email,
    String? name,
    String? profileImage,
  });
  CustomerModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CustomerModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CustomerModel, $Out>
    implements CustomerModelCopyWith<$R, CustomerModel, $Out> {
  _CustomerModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CustomerModel> $mapper =
      CustomerModelMapper.ensureInitialized();
  @override
  $R call({
    Object? id = $none,
    Object? phone = $none,
    Object? email = $none,
    Object? name = $none,
    Object? profileImage = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (phone != $none) #phone: phone,
      if (email != $none) #email: email,
      if (name != $none) #name: name,
      if (profileImage != $none) #profileImage: profileImage,
    }),
  );
  @override
  CustomerModel $make(CopyWithData data) => CustomerModel(
    id: data.get(#id, or: $value.id),
    phone: data.get(#phone, or: $value.phone),
    email: data.get(#email, or: $value.email),
    name: data.get(#name, or: $value.name),
    profileImage: data.get(#profileImage, or: $value.profileImage),
  );

  @override
  CustomerModelCopyWith<$R2, CustomerModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CustomerModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ShopModelMapper extends ClassMapperBase<ShopModel> {
  ShopModelMapper._();

  static ShopModelMapper? _instance;
  static ShopModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ShopModelMapper._());
      AddressModelMapper.ensureInitialized();
      ContactModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ShopModel';

  static String? _$id(ShopModel v) => v.id;
  static const Field<ShopModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$name(ShopModel v) => v.name;
  static const Field<ShopModel, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static AddressModel? _$address(ShopModel v) => v.address;
  static const Field<ShopModel, AddressModel> _f$address = Field(
    'address',
    _$address,
    opt: true,
  );
  static ContactModel? _$contact(ShopModel v) => v.contact;
  static const Field<ShopModel, ContactModel> _f$contact = Field(
    'contact',
    _$contact,
    opt: true,
  );

  @override
  final MappableFields<ShopModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #address: _f$address,
    #contact: _f$contact,
  };

  static ShopModel _instantiate(DecodingData data) {
    return ShopModel(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      address: data.dec(_f$address),
      contact: data.dec(_f$contact),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ShopModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ShopModel>(map);
  }

  static ShopModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<ShopModel>(json);
  }
}

mixin ShopModelMappable {
  String toJsonString() {
    return ShopModelMapper.ensureInitialized().encodeJson<ShopModel>(
      this as ShopModel,
    );
  }

  Map<String, dynamic> toJson() {
    return ShopModelMapper.ensureInitialized().encodeMap<ShopModel>(
      this as ShopModel,
    );
  }

  ShopModelCopyWith<ShopModel, ShopModel, ShopModel> get copyWith =>
      _ShopModelCopyWithImpl<ShopModel, ShopModel>(
        this as ShopModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ShopModelMapper.ensureInitialized().stringifyValue(
      this as ShopModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return ShopModelMapper.ensureInitialized().equalsValue(
      this as ShopModel,
      other,
    );
  }

  @override
  int get hashCode {
    return ShopModelMapper.ensureInitialized().hashValue(this as ShopModel);
  }
}

extension ShopModelValueCopy<$R, $Out> on ObjectCopyWith<$R, ShopModel, $Out> {
  ShopModelCopyWith<$R, ShopModel, $Out> get $asShopModel =>
      $base.as((v, t, t2) => _ShopModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ShopModelCopyWith<$R, $In extends ShopModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AddressModelCopyWith<$R, AddressModel, AddressModel>? get address;
  ContactModelCopyWith<$R, ContactModel, ContactModel>? get contact;
  $R call({
    String? id,
    String? name,
    AddressModel? address,
    ContactModel? contact,
  });
  ShopModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ShopModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ShopModel, $Out>
    implements ShopModelCopyWith<$R, ShopModel, $Out> {
  _ShopModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ShopModel> $mapper =
      ShopModelMapper.ensureInitialized();
  @override
  AddressModelCopyWith<$R, AddressModel, AddressModel>? get address =>
      $value.address?.copyWith.$chain((v) => call(address: v));
  @override
  ContactModelCopyWith<$R, ContactModel, ContactModel>? get contact =>
      $value.contact?.copyWith.$chain((v) => call(contact: v));
  @override
  $R call({
    Object? id = $none,
    Object? name = $none,
    Object? address = $none,
    Object? contact = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (name != $none) #name: name,
      if (address != $none) #address: address,
      if (contact != $none) #contact: contact,
    }),
  );
  @override
  ShopModel $make(CopyWithData data) => ShopModel(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    address: data.get(#address, or: $value.address),
    contact: data.get(#contact, or: $value.contact),
  );

  @override
  ShopModelCopyWith<$R2, ShopModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ShopModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class AddressModelMapper extends ClassMapperBase<AddressModel> {
  AddressModelMapper._();

  static AddressModelMapper? _instance;
  static AddressModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AddressModelMapper._());
      PointModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AddressModel';

  static String? _$id(AddressModel v) => v.id;
  static const Field<AddressModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$type(AddressModel v) => v.type;
  static const Field<AddressModel, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
  );
  static String? _$label(AddressModel v) => v.label;
  static const Field<AddressModel, String> _f$label = Field(
    'label',
    _$label,
    opt: true,
  );
  static String? _$street(AddressModel v) => v.street;
  static const Field<AddressModel, String> _f$street = Field(
    'street',
    _$street,
    opt: true,
  );
  static String? _$city(AddressModel v) => v.city;
  static const Field<AddressModel, String> _f$city = Field(
    'city',
    _$city,
    opt: true,
  );
  static String? _$district(AddressModel v) => v.district;
  static const Field<AddressModel, String> _f$district = Field(
    'district',
    _$district,
    opt: true,
  );
  static String? _$division(AddressModel v) => v.division;
  static const Field<AddressModel, String> _f$division = Field(
    'division',
    _$division,
    opt: true,
  );
  static String? _$landmark(AddressModel v) => v.landmark;
  static const Field<AddressModel, String> _f$landmark = Field(
    'landmark',
    _$landmark,
    opt: true,
  );
  static String? _$phone(AddressModel v) => v.phone;
  static const Field<AddressModel, String> _f$phone = Field(
    'phone',
    _$phone,
    opt: true,
  );
  static PointModel? _$coordinates(AddressModel v) => v.coordinates;
  static const Field<AddressModel, PointModel> _f$coordinates = Field(
    'coordinates',
    _$coordinates,
    opt: true,
  );

  @override
  final MappableFields<AddressModel> fields = const {
    #id: _f$id,
    #type: _f$type,
    #label: _f$label,
    #street: _f$street,
    #city: _f$city,
    #district: _f$district,
    #division: _f$division,
    #landmark: _f$landmark,
    #phone: _f$phone,
    #coordinates: _f$coordinates,
  };

  static AddressModel _instantiate(DecodingData data) {
    return AddressModel(
      id: data.dec(_f$id),
      type: data.dec(_f$type),
      label: data.dec(_f$label),
      street: data.dec(_f$street),
      city: data.dec(_f$city),
      district: data.dec(_f$district),
      division: data.dec(_f$division),
      landmark: data.dec(_f$landmark),
      phone: data.dec(_f$phone),
      coordinates: data.dec(_f$coordinates),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static AddressModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AddressModel>(map);
  }

  static AddressModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<AddressModel>(json);
  }
}

mixin AddressModelMappable {
  String toJsonString() {
    return AddressModelMapper.ensureInitialized().encodeJson<AddressModel>(
      this as AddressModel,
    );
  }

  Map<String, dynamic> toJson() {
    return AddressModelMapper.ensureInitialized().encodeMap<AddressModel>(
      this as AddressModel,
    );
  }

  AddressModelCopyWith<AddressModel, AddressModel, AddressModel> get copyWith =>
      _AddressModelCopyWithImpl<AddressModel, AddressModel>(
        this as AddressModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return AddressModelMapper.ensureInitialized().stringifyValue(
      this as AddressModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return AddressModelMapper.ensureInitialized().equalsValue(
      this as AddressModel,
      other,
    );
  }

  @override
  int get hashCode {
    return AddressModelMapper.ensureInitialized().hashValue(
      this as AddressModel,
    );
  }
}

extension AddressModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, AddressModel, $Out> {
  AddressModelCopyWith<$R, AddressModel, $Out> get $asAddressModel =>
      $base.as((v, t, t2) => _AddressModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class AddressModelCopyWith<$R, $In extends AddressModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PointModelCopyWith<$R, PointModel, PointModel>? get coordinates;
  $R call({
    String? id,
    String? type,
    String? label,
    String? street,
    String? city,
    String? district,
    String? division,
    String? landmark,
    String? phone,
    PointModel? coordinates,
  });
  AddressModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AddressModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, AddressModel, $Out>
    implements AddressModelCopyWith<$R, AddressModel, $Out> {
  _AddressModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AddressModel> $mapper =
      AddressModelMapper.ensureInitialized();
  @override
  PointModelCopyWith<$R, PointModel, PointModel>? get coordinates =>
      $value.coordinates?.copyWith.$chain((v) => call(coordinates: v));
  @override
  $R call({
    Object? id = $none,
    Object? type = $none,
    Object? label = $none,
    Object? street = $none,
    Object? city = $none,
    Object? district = $none,
    Object? division = $none,
    Object? landmark = $none,
    Object? phone = $none,
    Object? coordinates = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (type != $none) #type: type,
      if (label != $none) #label: label,
      if (street != $none) #street: street,
      if (city != $none) #city: city,
      if (district != $none) #district: district,
      if (division != $none) #division: division,
      if (landmark != $none) #landmark: landmark,
      if (phone != $none) #phone: phone,
      if (coordinates != $none) #coordinates: coordinates,
    }),
  );
  @override
  AddressModel $make(CopyWithData data) => AddressModel(
    id: data.get(#id, or: $value.id),
    type: data.get(#type, or: $value.type),
    label: data.get(#label, or: $value.label),
    street: data.get(#street, or: $value.street),
    city: data.get(#city, or: $value.city),
    district: data.get(#district, or: $value.district),
    division: data.get(#division, or: $value.division),
    landmark: data.get(#landmark, or: $value.landmark),
    phone: data.get(#phone, or: $value.phone),
    coordinates: data.get(#coordinates, or: $value.coordinates),
  );

  @override
  AddressModelCopyWith<$R2, AddressModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _AddressModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PointModelMapper extends ClassMapperBase<PointModel> {
  PointModelMapper._();

  static PointModelMapper? _instance;
  static PointModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PointModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PointModel';

  static String? _$type(PointModel v) => v.type;
  static const Field<PointModel, String> _f$type = Field(
    'type',
    _$type,
    opt: true,
  );
  static List<double>? _$coordinates(PointModel v) => v.coordinates;
  static const Field<PointModel, List<double>> _f$coordinates = Field(
    'coordinates',
    _$coordinates,
    opt: true,
  );

  @override
  final MappableFields<PointModel> fields = const {
    #type: _f$type,
    #coordinates: _f$coordinates,
  };

  static PointModel _instantiate(DecodingData data) {
    return PointModel(
      type: data.dec(_f$type),
      coordinates: data.dec(_f$coordinates),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PointModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PointModel>(map);
  }

  static PointModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<PointModel>(json);
  }
}

mixin PointModelMappable {
  String toJsonString() {
    return PointModelMapper.ensureInitialized().encodeJson<PointModel>(
      this as PointModel,
    );
  }

  Map<String, dynamic> toJson() {
    return PointModelMapper.ensureInitialized().encodeMap<PointModel>(
      this as PointModel,
    );
  }

  PointModelCopyWith<PointModel, PointModel, PointModel> get copyWith =>
      _PointModelCopyWithImpl<PointModel, PointModel>(
        this as PointModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PointModelMapper.ensureInitialized().stringifyValue(
      this as PointModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return PointModelMapper.ensureInitialized().equalsValue(
      this as PointModel,
      other,
    );
  }

  @override
  int get hashCode {
    return PointModelMapper.ensureInitialized().hashValue(this as PointModel);
  }
}

extension PointModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PointModel, $Out> {
  PointModelCopyWith<$R, PointModel, $Out> get $asPointModel =>
      $base.as((v, t, t2) => _PointModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PointModelCopyWith<$R, $In extends PointModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>? get coordinates;
  $R call({String? type, List<double>? coordinates});
  PointModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PointModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PointModel, $Out>
    implements PointModelCopyWith<$R, PointModel, $Out> {
  _PointModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PointModel> $mapper =
      PointModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, double, ObjectCopyWith<$R, double, double>>?
  get coordinates => $value.coordinates != null
      ? ListCopyWith(
          $value.coordinates!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(coordinates: v),
        )
      : null;
  @override
  $R call({Object? type = $none, Object? coordinates = $none}) => $apply(
    FieldCopyWithData({
      if (type != $none) #type: type,
      if (coordinates != $none) #coordinates: coordinates,
    }),
  );
  @override
  PointModel $make(CopyWithData data) => PointModel(
    type: data.get(#type, or: $value.type),
    coordinates: data.get(#coordinates, or: $value.coordinates),
  );

  @override
  PointModelCopyWith<$R2, PointModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PointModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ContactModelMapper extends ClassMapperBase<ContactModel> {
  ContactModelMapper._();

  static ContactModelMapper? _instance;
  static ContactModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContactModelMapper._());
      SocialMediaModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ContactModel';

  static String? _$primaryPhone(ContactModel v) => v.primaryPhone;
  static const Field<ContactModel, String> _f$primaryPhone = Field(
    'primaryPhone',
    _$primaryPhone,
    opt: true,
  );
  static String? _$secondaryPhone(ContactModel v) => v.secondaryPhone;
  static const Field<ContactModel, String> _f$secondaryPhone = Field(
    'secondaryPhone',
    _$secondaryPhone,
    opt: true,
  );
  static String? _$email(ContactModel v) => v.email;
  static const Field<ContactModel, String> _f$email = Field(
    'email',
    _$email,
    opt: true,
  );
  static String? _$website(ContactModel v) => v.website;
  static const Field<ContactModel, String> _f$website = Field(
    'website',
    _$website,
    opt: true,
  );
  static SocialMediaModel? _$socialMedia(ContactModel v) => v.socialMedia;
  static const Field<ContactModel, SocialMediaModel> _f$socialMedia = Field(
    'socialMedia',
    _$socialMedia,
    opt: true,
  );

  @override
  final MappableFields<ContactModel> fields = const {
    #primaryPhone: _f$primaryPhone,
    #secondaryPhone: _f$secondaryPhone,
    #email: _f$email,
    #website: _f$website,
    #socialMedia: _f$socialMedia,
  };

  static ContactModel _instantiate(DecodingData data) {
    return ContactModel(
      primaryPhone: data.dec(_f$primaryPhone),
      secondaryPhone: data.dec(_f$secondaryPhone),
      email: data.dec(_f$email),
      website: data.dec(_f$website),
      socialMedia: data.dec(_f$socialMedia),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ContactModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ContactModel>(map);
  }

  static ContactModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<ContactModel>(json);
  }
}

mixin ContactModelMappable {
  String toJsonString() {
    return ContactModelMapper.ensureInitialized().encodeJson<ContactModel>(
      this as ContactModel,
    );
  }

  Map<String, dynamic> toJson() {
    return ContactModelMapper.ensureInitialized().encodeMap<ContactModel>(
      this as ContactModel,
    );
  }

  ContactModelCopyWith<ContactModel, ContactModel, ContactModel> get copyWith =>
      _ContactModelCopyWithImpl<ContactModel, ContactModel>(
        this as ContactModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ContactModelMapper.ensureInitialized().stringifyValue(
      this as ContactModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return ContactModelMapper.ensureInitialized().equalsValue(
      this as ContactModel,
      other,
    );
  }

  @override
  int get hashCode {
    return ContactModelMapper.ensureInitialized().hashValue(
      this as ContactModel,
    );
  }
}

extension ContactModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ContactModel, $Out> {
  ContactModelCopyWith<$R, ContactModel, $Out> get $asContactModel =>
      $base.as((v, t, t2) => _ContactModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ContactModelCopyWith<$R, $In extends ContactModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  SocialMediaModelCopyWith<$R, SocialMediaModel, SocialMediaModel>?
  get socialMedia;
  $R call({
    String? primaryPhone,
    String? secondaryPhone,
    String? email,
    String? website,
    SocialMediaModel? socialMedia,
  });
  ContactModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ContactModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ContactModel, $Out>
    implements ContactModelCopyWith<$R, ContactModel, $Out> {
  _ContactModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ContactModel> $mapper =
      ContactModelMapper.ensureInitialized();
  @override
  SocialMediaModelCopyWith<$R, SocialMediaModel, SocialMediaModel>?
  get socialMedia =>
      $value.socialMedia?.copyWith.$chain((v) => call(socialMedia: v));
  @override
  $R call({
    Object? primaryPhone = $none,
    Object? secondaryPhone = $none,
    Object? email = $none,
    Object? website = $none,
    Object? socialMedia = $none,
  }) => $apply(
    FieldCopyWithData({
      if (primaryPhone != $none) #primaryPhone: primaryPhone,
      if (secondaryPhone != $none) #secondaryPhone: secondaryPhone,
      if (email != $none) #email: email,
      if (website != $none) #website: website,
      if (socialMedia != $none) #socialMedia: socialMedia,
    }),
  );
  @override
  ContactModel $make(CopyWithData data) => ContactModel(
    primaryPhone: data.get(#primaryPhone, or: $value.primaryPhone),
    secondaryPhone: data.get(#secondaryPhone, or: $value.secondaryPhone),
    email: data.get(#email, or: $value.email),
    website: data.get(#website, or: $value.website),
    socialMedia: data.get(#socialMedia, or: $value.socialMedia),
  );

  @override
  ContactModelCopyWith<$R2, ContactModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ContactModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SocialMediaModelMapper extends ClassMapperBase<SocialMediaModel> {
  SocialMediaModelMapper._();

  static SocialMediaModelMapper? _instance;
  static SocialMediaModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SocialMediaModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SocialMediaModel';

  static String? _$facebook(SocialMediaModel v) => v.facebook;
  static const Field<SocialMediaModel, String> _f$facebook = Field(
    'facebook',
    _$facebook,
    opt: true,
  );
  static String? _$instagram(SocialMediaModel v) => v.instagram;
  static const Field<SocialMediaModel, String> _f$instagram = Field(
    'instagram',
    _$instagram,
    opt: true,
  );
  static String? _$whatsapp(SocialMediaModel v) => v.whatsapp;
  static const Field<SocialMediaModel, String> _f$whatsapp = Field(
    'whatsapp',
    _$whatsapp,
    opt: true,
  );

  @override
  final MappableFields<SocialMediaModel> fields = const {
    #facebook: _f$facebook,
    #instagram: _f$instagram,
    #whatsapp: _f$whatsapp,
  };

  static SocialMediaModel _instantiate(DecodingData data) {
    return SocialMediaModel(
      facebook: data.dec(_f$facebook),
      instagram: data.dec(_f$instagram),
      whatsapp: data.dec(_f$whatsapp),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SocialMediaModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SocialMediaModel>(map);
  }

  static SocialMediaModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<SocialMediaModel>(json);
  }
}

mixin SocialMediaModelMappable {
  String toJsonString() {
    return SocialMediaModelMapper.ensureInitialized()
        .encodeJson<SocialMediaModel>(this as SocialMediaModel);
  }

  Map<String, dynamic> toJson() {
    return SocialMediaModelMapper.ensureInitialized()
        .encodeMap<SocialMediaModel>(this as SocialMediaModel);
  }

  SocialMediaModelCopyWith<SocialMediaModel, SocialMediaModel, SocialMediaModel>
  get copyWith =>
      _SocialMediaModelCopyWithImpl<SocialMediaModel, SocialMediaModel>(
        this as SocialMediaModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SocialMediaModelMapper.ensureInitialized().stringifyValue(
      this as SocialMediaModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return SocialMediaModelMapper.ensureInitialized().equalsValue(
      this as SocialMediaModel,
      other,
    );
  }

  @override
  int get hashCode {
    return SocialMediaModelMapper.ensureInitialized().hashValue(
      this as SocialMediaModel,
    );
  }
}

extension SocialMediaModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SocialMediaModel, $Out> {
  SocialMediaModelCopyWith<$R, SocialMediaModel, $Out>
  get $asSocialMediaModel =>
      $base.as((v, t, t2) => _SocialMediaModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SocialMediaModelCopyWith<$R, $In extends SocialMediaModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? facebook, String? instagram, String? whatsapp});
  SocialMediaModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SocialMediaModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SocialMediaModel, $Out>
    implements SocialMediaModelCopyWith<$R, SocialMediaModel, $Out> {
  _SocialMediaModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SocialMediaModel> $mapper =
      SocialMediaModelMapper.ensureInitialized();
  @override
  $R call({
    Object? facebook = $none,
    Object? instagram = $none,
    Object? whatsapp = $none,
  }) => $apply(
    FieldCopyWithData({
      if (facebook != $none) #facebook: facebook,
      if (instagram != $none) #instagram: instagram,
      if (whatsapp != $none) #whatsapp: whatsapp,
    }),
  );
  @override
  SocialMediaModel $make(CopyWithData data) => SocialMediaModel(
    facebook: data.get(#facebook, or: $value.facebook),
    instagram: data.get(#instagram, or: $value.instagram),
    whatsapp: data.get(#whatsapp, or: $value.whatsapp),
  );

  @override
  SocialMediaModelCopyWith<$R2, SocialMediaModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SocialMediaModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class FranchiseModelMapper extends ClassMapperBase<FranchiseModel> {
  FranchiseModelMapper._();

  static FranchiseModelMapper? _instance;
  static FranchiseModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FranchiseModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FranchiseModel';

  static String? _$id(FranchiseModel v) => v.id;
  static const Field<FranchiseModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$name(FranchiseModel v) => v.name;
  static const Field<FranchiseModel, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$code(FranchiseModel v) => v.code;
  static const Field<FranchiseModel, String> _f$code = Field(
    'code',
    _$code,
    opt: true,
  );

  @override
  final MappableFields<FranchiseModel> fields = const {
    #id: _f$id,
    #name: _f$name,
    #code: _f$code,
  };

  static FranchiseModel _instantiate(DecodingData data) {
    return FranchiseModel(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      code: data.dec(_f$code),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FranchiseModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FranchiseModel>(map);
  }

  static FranchiseModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<FranchiseModel>(json);
  }
}

mixin FranchiseModelMappable {
  String toJsonString() {
    return FranchiseModelMapper.ensureInitialized().encodeJson<FranchiseModel>(
      this as FranchiseModel,
    );
  }

  Map<String, dynamic> toJson() {
    return FranchiseModelMapper.ensureInitialized().encodeMap<FranchiseModel>(
      this as FranchiseModel,
    );
  }

  FranchiseModelCopyWith<FranchiseModel, FranchiseModel, FranchiseModel>
  get copyWith => _FranchiseModelCopyWithImpl<FranchiseModel, FranchiseModel>(
    this as FranchiseModel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return FranchiseModelMapper.ensureInitialized().stringifyValue(
      this as FranchiseModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return FranchiseModelMapper.ensureInitialized().equalsValue(
      this as FranchiseModel,
      other,
    );
  }

  @override
  int get hashCode {
    return FranchiseModelMapper.ensureInitialized().hashValue(
      this as FranchiseModel,
    );
  }
}

extension FranchiseModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FranchiseModel, $Out> {
  FranchiseModelCopyWith<$R, FranchiseModel, $Out> get $asFranchiseModel =>
      $base.as((v, t, t2) => _FranchiseModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FranchiseModelCopyWith<$R, $In extends FranchiseModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name, String? code});
  FranchiseModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FranchiseModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FranchiseModel, $Out>
    implements FranchiseModelCopyWith<$R, FranchiseModel, $Out> {
  _FranchiseModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FranchiseModel> $mapper =
      FranchiseModelMapper.ensureInitialized();
  @override
  $R call({Object? id = $none, Object? name = $none, Object? code = $none}) =>
      $apply(
        FieldCopyWithData({
          if (id != $none) #id: id,
          if (name != $none) #name: name,
          if (code != $none) #code: code,
        }),
      );
  @override
  FranchiseModel $make(CopyWithData data) => FranchiseModel(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    code: data.get(#code, or: $value.code),
  );

  @override
  FranchiseModelCopyWith<$R2, FranchiseModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FranchiseModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class OrderItemModelMapper extends ClassMapperBase<OrderItemModel> {
  OrderItemModelMapper._();

  static OrderItemModelMapper? _instance;
  static OrderItemModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OrderItemModelMapper._());
      VariantModelMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'OrderItemModel';

  static String? _$itemId(OrderItemModel v) => v.itemId;
  static const Field<OrderItemModel, String> _f$itemId = Field(
    'itemId',
    _$itemId,
    opt: true,
  );
  static String? _$itemType(OrderItemModel v) => v.itemType;
  static const Field<OrderItemModel, String> _f$itemType = Field(
    'itemType',
    _$itemType,
    opt: true,
  );
  static String? _$name(OrderItemModel v) => v.name;
  static const Field<OrderItemModel, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static int? _$quantity(OrderItemModel v) => v.quantity;
  static const Field<OrderItemModel, int> _f$quantity = Field(
    'quantity',
    _$quantity,
    opt: true,
  );
  static double? _$unitPrice(OrderItemModel v) => v.unitPrice;
  static const Field<OrderItemModel, double> _f$unitPrice = Field(
    'unitPrice',
    _$unitPrice,
    opt: true,
  );
  static double? _$buyingPrice(OrderItemModel v) => v.buyingPrice;
  static const Field<OrderItemModel, double> _f$buyingPrice = Field(
    'buyingPrice',
    _$buyingPrice,
    opt: true,
  );
  static double? _$totalPrice(OrderItemModel v) => v.totalPrice;
  static const Field<OrderItemModel, double> _f$totalPrice = Field(
    'totalPrice',
    _$totalPrice,
    opt: true,
  );
  static double? _$totalBuyingPrice(OrderItemModel v) => v.totalBuyingPrice;
  static const Field<OrderItemModel, double> _f$totalBuyingPrice = Field(
    'totalBuyingPrice',
    _$totalBuyingPrice,
    opt: true,
  );
  static String? _$notes(OrderItemModel v) => v.notes;
  static const Field<OrderItemModel, String> _f$notes = Field(
    'notes',
    _$notes,
    opt: true,
  );
  static List<dynamic>? _$options(OrderItemModel v) => v.options;
  static const Field<OrderItemModel, List<dynamic>> _f$options = Field(
    'options',
    _$options,
    opt: true,
  );
  static VariantModel? _$variant(OrderItemModel v) => v.variant;
  static const Field<OrderItemModel, VariantModel> _f$variant = Field(
    'variant',
    _$variant,
    opt: true,
  );

  @override
  final MappableFields<OrderItemModel> fields = const {
    #itemId: _f$itemId,
    #itemType: _f$itemType,
    #name: _f$name,
    #quantity: _f$quantity,
    #unitPrice: _f$unitPrice,
    #buyingPrice: _f$buyingPrice,
    #totalPrice: _f$totalPrice,
    #totalBuyingPrice: _f$totalBuyingPrice,
    #notes: _f$notes,
    #options: _f$options,
    #variant: _f$variant,
  };

  static OrderItemModel _instantiate(DecodingData data) {
    return OrderItemModel(
      itemId: data.dec(_f$itemId),
      itemType: data.dec(_f$itemType),
      name: data.dec(_f$name),
      quantity: data.dec(_f$quantity),
      unitPrice: data.dec(_f$unitPrice),
      buyingPrice: data.dec(_f$buyingPrice),
      totalPrice: data.dec(_f$totalPrice),
      totalBuyingPrice: data.dec(_f$totalBuyingPrice),
      notes: data.dec(_f$notes),
      options: data.dec(_f$options),
      variant: data.dec(_f$variant),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static OrderItemModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<OrderItemModel>(map);
  }

  static OrderItemModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<OrderItemModel>(json);
  }
}

mixin OrderItemModelMappable {
  String toJsonString() {
    return OrderItemModelMapper.ensureInitialized().encodeJson<OrderItemModel>(
      this as OrderItemModel,
    );
  }

  Map<String, dynamic> toJson() {
    return OrderItemModelMapper.ensureInitialized().encodeMap<OrderItemModel>(
      this as OrderItemModel,
    );
  }

  OrderItemModelCopyWith<OrderItemModel, OrderItemModel, OrderItemModel>
  get copyWith => _OrderItemModelCopyWithImpl<OrderItemModel, OrderItemModel>(
    this as OrderItemModel,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return OrderItemModelMapper.ensureInitialized().stringifyValue(
      this as OrderItemModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return OrderItemModelMapper.ensureInitialized().equalsValue(
      this as OrderItemModel,
      other,
    );
  }

  @override
  int get hashCode {
    return OrderItemModelMapper.ensureInitialized().hashValue(
      this as OrderItemModel,
    );
  }
}

extension OrderItemModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, OrderItemModel, $Out> {
  OrderItemModelCopyWith<$R, OrderItemModel, $Out> get $asOrderItemModel =>
      $base.as((v, t, t2) => _OrderItemModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class OrderItemModelCopyWith<$R, $In extends OrderItemModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>?>? get options;
  VariantModelCopyWith<$R, VariantModel, VariantModel>? get variant;
  $R call({
    String? itemId,
    String? itemType,
    String? name,
    int? quantity,
    double? unitPrice,
    double? buyingPrice,
    double? totalPrice,
    double? totalBuyingPrice,
    String? notes,
    List<dynamic>? options,
    VariantModel? variant,
  });
  OrderItemModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _OrderItemModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, OrderItemModel, $Out>
    implements OrderItemModelCopyWith<$R, OrderItemModel, $Out> {
  _OrderItemModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<OrderItemModel> $mapper =
      OrderItemModelMapper.ensureInitialized();
  @override
  ListCopyWith<$R, dynamic, ObjectCopyWith<$R, dynamic, dynamic>?>?
  get options => $value.options != null
      ? ListCopyWith(
          $value.options!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(options: v),
        )
      : null;
  @override
  VariantModelCopyWith<$R, VariantModel, VariantModel>? get variant =>
      $value.variant?.copyWith.$chain((v) => call(variant: v));
  @override
  $R call({
    Object? itemId = $none,
    Object? itemType = $none,
    Object? name = $none,
    Object? quantity = $none,
    Object? unitPrice = $none,
    Object? buyingPrice = $none,
    Object? totalPrice = $none,
    Object? totalBuyingPrice = $none,
    Object? notes = $none,
    Object? options = $none,
    Object? variant = $none,
  }) => $apply(
    FieldCopyWithData({
      if (itemId != $none) #itemId: itemId,
      if (itemType != $none) #itemType: itemType,
      if (name != $none) #name: name,
      if (quantity != $none) #quantity: quantity,
      if (unitPrice != $none) #unitPrice: unitPrice,
      if (buyingPrice != $none) #buyingPrice: buyingPrice,
      if (totalPrice != $none) #totalPrice: totalPrice,
      if (totalBuyingPrice != $none) #totalBuyingPrice: totalBuyingPrice,
      if (notes != $none) #notes: notes,
      if (options != $none) #options: options,
      if (variant != $none) #variant: variant,
    }),
  );
  @override
  OrderItemModel $make(CopyWithData data) => OrderItemModel(
    itemId: data.get(#itemId, or: $value.itemId),
    itemType: data.get(#itemType, or: $value.itemType),
    name: data.get(#name, or: $value.name),
    quantity: data.get(#quantity, or: $value.quantity),
    unitPrice: data.get(#unitPrice, or: $value.unitPrice),
    buyingPrice: data.get(#buyingPrice, or: $value.buyingPrice),
    totalPrice: data.get(#totalPrice, or: $value.totalPrice),
    totalBuyingPrice: data.get(#totalBuyingPrice, or: $value.totalBuyingPrice),
    notes: data.get(#notes, or: $value.notes),
    options: data.get(#options, or: $value.options),
    variant: data.get(#variant, or: $value.variant),
  );

  @override
  OrderItemModelCopyWith<$R2, OrderItemModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _OrderItemModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class VariantModelMapper extends ClassMapperBase<VariantModel> {
  VariantModelMapper._();

  static VariantModelMapper? _instance;
  static VariantModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = VariantModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'VariantModel';

  static String? _$id(VariantModel v) => v.id;
  static const Field<VariantModel, String> _f$id = Field(
    'id',
    _$id,
    key: r'_id',
    opt: true,
  );
  static String? _$name(VariantModel v) => v.name;
  static const Field<VariantModel, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );

  @override
  final MappableFields<VariantModel> fields = const {
    #id: _f$id,
    #name: _f$name,
  };

  static VariantModel _instantiate(DecodingData data) {
    return VariantModel(id: data.dec(_f$id), name: data.dec(_f$name));
  }

  @override
  final Function instantiate = _instantiate;

  static VariantModel fromJson(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<VariantModel>(map);
  }

  static VariantModel fromJsonString(String json) {
    return ensureInitialized().decodeJson<VariantModel>(json);
  }
}

mixin VariantModelMappable {
  String toJsonString() {
    return VariantModelMapper.ensureInitialized().encodeJson<VariantModel>(
      this as VariantModel,
    );
  }

  Map<String, dynamic> toJson() {
    return VariantModelMapper.ensureInitialized().encodeMap<VariantModel>(
      this as VariantModel,
    );
  }

  VariantModelCopyWith<VariantModel, VariantModel, VariantModel> get copyWith =>
      _VariantModelCopyWithImpl<VariantModel, VariantModel>(
        this as VariantModel,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return VariantModelMapper.ensureInitialized().stringifyValue(
      this as VariantModel,
    );
  }

  @override
  bool operator ==(Object other) {
    return VariantModelMapper.ensureInitialized().equalsValue(
      this as VariantModel,
      other,
    );
  }

  @override
  int get hashCode {
    return VariantModelMapper.ensureInitialized().hashValue(
      this as VariantModel,
    );
  }
}

extension VariantModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, VariantModel, $Out> {
  VariantModelCopyWith<$R, VariantModel, $Out> get $asVariantModel =>
      $base.as((v, t, t2) => _VariantModelCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class VariantModelCopyWith<$R, $In extends VariantModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? name});
  VariantModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _VariantModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, VariantModel, $Out>
    implements VariantModelCopyWith<$R, VariantModel, $Out> {
  _VariantModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<VariantModel> $mapper =
      VariantModelMapper.ensureInitialized();
  @override
  $R call({Object? id = $none, Object? name = $none}) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (name != $none) #name: name,
    }),
  );
  @override
  VariantModel $make(CopyWithData data) => VariantModel(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
  );

  @override
  VariantModelCopyWith<$R2, VariantModel, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _VariantModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

