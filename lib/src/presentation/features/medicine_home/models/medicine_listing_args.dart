/// Navigation payload for the medicine listing route.
///
/// [categoryLabel] is the display label (e.g. "Antibiotic") used both as the
/// screen title and the server `itemCategory` filter — not the homepage slug.
class MedicineListingArgs {
  const MedicineListingArgs({required this.categoryLabel});

  final String categoryLabel;
}
