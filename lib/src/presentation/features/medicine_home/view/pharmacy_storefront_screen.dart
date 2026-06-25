import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../restaurant_detail/models/restaurant_api_models.dart';
import '../../restaurant_detail/riverpod/restaurant_providers.dart';
import '../models/medicine_product_detail.dart';
import '../riverpod/pharmacy_storefront_provider.dart';
import '../widgets/medicine_cart_fab.dart';
import '../widgets/medicine_filter_chips.dart';
import '../widgets/medicine_product_grid_tile.dart';

/// Pharmacy storefront — shop header + server-filtered, paginated product grid.
/// Category + search filtering and paging all happen on the server (a pharmacy
/// can hold tens of thousands of products). Reached via `/pharmacy/:id`.
class PharmacyStorefrontScreen extends ConsumerStatefulWidget {
  const PharmacyStorefrontScreen({super.key, required this.shopId});

  final String shopId;

  @override
  ConsumerState<PharmacyStorefrontScreen> createState() =>
      _PharmacyStorefrontScreenState();
}

class _PharmacyStorefrontScreenState
    extends ConsumerState<PharmacyStorefrontScreen> {
  final _scroll = ScrollController();
  Timer? _searchDebounce;

  List<MedicineProductDetail> _items = const [];
  int _page = 0;
  int _totalPages = 1;
  bool _loading = true;
  bool _loadingMore = false;
  bool _error = false;
  String? _category;
  String _search = '';
  int _reqToken = 0; // guards against out-of-order responses

  bool get _hasMore => _page < _totalPages;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _fetch(reset: true);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >=
            _scroll.position.maxScrollExtent - 400 &&
        _hasMore &&
        !_loading &&
        !_loadingMore) {
      _fetch(reset: false);
    }
  }

  Future<void> _fetch({required bool reset}) async {
    if (reset) {
      setState(() {
        _loading = true;
        _error = false;
      });
    } else {
      if (_loadingMore || !_hasMore) return;
      setState(() => _loadingMore = true);
    }

    final token = ++_reqToken;
    final nextPage = reset ? 1 : _page + 1;
    try {
      final res = await fetchPharmacyProducts(
        dio: ref.read(dioProvider),
        shopId: widget.shopId,
        page: nextPage,
        category: _category,
        search: _search,
      );
      if (!mounted || token != _reqToken) return;
      setState(() {
        _items = reset ? res.items : [..._items, ...res.items];
        _page = nextPage;
        _totalPages = res.totalPages;
        _loading = false;
        _loadingMore = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted || token != _reqToken) return;
      setState(() {
        _loading = false;
        _loadingMore = false;
        if (reset) _error = true;
      });
    }
  }

  void _onCategory(String? category) {
    if (category == _category) return;
    setState(() => _category = category);
    _fetch(reset: true);
  }

  void _onSearch(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (value == _search) return;
      setState(() => _search = value);
      _fetch(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    final shopAsync = ref.watch(restaurantDetailProvider(widget.shopId));
    final categoriesAsync = ref.watch(
      pharmacyProductCategoriesProvider(widget.shopId),
    );

    final shopName = shopAsync.value?.name ?? 'Pharmacy';
    final categories = categoriesAsync.value ?? const <String>[];

    return Scaffold(
      backgroundColor: colors.background.surfaceContainerHigh,
      floatingActionButton: const MedicineCartFab(),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          controller: _scroll,
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
                child: _SearchField(onChanged: _onSearch),
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
                    onSelected: _onCategory,
                  ),
                ),
              ),
            ..._buildBody(context, shopName),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody(BuildContext context, String shopName) {
    final dims = context.dimensions;

    if (_loading) return const [_GridSkeleton()];
    if (_error) {
      return const [_Message(text: "Couldn't load products")];
    }
    if (_items.isEmpty) {
      return [
        _Message(
          text: _search.isNotEmpty || _category != null
              ? 'No medicines match your filter'
              : 'No medicines listed yet',
        ),
      ];
    }

    return [
      SliverPadding(
        padding: EdgeInsets.fromLTRB(
          dims.padding.p16,
          dims.padding.p8,
          dims.padding.p16,
          dims.padding.p8,
        ),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: dims.spacing.s12,
            crossAxisSpacing: dims.spacing.s12,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => MedicineProductGridTile(
              product: _items[i],
              shopName: shopName,
            ),
            childCount: _items.length,
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: dims.spacing.s32,
            top: dims.spacing.s8,
          ),
          child: Center(
            child: _loadingMore
                ? const _Spinner()
                : (!_hasMore
                      ? Text(
                          'That\'s everything',
                          style: context.textStyle.labelSmall.copyWith(
                            color: context.color.text.secondary,
                          ),
                        )
                      : const SizedBox.shrink()),
          ),
        ),
      ),
    ];
  }
}

class _Spinner extends StatelessWidget {
  const _Spinner();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.dimensions.size.s24,
      height: context.dimensions.size.s24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: context.color.brand.primary,
      ),
    );
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
                shop?.name ?? 'Pharmacy',
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
        hintText: 'Search in this pharmacy..',
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
                Icons.medication_outlined,
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
