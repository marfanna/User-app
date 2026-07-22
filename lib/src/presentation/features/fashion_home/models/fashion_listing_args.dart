/// Navigation payload for the Fashion listing route — the category label to
/// filter on (matches `itemCategory` exactly, e.g. "Shoes").
class FashionListingArgs {
  const FashionListingArgs({required this.categoryLabel});

  final String categoryLabel;
}
