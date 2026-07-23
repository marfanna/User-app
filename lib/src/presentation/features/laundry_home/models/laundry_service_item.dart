import '../../restaurant_detail/models/restaurant_api_models.dart';

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}

class LaundryServiceItem {
  const LaundryServiceItem({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.mrp,
    this.images = const [],
    this.itemCategory,
  });

  factory LaundryServiceItem.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    return LaundryServiceItem(
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
