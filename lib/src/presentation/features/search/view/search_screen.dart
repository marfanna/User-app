import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/services/cache/cache_service.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/router/routes.dart';
import '../../home/models/shop_data.dart';
import '../../home/riverpod/restaurants_provider.dart';

// ── Product search result ──────────────────────────────────────────────────

class _ProductResult {
  const _ProductResult({
    required this.id,
    required this.name,
    required this.price,
    required this.shopId,
    required this.shopName,
    this.image,
    this.shopLogo,
  });

  factory _ProductResult.fromJson(Map<String, dynamic> json) {
    return _ProductResult(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      shopId: json['shopId'] as String? ?? '',
      shopName: json['shopName'] as String? ?? '',
      image: json['image'] as String?,
      shopLogo: json['shopLogo'] as String?,
    );
  }

  final String id;
  final String name;
  final double price;
  final String shopId;
  final String shopName;
  final String? image;
  final String? shopLogo;
}

// ── Screen ─────────────────────────────────────────────────────────────────

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  List<_ProductResult> _products = [];
  bool _loadingProducts = false;
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<ShopData> _filteredShops(List<ShopData> shops) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return shops;
    return shops
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              (s.area?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
    _debounce?.cancel();
    if (value.trim().length < 2) {
      setState(() => _products = []);
      return;
    }
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _searchProducts(value.trim()),
    );
  }

  Future<void> _searchProducts(String q) async {
    final cache = ref.read(cacheServiceProvider);
    final franchiseId = cache.get<String>(CacheKey.selectedFranchiseId);
    if (franchiseId == null || franchiseId.isEmpty) return;

    setState(() => _loadingProducts = true);
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get(
        'menu/public/search',
        queryParameters: {'q': q, 'franchiseId': franchiseId, 'limit': '20'},
      );
      final body = response.data;
      List<dynamic> raw = [];
      if (body is List) {
        raw = body;
      } else if (body is Map) {
        final data = body['data'];
        if (data is List) raw = data;
      }
      if (mounted) {
        setState(() {
          _products = raw
              .whereType<Map<String, dynamic>>()
              .map(_ProductResult.fromJson)
              .toList();
        });
      }
    } catch (_) {
      if (mounted) setState(() => _products = []);
    } finally {
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  void _clearQuery() {
    _controller.clear();
    _debounce?.cancel();
    setState(() {
      _query = '';
      _products = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopsAsync = ref.watch(restaurantsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF040707)),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onQueryChanged,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Color(0xFF040707),
          ),
          decoration: InputDecoration(
            hintText: 'Search shops & products..',
            hintStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF737780),
            ),
            border: InputBorder.none,
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: Color(0xFF898989),
                    ),
                    onPressed: _clearQuery,
                  )
                : null,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: shopsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text(
            'Failed to load',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Color(0xFF737780),
            ),
          ),
        ),
        data: (shops) {
          final filteredShops = _filteredShops(shops);
          final q = _query.trim();

          if (q.isEmpty) {
            return const _EmptyQueryHint();
          }

          final hasShops = filteredShops.isNotEmpty;
          final hasProducts = _products.isNotEmpty;
          final loading = _loadingProducts;

          if (!hasShops && !hasProducts && !loading) {
            return _NoResultsView(query: q);
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            children: [
              if (hasShops) ...[
                _SectionHeader(label: 'Shops', count: filteredShops.length),
                const Gap(8),
                ...filteredShops.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SearchResultTile(
                      shop: s,
                      onTap: () => context.push(
                        Routes.restaurantDetailPath(s.id),
                      ),
                    ),
                  ),
                ),
              ],
              if (hasProducts || loading) ...[
                if (hasShops) const Gap(8),
                _SectionHeader(
                  label: 'Products',
                  count: hasProducts ? _products.length : null,
                  loading: loading,
                ),
                const Gap(8),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  ...(_products.map(
                    (p) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ProductResultTile(
                        product: p,
                        onTap: () => context.push(
                          Routes.restaurantDetailPath(p.shopId),
                        ),
                      ),
                    ),
                  )),
              ],
            ],
          );
        },
      ),
    );
  }
}

// ── Section header ─────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.label,
    this.count,
    this.loading = false,
  });

  final String label;
  final int? count;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Color(0xFF040707),
          ),
        ),
        if (count != null && !loading) ...[
          const Gap(6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE6EFFC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Color(0xFF0156A7),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Empty query hint ───────────────────────────────────────────────────────

class _EmptyQueryHint extends StatelessWidget {
  const _EmptyQueryHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 56, color: Color(0xFFCCCCCC)),
          Gap(12),
          Text(
            'Search for shops or menu items',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF737780),
            ),
          ),
        ],
      ),
    );
  }
}

// ── No results ─────────────────────────────────────────────────────────────

class _NoResultsView extends StatelessWidget {
  const _NoResultsView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 56, color: Color(0xFFCCCCCC)),
          const Gap(16),
          Text(
            'No results for "$query"',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF737780),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shop result tile ───────────────────────────────────────────────────────

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.shop, required this.onTap});

  final ShopData shop;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _ShopThumb(logo: shop.logo, banner: shop.banner),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF040707),
                    ),
                  ),
                  if (shop.area != null) ...[
                    const Gap(4),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF646464),
                        ),
                        const Gap(4),
                        Text(
                          shop.area!,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xFF646464),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (!shop.isOpen)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Closed',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Color(0xFF737780),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Product result tile ────────────────────────────────────────────────────

class _ProductResultTile extends StatelessWidget {
  const _ProductResultTile({required this.product, required this.onTap});

  final _ProductResult product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _ImageThumb(url: product.image ?? product.shopLogo),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Color(0xFF040707),
                    ),
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_outlined,
                        size: 13,
                        color: Color(0xFF646464),
                      ),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          product.shopName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Color(0xFF646464),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(8),
            Text(
              '৳${product.price.toStringAsFixed(0)}',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF0156A7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared image thumbnail ─────────────────────────────────────────────────

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      color: const Color(0xFFE0E0E0),
      child: url != null && url!.isNotEmpty
          ? Image.network(
              url!,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.fastfood_outlined,
                color: Colors.white,
                size: 28,
              ),
            )
          : const Icon(Icons.fastfood_outlined, color: Colors.white, size: 28),
    );
  }
}

// ── Shop thumbnail (banner → logo → placeholder) ───────────────────────────

class _ShopThumb extends StatefulWidget {
  const _ShopThumb({this.logo, this.banner});

  final String? logo;
  final String? banner;

  @override
  State<_ShopThumb> createState() => _ShopThumbState();
}

class _ShopThumbState extends State<_ShopThumb> {
  bool _bannerFailed = false;

  String? get _url {
    if (!_bannerFailed && widget.banner != null && widget.banner!.isNotEmpty) {
      return widget.banner;
    }
    if (widget.logo != null && widget.logo!.isNotEmpty) return widget.logo;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final url = _url;
    return Container(
      width: 64,
      height: 64,
      color: const Color(0xFFE0E0E0),
      child: url != null
          ? Image.network(
              url,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                _tryFallback();
                return Container(color: const Color(0xFFE0E0E0));
              },
            )
          : const SizedBox.shrink(),
    );
  }

  void _tryFallback() {
    if (_bannerFailed) return;
    if (widget.logo == null || widget.logo!.isEmpty) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _bannerFailed = true);
    });
  }
}
