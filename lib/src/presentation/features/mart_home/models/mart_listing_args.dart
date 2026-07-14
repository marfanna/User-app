/// Navigation payload for the Mart listing route — the category label to
/// filter on (matches `itemCategory` exactly, e.g. "Fish & Meat").
class MartListingArgs {
  const MartListingArgs({required this.categoryLabel});

  final String categoryLabel;
}
