import 'fashion_product.dart';

/// Navigation payload for the Fashion product detail route.
///
/// `Product` has no single-item fetch endpoint, so the detail screen relies
/// entirely on this payload — no refetch, no cold deep-link support (same as
/// Mart). Carries the full colour×size combo matrix so the picker works.
class FashionProductArgs {
  const FashionProductArgs({
    required this.productId,
    required this.shopId,
    required this.shopName,
    required this.name,
    required this.price,
    this.image,
    this.images = const [],
    this.description,
    this.mrp,
    this.combos = const [],
  });

  factory FashionProductArgs.fromProduct(
    FashionProduct product, {
    required String shopId,
    required String shopName,
  }) {
    return FashionProductArgs(
      productId: product.id,
      shopId: shopId,
      shopName: shopName,
      name: product.name,
      price: product.price,
      image: product.image,
      images: product.images,
      description: product.description,
      mrp: product.mrp,
      combos: product.combos,
    );
  }

  final String productId;
  final String shopId;
  final String shopName;
  final String name;
  final double price;
  final String? image;
  final List<String> images;
  final String? description;
  final double? mrp;
  final List<FashionVariantCombo> combos;
}
