class ShopCategoryModel {

  const ShopCategoryModel({
    required this.id,
    required this.value,
    required this.label,
    this.icon,
  });

  factory ShopCategoryModel.fromJson(Map<String, dynamic> json) {
    return ShopCategoryModel(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      value: (json['value'] ?? '') as String,
      label: (json['label'] ?? '') as String,
      icon: json['icon'] as String?,
    );
  }

  final String id;
  final String value;
  final String label;
  final String? icon;
}
