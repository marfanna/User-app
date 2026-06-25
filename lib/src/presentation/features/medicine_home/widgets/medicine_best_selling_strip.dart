import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/medicine_products_provider.dart';
import 'medicine_product_strip.dart';

/// "Best Selling" homepage strip.
class MedicineBestSellingStrip extends ConsumerWidget {
  const MedicineBestSellingStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineProductStrip(
      title: 'Best Selling',
      async: ref.watch(medicineBestSellingProvider),
    );
  }
}
