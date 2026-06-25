/// Navigation payload for the medicine product detail route.
///
/// The product is fetched by [productId]; [shopName] is carried here because
/// `GET /medicine-products/:id` returns `shop` as a bare id (no name), and the
/// cart needs a display shop name. The optional fields let the screen paint a
/// header instantly while the full product loads.
class MedicineProductArgs {
  const MedicineProductArgs({
    required this.productId,
    required this.shopId,
    required this.shopName,
    this.name,
    this.image,
    this.price,
  });

  final String productId;
  final String shopId;
  final String shopName;
  final String? name;
  final String? image;
  final double? price;
}
