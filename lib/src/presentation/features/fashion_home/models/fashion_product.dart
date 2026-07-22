import '../../restaurant_detail/models/restaurant_api_models.dart';

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

/// One exact colour+size combination with its own price, parsed from the
/// backend `Product.items[].variantCombos[]` array (Fashion only).
class FashionVariantCombo {
  const FashionVariantCombo({
    required this.id,
    required this.color,
    required this.size,
    required this.price,
    this.mrp,
  });

  factory FashionVariantCombo.fromJson(Map<String, dynamic> json) {
    return FashionVariantCombo(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      color: (json['color'] ?? '') as String,
      size: (json['size'] ?? '') as String,
      price: _toDouble(json['price']) ?? 0,
      mrp: _toDouble(json['mrp']),
    );
  }

  final String id;
  final String color;
  final String size;
  final double price;
  final double? mrp;

  bool get hasDiscount => mrp != null && mrp! > price;

  /// A cart-line label, e.g. "Red / M". Reused as the synthetic
  /// `MenuItemVariant.name` so checkout/order-history show the exact combo.
  String get label => '$color / $size';
}

/// One embedded item from a Fashion shop's `Product.items[]` container
/// (`GET /products/public/shop/:shopId`). Carries a colour×size combo matrix;
/// `price`/`mrp` are the "from" display values (min across combos).
class FashionProduct {
  const FashionProduct({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.mrp,
    this.images = const [],
    this.itemCategory,
    this.combos = const [],
  });

  factory FashionProduct.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final rawCombos = json['variantCombos'] as List<dynamic>?;
    return FashionProduct(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      price: _toDouble(json['price']) ?? 0,
      description: json['description'] as String?,
      mrp: _toDouble(json['mrp']),
      images: rawImages?.whereType<String>().toList() ?? const [],
      itemCategory: json['itemCategory'] as String?,
      combos: rawCombos
              ?.whereType<Map<String, dynamic>>()
              .map(FashionVariantCombo.fromJson)
              .where((c) => c.color.isNotEmpty && c.size.isNotEmpty)
              .toList() ??
          const [],
    );
  }

  final String id;
  final String name;
  final double price;
  final String? description;
  final double? mrp;
  final List<String> images;
  final String? itemCategory;
  final List<FashionVariantCombo> combos;

  String? get image => images.isNotEmpty ? images.first : null;

  bool get hasDiscount => mrp != null && mrp! > price;

  /// Distinct colours, in first-seen order.
  List<String> get colors {
    final seen = <String>{};
    final out = <String>[];
    for (final c in combos) {
      if (seen.add(c.color)) out.add(c.color);
    }
    return out;
  }

  /// Combos available for a given colour (the sizes you can pick).
  List<FashionVariantCombo> combosForColor(String color) =>
      combos.where((c) => c.color == color).toList();

  /// Builds the shared cart item. Price is the selected combo's price (via
  /// the synthetic variant); the base [price] here is only the "from" value.
  /// A rider fetches the item in person, so it's always orderable.
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
