class CustomerOrderModel {

  const CustomerOrderModel({
    required this.id,
    required this.displayId,
    required this.shopName,
    required this.createdAt,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.shopCategory,
    this.rating,
    this.sentiment,
    this.foodRating,
    this.foodReview,
    this.riderRating,
    this.riderReview,
  });

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    final shopRaw = json['shopId'];
    final shopName = shopRaw is Map
        ? (shopRaw['name'] as String? ?? 'Unknown')
        : 'Unknown';
    final shopCategory = shopRaw is Map
        ? (_extractCategory(shopRaw['category']) ??
              _extractCategory(shopRaw['shopCategory']))
        : _extractCategory(json['category']);

    final orderId =
        (json['orderId'] as String? ??
                json['orderNumber'] as String? ??
                json['_id'] as String? ??
                '')
            .replaceAll(RegExp(r'^0+'), '');

    return CustomerOrderModel(
      id: json['_id'] as String? ?? '',
      displayId: orderId,
      shopName: shopName,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      total: _toDouble(json['grandTotal'] ?? json['total']) ?? 0,
      status: json['status'] as String? ?? 'pending',
      paymentMethod: json['paymentMethod'] as String? ?? 'cash_on_delivery',
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
      shopCategory: shopCategory,
      rating: json['rating'] as int?,
      sentiment: json['sentiment'] as String?,
      foodRating: json['foodRating'] as int?,
      foodReview: json['foodReview'] as String?,
      riderRating: json['riderRating'] as int?,
      riderReview: json['riderReview'] as String?,
    );
  }

  final String id;
  final String displayId;
  final String shopName;
  final DateTime createdAt;
  final double total;
  final String status;
  final String paymentMethod;
  final String paymentStatus;

  /// Top-level shop category slug (e.g. 'restaurant', 'pharmacy') when the API
  /// populates the shop reference. Used to scope reorder strips per vertical.
  /// Null when the backend doesn't include it.
  final String? shopCategory;

  // Legacy feedback fields
  final int? rating;
  final String? sentiment;

  // Separate feedback fields
  final int? foodRating;
  final String? foodReview;
  final int? riderRating;
  final String? riderReview;

  bool get isReviewed =>
      rating != null || foodRating != null || riderRating != null;

  bool get needsPayment =>
      paymentMethod == 'bkash' &&
      (paymentStatus == 'pending' || paymentStatus == 'failed');

  bool get isActive => const {
    'pending',
    'confirmed',
    'preparing',
    'ready_for_pickup',
    'assigned',
    'picked_up',
    'on_way',
  }.contains(status);
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

/// Safely reads a shop category that may arrive as a plain string, a populated
/// object ({ value, label, _id }), or an ObjectId — never throws on a cast.
String? _extractCategory(dynamic v) {
  if (v == null) return null;
  if (v is String) return v.isEmpty ? null : v;
  if (v is Map) {
    final picked = v['value'] ?? v['label'] ?? v['_id'];
    return picked?.toString();
  }
  return v.toString();
}
