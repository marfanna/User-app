class CustomerOrderModel {
  const CustomerOrderModel({
    required this.id,
    required this.displayId,
    required this.shopName,
    required this.createdAt,
    required this.total,
    required this.status,
  });

  final String id;
  final String displayId;
  final String shopName;
  final DateTime createdAt;
  final double total;
  final String status;

  bool get isActive => const {
    'pending',
    'confirmed',
    'preparing',
    'ready_for_pickup',
    'assigned',
    'picked_up',
    'on_way',
  }.contains(status);

  factory CustomerOrderModel.fromJson(Map<String, dynamic> json) {
    final shopRaw = json['shopId'];
    final shopName = shopRaw is Map
        ? (shopRaw['name'] as String? ?? 'Unknown')
        : 'Unknown';

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
