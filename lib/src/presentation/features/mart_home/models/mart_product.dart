import '../../restaurant_detail/models/restaurant_api_models.dart';

/// One embedded item from a Mart shop's `Product.items[]` container
/// (`GET /products/public/shop/:shopId`).
class MartProduct {
  const MartProduct({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.mrp,
    this.images = const [],
    this.itemCategory,
  });

  factory MartProduct.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    return MartProduct(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      price: _toDouble(json['price']) ?? 0,
      description: json['description'] as String?,
      mrp: _toDouble(json['mrp']),
      images: rawImages?.whereType<String>().toList() ?? const [],
      itemCategory: json['itemCategory'] as String?,
    );
  }

  final String id;
  final String name;
  final double price;
  final String? description;
  final double? mrp;
  final List<String> images;
  final String? itemCategory;

  String? get image => images.isNotEmpty ? images.first : null;

  bool get hasDiscount => mrp != null && mrp! > price;

  /// Duare doesn't hold inventory here either — a rider buys the item in
  /// person, so it's always orderable (same call as Medicine).
  ApiMenuItemData toApiMenuItem() {
    return ApiMenuItemData(
      id: id,
      name: name,
      description: description,
      image: image,
      images: images,
      price: price,
      originalPrice: mrp,
      isAvailable: true,
    );
  }
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}
