import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/medicine_products_provider.dart';
import 'medicine_product_strip.dart';

/// "Featured Medicines" homepage strip.
class MedicineFeaturedStrip extends ConsumerWidget {
  const MedicineFeaturedStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MedicineProductStrip(
      title: 'Featured Medicines',
      async: ref.watch(medicineFeaturedProvider),
    );
  }
}
