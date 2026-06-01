class FeaturedItem {
  final String id;
  final String shopId;
  final FeaturedMenuItem item;
  final FeaturedShop shop;

  const FeaturedItem({
    required this.id,
    required this.shopId,
    required this.item,
    required this.shop,
  });

  factory FeaturedItem.fromJson(Map<String, dynamic> json) {
    return FeaturedItem(
      id: json['_id'] as String? ?? '',
      shopId: json['shopId'] as String? ?? '',
      item: FeaturedMenuItem.fromJson(
        json['item'] as Map<String, dynamic>? ?? {},
      ),
      shop: FeaturedShop.fromJson(json['shop'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class FeaturedMenuItem {
  final String id;
  final String name;
  final String? image;
  final num price;

  const FeaturedMenuItem({
    required this.id,
    required this.name,
    this.image,
    required this.price,
  });

  factory FeaturedMenuItem.fromJson(Map<String, dynamic> json) {
    return FeaturedMenuItem(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
      price: json['price'] as num? ?? 0,
    );
  }
}

class FeaturedShop {
  final String id;
  final String name;
  final String? logo;

  const FeaturedShop({required this.id, required this.name, this.logo});

  factory FeaturedShop.fromJson(Map<String, dynamic> json) {
    return FeaturedShop(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String?,
    );
  }
}
