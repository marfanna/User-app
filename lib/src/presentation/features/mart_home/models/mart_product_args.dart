/// Navigation payload for the Mart product detail route.
///
/// `Product` has no single-item fetch endpoint (unlike `MedicineProduct`), so
/// the detail screen relies entirely on this payload — no refetch, no cold
/// deep-link support.
class MartProductArgs {
  const MartProductArgs({
    required this.productId,
    required this.shopId,
    required this.shopName,
    required this.name,
    required this.price,
    this.image,
    this.description,
    this.mrp,
  });

  final String productId;
  final String shopId;
  final String shopName;
  final String name;
  final double price;
  final String? image;
  final String? description;
  final double? mrp;
}
