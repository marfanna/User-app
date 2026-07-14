import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../medicine_home/widgets/medicine_cart_fab.dart';
import '../../medicine_home/widgets/medicine_filter_chips.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import '../../restaurant_detail/riverpod/restaurant_providers.dart';
import '../models/mart_product.dart';
import '../riverpod/mart_products_provider.dart';
import '../widgets/mart_product_grid_tile.dart';

/// Mart storefront — shop header + product grid for a single shop.
///
/// `Product` has no server-side search/pagination (unlike `MedicineProduct`,
/// built for tens-of-thousands-item pharmacies) — a shop's whole container is
/// fetched once and filtered client-side. Reached via `/mart-shop/:id`.
class MartStorefrontScreen extends ConsumerStatefulWidget {
  const MartStorefrontScreen({super.key, required this.shopId});

  final String shopId;

  @override
  ConsumerState<MartStorefrontScreen> createState() =>
      _MartStorefrontScreenState();
}

class _MartStorefrontScreenState extends ConsumerState<MartStorefrontScreen> {
  List<MartProduct> _items = const [];
  bool _loading = true;
  bool _error = false;
  String? _category;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        'products/public/shop/${widget.shopId}',
      );
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final items = data?['items'] as List<dynamic>?;
      final parsed = (items ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(MartProduct.fromJson)
          .where((p) => p.name.isNotEmpty)
          .toList();
      if (!mounted) return;
      setState(() {
        _items = parsed;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  List<String> get _categories {
    final seen = <String>{};
    final out = <String>[];
    for (final item in _items) {
      final cat = item.itemCategory?.trim();
      if (cat == null || cat.isEmpty || seen.contains(cat.toLowerCase())) {
        continue;
      }
      seen.add(cat.toLowerCase());
      out.add(cat);
    }
    out.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return out;
  }

  List<MartProduct> get _filtered {
    final q = _search.trim().toLowerCase();
    return _items.where((p) {
      final matchesCategory =
          _category == null ||
          p.itemCategory?.trim().toLowerCase() == _category!.toLowerCase();
      final matchesSearch = q.isEmpty || p.name.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    final shopAsync = ref.watch(restaurantDetailProvider(widget.shopId));
    final shopName = shopAsync.value?.name ?? 'Mart';
    final categories = _categories;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: colors.background.surfaceContainerHigh,
      floatingActionButton: const MedicineCartFab(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header(shop: shopAsync.value)),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                dims.padding.p16,
                dims.padding.p16,
                dims.padding.p16,
                dims.padding.p8,
              ),
              sliver: SliverToBoxAdapter(
                child: _SearchField(
                  onChanged: (v) => setState(() => _search = v),
                ),
              ),
            ),
            if (categories.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.only(
                  left: dims.padding.p16,
                  right: dims.padding.p16,
                  bottom: dims.padding.p8,
                ),
                sliver: SliverToBoxAdapter(
                  child: MedicineFilterChips(
                    options: categories,
                    selected: _category,
                    onSelected: (v) => setState(() => _category = v),
                  ),
                ),
              ),
            ..._buildBody(context, shopName, filtered),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody(
    BuildContext context,
    String shopName,
    List<MartProduct> items,
  ) {
    final dims = context.dimensions;

    if (_loading) return const [_GridSkeleton()];
    if (_error) {
      return const [_Message(text: "Couldn't load products")];
    }
    if (items.isEmpty) {
      return [
        _Message(
          text: _search.isNotEmpty || _category != null
              ? 'No products match your filter'
              : 'No products listed yet',
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(
          dims.padding.p16,
          dims.padding.p8,
          dims.padding.p16,
          dims.spacing.s32,
        ),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: dims.spacing.s12,
            crossAxisSpacing: dims.spacing.s12,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => MartProductGridTile(
              item: MartCatalogItem(
                product: items[i],
                shopId: widget.shopId,
                shopName: shopName,
              ),
            ),
            childCount: items.length,
          ),
        ),
      ),
    ];
  }
}

class _Header extends StatelessWidget {
  const _Header({this.shop});

  final RestaurantData? shop;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final banner = shop?.banner ?? shop?.logo;
    final isOpen = shop != null && shop!.isActive && !shop!.isPaused;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(dims.radius.r24),
            bottomRight: Radius.circular(dims.radius.r24),
          ),
          child: Container(
            width: double.infinity,
            height: 180,
            color: colors.background.surfaceContainerHighDim,
            child: banner != null && banner.isNotEmpty
                ? Image.network(
                    banner,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    cacheWidth: 1000,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  )
                : null,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(dims.radius.r24),
                bottomRight: Radius.circular(dims.radius.r24),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.background.transparent,
                  colors.text.primary.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: dims.padding.p8,
          left: dims.padding.p16,
          child: const RoundedBackButton.primary(),
        ),
        Positioned(
          left: dims.padding.p16,
          right: dims.padding.p16,
          bottom: dims.padding.p16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shop?.name ?? 'Mart',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.displaySmall.copyWith(color: colors.text.inverse),
              ),
              Gap(dims.spacing.s8),
              Row(
                children: [
                  _OpenBadge(isOpen: isOpen),
                  if (shop?.rating != null && shop!.rating! > 0) ...[
                    Gap(dims.spacing.s8),
                    Icon(
                      Icons.star,
                      size: dims.size.s16,
                      color: colors.icon.inverse,
                    ),
                    Gap(dims.spacing.s4),
                    Text(
                      shop!.rating!.toStringAsFixed(1),
                      style: text.labelLarge.copyWith(
                        color: colors.text.inverse,
                      ),
                    ),
                  ],
                  if (shop?.addressStr != null &&
                      shop!.addressStr!.isNotEmpty) ...[
                    Gap(dims.spacing.s8),
                    Icon(
                      Icons.location_on_outlined,
                      size: dims.size.s16,
                      color: colors.icon.inverse,
                    ),
                    Gap(dims.spacing.s4),
                    Flexible(
                      child: Text(
                        shop!.addressStr!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall.copyWith(
                          color: colors.text.inverse,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge({required this.isOpen});

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;
    final color =
        isOpen ? colors.success.defaultValue : colors.error.defaultValue;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dims.padding.p8,
        vertical: dims.padding.p4,
      ),
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r64),
      ),
      child: Text(
        isOpen ? 'Open' : 'Closed',
        style: text.labelSmallSemiBold.copyWith(color: color),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final text = context.textStyle;
    final dims = context.dimensions;

    return TextField(
      onChanged: onChanged,
      style: text.bodySmallCompactLoose,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Search in this shop..',
        hintStyle: text.bodySmallCompactLoose.copyWith(
          color: colors.text.secondary,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: colors.icon.secondary,
          size: dims.size.s20,
        ),
        filled: true,
        fillColor: colors.background.surface,
        contentPadding: EdgeInsets.symmetric(vertical: dims.padding.p12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dims.radius.r64),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dims.radius.r64),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(dims.radius.r64),
          borderSide: BorderSide(color: colors.border.focus),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return SliverPadding(
      padding: EdgeInsets.all(dims.padding.p32),
      sliver: SliverToBoxAdapter(
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.shopping_basket_outlined,
                size: dims.size.s48,
                color: colors.icon.secondary,
              ),
              Gap(dims.spacing.s12),
              Text(
                text,
                textAlign: TextAlign.center,
                style: context.textStyle.bodyMedium.copyWith(
                  color: colors.text.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        dims.padding.p16,
        dims.padding.p8,
        dims.padding.p16,
        dims.spacing.s32,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: dims.spacing.s12,
          crossAxisSpacing: dims.spacing.s12,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, _) => Container(
            decoration: BoxDecoration(
              color: colors.background.surface,
              borderRadius: BorderRadius.circular(dims.radius.r12),
            ),
            padding: EdgeInsets.all(dims.padding.p10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.background.surfaceContainerHighDim,
                      borderRadius: BorderRadius.circular(dims.radius.r8),
                    ),
                  ),
                ),
                Gap(dims.spacing.s8),
                Container(
                  width: 110,
                  height: 14,
                  color: colors.background.surfaceContainerHighDim,
                ),
                Gap(dims.spacing.s8),
                Container(
                  width: 60,
                  height: 14,
                  color: colors.background.surfaceContainerHighDim,
                ),
              ],
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}
