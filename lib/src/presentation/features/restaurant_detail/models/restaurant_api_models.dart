import '../../../core/models/menu_item.dart';

// ── Helpers ────────────────────────────────────────────────────────────────

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

MenuItem menuItemFromApi(ApiMenuItemData item, {int? rank}) {
  return MenuItem(
    id: item.id,
    name: item.name,
    price: '৳${item.price.toStringAsFixed(0)}',
    imageUrl: item.image ?? '',
    rank: rank,
    likes: item.likeCount,
    dislikes: item.dislikeCount,
    description: item.description,
    isAvailable: item.isAvailable,
  );
}

// ── Models ─────────────────────────────────────────────────────────────────

class RestaurantData {

  const RestaurantData({
    required this.id,
    required this.name,
    this.description,
    this.logo,
    this.banner,
    this.rating,
    this.reviewCount,
    this.deliveryTime,
    this.distance,
    this.addressStr,
    this.isPaused = false,
    this.isActive = true,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>?;
    final analytics = json['analytics'] as Map<String, dynamic>?;
    final emergency = json['emergencyPause'] as Map<String, dynamic>?;
    final catSettings =
        json['categorySpecificSettings'] as Map<String, dynamic>?;
    final restaurantSettings =
        catSettings?['restaurant'] as Map<String, dynamic>?;

    final rawAddress = json['address'];
    String? addressStr;
    if (rawAddress is String && rawAddress.isNotEmpty) {
      addressStr = rawAddress;
    } else if (rawAddress is Map) {
      final parts = [
        rawAddress['area'],
        rawAddress['street'],
        rawAddress['city'],
      ].whereType<String>().where((s) => s.isNotEmpty).toList();
      addressStr = parts.isNotEmpty ? parts.first : null;
    }

    final prepTime = restaurantSettings?['averagePreparationTime'];
    String? deliveryTime = json['deliveryTime'] as String?;
    if ((deliveryTime == null || deliveryTime.isEmpty) && prepTime != null) {
      deliveryTime = '$prepTime min';
    }

    return RestaurantData(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
      logo: images?['logo'] as String? ?? json['logo'] as String?,
      banner:
          images?['banner'] as String? ??
          json['coverImage'] as String? ??
          json['image'] as String?,
      rating: _toDouble(analytics?['averageRating'] ?? json['rating']),
      reviewCount: _toInt(analytics?['totalReviews'] ?? json['reviewCount']),
      deliveryTime: deliveryTime,
      distance: json['distance'] as String?,
      addressStr: addressStr,
      isPaused: emergency?['isPaused'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  final String id;
  final String name;
  final String? description;
  final String? logo;
  final String? banner;
  final double? rating;
  final int? reviewCount;
  final String? deliveryTime;
  final String? distance;
  final String? addressStr;
  final bool isPaused;
  final bool isActive;
}

class MenuData {

  const MenuData({required this.categories});

  factory MenuData.fromJson(Map<String, dynamic> json) {
    final rawCats = json['categories'] as List<dynamic>? ?? [];
    return MenuData(
      categories: rawCats
          .whereType<Map<String, dynamic>>()
          .map(MenuCategoryData.fromJson)
          .where((c) => c.items.isNotEmpty)
          .toList(),
    );
  }

  final List<MenuCategoryData> categories;

  List<MenuItem> get popularItems {
    final popular = categories
        .expand((c) => c.items)
        .where((i) => i.isPopular && i.isAvailable)
        .take(8)
        .toList();
    final source = popular.isNotEmpty
        ? popular
        : categories
              .expand((c) => c.items)
              .where((i) => i.isAvailable)
              .take(8)
              .toList();
    return source
        .asMap()
        .entries
        .map((e) => menuItemFromApi(e.value, rank: e.key + 1))
        .toList();
  }

  List<MenuItem> get mostOrderedItems {
    final allAvailable = categories.expand((c) => c.items).where((i) => i.isAvailable).toList();
    final withOrders = allAvailable.where((i) => i.orderCount > 0).toList()
      ..sort((a, b) => b.orderCount.compareTo(a.orderCount));
    final popular = allAvailable.where((i) => i.isPopular).toList();
    final source = withOrders.isNotEmpty
        ? withOrders.take(6).toList()
        : popular.isNotEmpty
            ? popular.take(6).toList()
            : allAvailable.take(6).toList();
    return source.map((i) => menuItemFromApi(i)).toList();
  }
}

class MenuCategoryData {

  const MenuCategoryData({
    required this.id,
    required this.name,
    required this.items,
  });

  factory MenuCategoryData.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return MenuCategoryData(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(ApiMenuItemData.fromJson)
          .toList(),
    );
  }

  final String id;
  final String name;
  final List<ApiMenuItemData> items;

  List<MenuItem> get displayItems =>
      items.where((i) => i.isAvailable).map((i) => menuItemFromApi(i)).toList();
}

class MenuItemVariant {

  const MenuItemVariant({
    required this.id,
    required this.name,
    required this.price,
    this.isDefault = false,
  });

  factory MenuItemVariant.fromJson(Map<String, dynamic> json) {
    return MenuItemVariant(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      price: _toDouble(json['price']) ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final double price;
  final bool isDefault;
}

class MenuOptionChoice {

  const MenuOptionChoice({
    required this.id,
    required this.name,
    required this.price,
    this.isDefault = false,
  });

  factory MenuOptionChoice.fromJson(Map<String, dynamic> json) {
    return MenuOptionChoice(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      price: _toDouble(json['price']) ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final double price;
  final bool isDefault;
}

class MenuItemOption {

  const MenuItemOption({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    required this.choices,
  });

  factory MenuItemOption.fromJson(Map<String, dynamic> json) {
    final rawChoices = json['choices'] as List<dynamic>? ?? [];
    return MenuItemOption(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      type: (json['type'] ?? 'radio') as String,
      required: json['required'] as bool? ?? false,
      choices: rawChoices
          .whereType<Map<String, dynamic>>()
          .map(MenuOptionChoice.fromJson)
          .toList(),
    );
  }

  final String id;
  final String name;
  final String type; // 'radio' | 'checkbox'
  final bool required;
  final List<MenuOptionChoice> choices;
}

class ApiMenuItemData {

  const ApiMenuItemData({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.images = const [],
    required this.price,
    this.originalPrice,
    this.isAvailable = true,
    this.isPopular = false,
    this.likeCount = 0,
    this.dislikeCount = 0,
    this.orderCount = 0,
    this.variants = const [],
    this.options = const [],
    this.preparationTime,
    this.calories,
    this.dietaryInfo = const [],
    this.allergens = const [],
  });

  factory ApiMenuItemData.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final imageUrls = rawImages?.whereType<String>().toList() ?? [];
    final firstImage = imageUrls.isNotEmpty ? imageUrls.first : null;

    final rawVariants = json['variants'] as List<dynamic>? ?? [];
    final rawOptions = json['options'] as List<dynamic>? ?? [];

    final rawDietary = json['dietaryInfo'] as List<dynamic>?;
    final rawAllergens = json['allergens'] as List<dynamic>?;

    return ApiMenuItemData(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      description: json['description'] as String?,
      image: firstImage ?? json['image'] as String?,
      images: imageUrls,
      price: _toDouble(json['price']) ?? 0,
      originalPrice: _toDouble(json['originalPrice']),
      isAvailable: json['isAvailable'] as bool? ?? true,
      isPopular: json['isPopular'] as bool? ?? false,
      likeCount: _toInt(json['likeCount']) ?? 0,
      dislikeCount: _toInt(json['dislikeCount']) ?? 0,
      orderCount: _toInt(json['orderCount']) ?? 0,
      variants: rawVariants
          .whereType<Map<String, dynamic>>()
          .map(MenuItemVariant.fromJson)
          .toList(),
      options: rawOptions
          .whereType<Map<String, dynamic>>()
          .map(MenuItemOption.fromJson)
          .toList(),
      preparationTime: _toInt(json['preparationTime']),
      calories: _toInt(json['calories']),
      dietaryInfo: rawDietary?.whereType<String>().toList() ?? [],
      allergens: rawAllergens?.whereType<String>().toList() ?? [],
    );
  }

  final String id;
  final String name;
  final String? description;
  final String? image;
  final List<String> images;
  final double price;
  final double? originalPrice;
  final bool isAvailable;
  final bool isPopular;
  final int likeCount;
  final int dislikeCount;
  final int orderCount;
  final List<MenuItemVariant> variants;
  final List<MenuItemOption> options;
  final int? preparationTime;
  final int? calories;
  final List<String> dietaryInfo;
  final List<String> allergens;
}
