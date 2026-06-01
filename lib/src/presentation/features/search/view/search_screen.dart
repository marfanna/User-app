import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../home/models/shop_data.dart';
import '../../home/riverpod/restaurants_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ShopData> _filtered(List<ShopData> shops) {
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

  void _onQueryChanged(String value) => setState(() => _query = value);

  void _clearQuery() {
    _controller.clear();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(restaurantsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF040707),
          ),
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
            hintText: 'Search Restaurants..',
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
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(
          child: Text(
            'Failed to load restaurants',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Color(0xFF737780),
            ),
          ),
        ),
        data: (shops) {
          final results = _filtered(shops);
          if (_query.isNotEmpty && results.isEmpty) {
            return _NoResultsView(query: _query);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: results.length,
            separatorBuilder: (_, _) => const Gap(12),
            itemBuilder: (_, i) => _SearchResultTile(
              shop: results[i],
              onTap: () => context.push(
                Routes.restaurantDetailPath(results[i].id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 56,
            color: Color(0xFFCCCCCC),
          ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
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

/// Small square thumbnail: banner → logo → placeholder.
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
    if (!_bannerFailed &&
        widget.banner != null &&
        widget.banner!.isNotEmpty) {
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
