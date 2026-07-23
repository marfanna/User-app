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
import '../models/fashion_product.dart';
import '../riverpod/fashion_products_provider.dart';
import '../widgets/fashion_product_grid_tile.dart';

/// Fashion storefront — shop header + product grid for a single shop.
///
/// Whole container fetched once and filtered client-side (no server-side
/// search on `Product`). Reached via `/fashion-shop/:id`. Mirrors
/// `MartStorefrontScreen`.
class FashionStorefrontScreen extends ConsumerStatefulWidget {
  const FashionStorefrontScreen({super.key, required this.shopId});

  final String shopId;

  @override
  ConsumerState<FashionStorefrontScreen> createState() =>
      _FashionStorefrontScreenState();
}

class _FashionStorefrontScreenState
    extends ConsumerState<FashionStorefrontScreen> {
  List<FashionProduct> _items = const [];
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
      final response = await dio.get('products/public/shop/${widget.shopId}');
      final body = response.data as Map<String, dynamic>;
      final data = body['data'] as Map<String, dynamic>?;
      final items = data?['items'] as List<dynamic>?;
      final parsed = (items ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(FashionProduct.fromJson)
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

  List<FashionProduct> get _filtered {
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
    final shopName = shopAsync.value?.name ?? 'Fashion';
    final categories = _categories;
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: colors.background.surface,
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
    List<FashionProduct> items,
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

    final showFeatured =
        _search.isEmpty && _category == null && items.length > 2;

    return [
      if (showFeatured)
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            dims.padding.p16,
            dims.padding.p8,
            dims.padding.p16,
            dims.padding.p16,
          ),
          sliver: SliverToBoxAdapter(
            child: _FeaturedCollection(
              shopName: shopName,
              items: items
                  .take(4)
                  .map(
                    (product) => FashionCatalogItem(
                      product: product,
                      shopId: widget.shopId,
                      shopName: shopName,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
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
            childAspectRatio: 0.58,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => FashionProductGridTile(
              item: FashionCatalogItem(
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
    final logo = shop?.logo;
    final isOpen = shop != null && shop!.isActive && !shop!.isPaused;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(dims.radius.r24),
            bottomRight: Radius.circular(dims.radius.r24),
          ),
          child: Container(
            width: double.infinity,
            height: 260,
            color: colors.background.surfaceContainerHighDim,
            child: banner != null && banner.isNotEmpty
                ? Image.network(
                    banner,
                    width: double.infinity,
                    height: 260,
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
                  colors.text.primary.withValues(alpha: 0.18),
                  colors.text.primary.withValues(alpha: 0.72),
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
          bottom: dims.padding.p20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _LogoMark(logo: logo),
                  Gap(dims.spacing.s12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _OpenBadge(isOpen: isOpen),
                      Gap(dims.spacing.s8),
                      Text(
                        'Boutique storefront',
                        style: text.labelSmallSemiBold.copyWith(
                          color: colors.text.inverse.withValues(alpha: 0.86),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Gap(dims.spacing.s16),
              Text(
                shop?.name ?? 'Fashion',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.displaySmallCompact.copyWith(
                  color: colors.text.inverse,
                  letterSpacing: 0,
                ),
              ),
              Gap(dims.spacing.s8),
              Row(
                children: [
                  if (shop?.rating != null && shop!.rating! > 0) ...[
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
                    if (shop?.rating != null && shop!.rating! > 0)
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

class _LogoMark extends StatelessWidget {
  const _LogoMark({this.logo});

  final String? logo;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      width: dims.size.s56,
      height: dims.size.s56,
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r16),
        border: Border.all(
          color: colors.background.surface.withValues(alpha: 0.34),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: logo != null && logo!.isNotEmpty
          ? Image.network(
              logo!,
              fit: BoxFit.cover,
              cacheWidth: 160,
              errorBuilder: (_, _, _) => _placeholder(context),
            )
          : _placeholder(context),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Icon(
      Icons.storefront_outlined,
      color: context.color.icon.primary,
      size: context.dimensions.size.s28,
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
    final color = isOpen
        ? colors.success.defaultValue
        : colors.error.defaultValue;

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

class _FeaturedCollection extends StatelessWidget {
  const _FeaturedCollection({required this.shopName, required this.items});

  final String shopName;
  final List<FashionCatalogItem> items;

  @override
  Widget build(BuildContext context) {
    final text = context.textStyle;
    final colors = context.color;
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured collection',
          style: text.titleLarge.copyWith(
            color: colors.text.primary,
            letterSpacing: 0,
          ),
        ),
        Gap(dims.spacing.s4),
        Text(
          'Selected pieces from $shopName',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: text.bodySmall.copyWith(color: colors.text.secondary),
        ),
        Gap(dims.spacing.s12),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: items.length,
            separatorBuilder: (_, _) => Gap(dims.spacing.s12),
            itemBuilder: (_, index) => SizedBox(
              width: 284,
              child: FashionWideProductCard(item: items[index]),
            ),
          ),
        ),
      ],
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
                Icons.checkroom_outlined,
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
          childAspectRatio: 0.58,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, _) => Container(
            decoration: BoxDecoration(
              color: colors.background.surface,
              borderRadius: BorderRadius.circular(dims.radius.r12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.background.surfaceContainerHighDim,
                      borderRadius: BorderRadius.circular(dims.radius.r16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(dims.padding.p10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              ],
            ),
          ),
          childCount: 6,
        ),
      ),
    );
  }
}
