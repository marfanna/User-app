import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../home/models/shop_category_model.dart';

/// Resolves the top-level pharmacy shop-category *value* dynamically.
///
/// We never hardcode the medicine category slug. Instead we read the active
/// shop categories (`shop-category/active`) and match the one whose value or
/// label refers to medicine / pharmacy. The resolved value is what gets sent
/// to the shops API as `category=` — mirroring how the food screen uses
/// `selectedCategoryProvider` ('restaurant').
final medicinePharmacyCategoryProvider = FutureProvider.autoDispose<String>((
  ref,
) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get('shop-category/active');

  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  final list = raw is List ? raw : const [];

  final categories = list
      .whereType<Map<String, dynamic>>()
      .map(ShopCategoryModel.fromJson)
      .toList();

  bool isMedicine(ShopCategoryModel c) {
    final haystack = '${c.value} ${c.label}'.toLowerCase();
    return haystack.contains('medicine') ||
        haystack.contains('pharmac') || // pharmacy / pharmaceutical
        haystack.contains('pharma');
  }

  final match = categories.where(isMedicine).toList();
  if (match.isNotEmpty) return match.first.value;

  // Fallback to the documented DB category value. `get-all-shops` aliases
  // pharmacy↔medicine and matches case-insensitively on label/value, so this
  // resolves even if `shop-category/active` didn't surface the medicine row.
  return 'medicine';
});

/// Currently selected medicine sub-category slug (e.g. 'antibiotic').
///
/// `null` means no filter — the homepage shows everything. Selecting a tile
/// on the category grid sets this; downstream product strips can react.
class SelectedMedicineSubCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? value) => state = value;

  void clear() => state = null;
}

final selectedMedicineSubCategoryProvider =
    NotifierProvider<SelectedMedicineSubCategoryNotifier, String?>(
      SelectedMedicineSubCategoryNotifier.new,
    );
