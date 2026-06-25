import '../../restaurant_detail/models/restaurant_api_models.dart';

/// Full medicine product, mirroring the backend `medicineProduct` schema
/// (`GET /medicine-products/:id`). All medical fields are optional strings.
class MedicineProductDetail {
  const MedicineProductDetail({
    required this.id,
    required this.shopId,
    required this.name,
    required this.price,
    this.description,
    this.mrp,
    this.images = const [],
    this.isAvailable = true,
    this.stock,
    this.itemCategory,
    this.companyName,
    this.genericName,
    this.productForm,
    this.strength,
    this.packSize,
    this.indication,
    this.administration,
    this.adultDose,
    this.childDose,
    this.sideEffects,
    this.contraindication,
    this.modeOfAction,
    this.precaution,
    this.interaction,
  });

  factory MedicineProductDetail.fromJson(Map<String, dynamic> json) {
    final rawImages = json['images'] as List<dynamic>?;
    final shopRaw = json['shop'];
    final shopId = shopRaw is Map
        ? (shopRaw['_id'] ?? shopRaw['id'] ?? '') as String
        : (shopRaw as String? ?? '');

    return MedicineProductDetail(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      shopId: shopId,
      name: (json['name'] ?? '') as String,
      price: _toDouble(json['price']) ?? 0,
      description: json['description'] as String?,
      mrp: _toDouble(json['mrp']),
      images: rawImages?.whereType<String>().toList() ?? const [],
      isAvailable: json['isAvailable'] as bool? ?? true,
      stock: _toInt(json['stock']),
      itemCategory: json['itemCategory'] as String?,
      companyName: json['companyName'] as String?,
      genericName: json['genericName'] as String?,
      productForm: json['productForm'] as String?,
      strength: json['strength'] as String?,
      packSize: json['packSize'] as String?,
      indication: json['indication'] as String?,
      administration: json['administration'] as String?,
      adultDose: json['adultDose'] as String?,
      childDose: json['childDose'] as String?,
      sideEffects: json['sideEffects'] as String?,
      contraindication: json['contraindication'] as String?,
      modeOfAction: json['modeOfAction'] as String?,
      precaution: json['precaution'] as String?,
      interaction: json['interaction'] as String?,
    );
  }

  final String id;
  final String shopId;
  final String name;
  final double price;
  final String? description;
  final double? mrp;
  final List<String> images;
  final bool isAvailable;
  final int? stock;
  final String? itemCategory;
  final String? companyName;
  final String? genericName;
  final String? productForm;
  final String? strength;
  final String? packSize;
  final String? indication;
  final String? administration;
  final String? adultDose;
  final String? childDose;
  final String? sideEffects;
  final String? contraindication;
  final String? modeOfAction;
  final String? precaution;
  final String? interaction;

  String? get image => images.isNotEmpty ? images.first : null;

  // Treat medicines as orderable unless stock is explicitly 0. The
  // `isAvailable` flag is intentionally NOT gated here — current seed data
  // marks everything unavailable, and the owner wants those shown + orderable.
  bool get inStock => stock == null || stock! > 0;

  bool get hasDiscount => mrp != null && mrp! > price;

  /// Quick spec chips shown under the title (only the populated ones).
  List<({String label, String value})> get specs {
    final out = <({String label, String value})>[];
    void add(String label, String? value) {
      if (value != null && value.trim().isNotEmpty) {
        out.add((label: label, value: value.trim()));
      }
    }

    add('Strength', strength);
    add('Form', productForm);
    add('Pack', packSize);
    return out;
  }

  /// Long-form medical sections (label → body), populated only.
  List<({String label, String body})> get medicalInfo {
    final out = <({String label, String body})>[];
    void add(String label, String? body) {
      if (body != null && body.trim().isNotEmpty) {
        out.add((label: label, body: body.trim()));
      }
    }

    add('Indication', indication);
    add('Mode of Action', modeOfAction);
    add('Administration', administration);
    add('Adult Dose', adultDose);
    add('Child Dose', childDose);
    add('Side Effects', sideEffects);
    add('Contraindication', contraindication);
    add('Precaution', precaution);
    add('Interaction', interaction);
    return out;
  }

  /// Adapts to the shared cart item shape (no variants/options for medicines).
  ApiMenuItemData toApiMenuItem() {
    return ApiMenuItemData(
      id: id,
      name: name,
      description: description,
      image: image,
      images: images,
      price: price,
      originalPrice: mrp,
      isAvailable: inStock,
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

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}
