import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/models/menu_item.dart';
import '../../../core/widgets/cards/featured_item_card.dart';
import '../../../core/widgets/cards/food_grid_tile.dart';
import '../../../core/widgets/cards/menu_list_item.dart';
import '../../../core/widgets/rounded_back_button.dart';
import '../../../core/widgets/text/section_header.dart';
import '../models/restaurant_api_models.dart';
import '../riverpod/restaurant_providers.dart';
import '../../add_food/view/add_food_screen.dart';

/// One row in the flat, lazily-built menu list. [tab] is the tab index this
/// row belongs to (-1 = chrome like the header block / loader / trailer).
class _MenuRow {
  _MenuRow({required this.tab, required this.builder});
  final int tab;
  final WidgetBuilder builder;
}

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  const RestaurantDetailScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  // ── UI State ──────────────────────────────────────────────────
  bool _isFavourite = false;
  bool _isDelivery = true;
  // ValueNotifier (not setState): scrolling updates the active tab highlight
  // without rebuilding the whole screen + menu tree on every scroll tick.
  final ValueNotifier<int> _selectedTab = ValueNotifier<int>(0);
  // Tab bar pins in once the header block scrolls out of view.
  final ValueNotifier<bool> _showTabBar = ValueNotifier<bool>(false);
  int _featuredPage = 0;
  String _searchQuery = '';

  // ── Lazy list plumbing ────────────────────────────────────────
  final ItemScrollController _itemScrollCtrl = ItemScrollController();
  final ItemPositionsListener _posListener = ItemPositionsListener.create();
  // Rebuilt every build(): row index → owning tab index, and tab → first row.
  List<int> _rowTabs = const [];
  Map<int, int> _tabStart = const {};

  // ── Controllers ───────────────────────────────────────────────
  late final PageController _featuredPageCtrl;
  late final TextEditingController _searchCtrl;

  // ── Cached menu for add-to-cart lookup ────────────────────────
  MenuData? _cachedMenu;
  String _cachedShopName = '';
  final Map<String, ApiMenuItemData> _rawItems = {};

  // ── Shop map ──────────────────────────────────────────────────
  double? _shopLat;
  double? _shopLng;
  bool _geocoding = false;
  GoogleMapController? _shopMapController;
  final _geocodingDio = Dio();

  @override
  void initState() {
    super.initState();
    _featuredPageCtrl = PageController(viewportFraction: 0.85);
    _searchCtrl = TextEditingController();
    _posListener.itemPositions.addListener(_onPositions);
  }

  @override
  void dispose() {
    _posListener.itemPositions.removeListener(_onPositions);
    _selectedTab.dispose();
    _showTabBar.dispose();
    _featuredPageCtrl.dispose();
    _searchCtrl.dispose();
    _geocodingDio.close();
    _shopMapController?.dispose();
    super.dispose();
  }

  Future<void> _ensureShopCoords(String address) async {
    if (_shopLat != null || _geocoding || address.isEmpty) return;
    setState(() => _geocoding = true);
    try {
      final response = await _geocodingDio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'key': 'AIzaSyBU7GqUxT98kSlVbD0iFMijQOQFZUbgA7Q',
          'components': 'country:BD',
        },
      );
      final results = response.data['results'] as List?;
      if (results != null && results.isNotEmpty && mounted) {
        final loc = results.first['geometry']['location'];
        setState(() {
          _shopLat = (loc['lat'] as num).toDouble();
          _shopLng = (loc['lng'] as num).toDouble();
        });
      }
    } catch (_) {
      // geocoding failed — map stays unavailable
    } finally {
      if (mounted) setState(() => _geocoding = false);
    }
  }

  List<String> _buildTabs(MenuData menu) => [
    'Featured Items',
    'Most Ordered',
    ...menu.categories.map((c) => c.name),
  ];

  // Active-tab detection: the deepest section whose top edge has crossed just
  // below the pinned tab bar becomes the selected tab. Also toggles the tab
  // bar once the header block (row 0) scrolls away. Runs off the position
  // listener — no setState, so it never rebuilds the menu while scrolling.
  void _onPositions() {
    final positions = _posListener.itemPositions.value;
    if (positions.isEmpty) return;

    final header = positions.where((p) => p.index == 0);
    final showBar = header.isEmpty || header.first.itemTrailingEdge <= 0.06;
    if (_showTabBar.value != showBar) _showTabBar.value = showBar;

    int? tab;
    int best = -1;
    for (final p in positions) {
      if (p.index >= _rowTabs.length) continue;
      final t = _rowTabs[p.index];
      if (t < 0) continue;
      if (p.itemLeadingEdge <= 0.18 && p.index > best) {
        best = p.index;
        tab = t;
      }
    }
    if (tab != null && _selectedTab.value != tab) _selectedTab.value = tab;
  }

  void _onTabTapped(int index) {
    _selectedTab.value = index;
    final target = _tabStart[index];
    if (target != null && _itemScrollCtrl.isAttached) {
      _itemScrollCtrl.scrollTo(
        index: target,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  List<MenuItem> _filtered(List<MenuItem> items) {
    if (_searchQuery.isEmpty) return items;
    final q = _searchQuery.toLowerCase();
    return items
        .where(
          (i) =>
              i.name.toLowerCase().contains(q) ||
              (i.description?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  void _openAddFood(MenuItem item) {
    final raw = _rawItems[item.id];
    final apiItem =
        raw ??
        ApiMenuItemData(
          id: item.id ?? '',
          name: item.name,
          price:
              double.tryParse(item.price.replaceAll(RegExp(r'[^\d.]'), '')) ??
              0,
          image: item.imageUrl.isNotEmpty ? item.imageUrl : null,
          description: item.description,
        );
    context.push(
      Routes.addFood,
      extra: AddFoodArgs(
        item: apiItem,
        shopName: _cachedShopName,
        shopId: widget.restaurantId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurantAsync = ref.watch(
      restaurantDetailProvider(widget.restaurantId),
    );
    final menuAsync = ref.watch(restaurantMenuProvider(widget.restaurantId));

    restaurantAsync.whenData((r) {
      if (_cachedShopName != r.name) _cachedShopName = r.name;
    });

    menuAsync.whenData((menu) {
      if (_cachedMenu != menu) {
        for (final cat in menu.categories) {
          for (final item in cat.items) {
            _rawItems[item.id] = item;
          }
        }
        _cachedMenu = menu;
      }
    });

    final tabs =
        menuAsync.whenOrNull(data: _buildTabs) ??
        ['Featured Items', 'Most Ordered'];

    // Build the flat row list (+ tab→row map) for the current menu/search.
    final List<_MenuRow> rows;
    final Map<int, int> tabStart;
    (rows, tabStart) = menuAsync.when(
      data: (menu) => _buildRows(menu, restaurantAsync),
      loading: () => (
        [
          _MenuRow(tab: -1, builder: (_) => _buildHeaderBlock(restaurantAsync)),
          _MenuRow(tab: -1, builder: (_) => _statusRow(loading: true)),
        ],
        <int, int>{},
      ),
      error: (_, _) => (
        [
          _MenuRow(tab: -1, builder: (_) => _buildHeaderBlock(restaurantAsync)),
          _MenuRow(tab: -1, builder: (_) => _statusRow(loading: false)),
        ],
        <int, int>{},
      ),
    );
    _rowTabs = rows.map((r) => r.tab).toList();
    _tabStart = tabStart;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Sticky tab bar — only shown once the header has scrolled away.
          ValueListenableBuilder<bool>(
            valueListenable: _showTabBar,
            builder: (_, show, _) {
              if (!show || !menuAsync.hasValue) return const SizedBox.shrink();
              return _buildTabBar(menuAsync.value!, tabs);
            },
          ),
          Expanded(
            child: ScrollablePositionedList.builder(
              itemScrollController: _itemScrollCtrl,
              itemPositionsListener: _posListener,
              itemCount: rows.length,
              itemBuilder: (ctx, i) => rows[i].builder(ctx),
            ),
          ),
        ],
      ),
    );
  }

  // ── Flat row builder ──────────────────────────────────────────

  (List<_MenuRow>, Map<int, int>) _buildRows(
    MenuData menu,
    AsyncValue<RestaurantData> restaurantAsync,
  ) {
    final rows = <_MenuRow>[];
    final tabStart = <int, int>{};
    final isSearching = _searchQuery.isNotEmpty;

    // Row 0: hero + restaurant info + search + rating.
    rows.add(
      _MenuRow(tab: -1, builder: (_) => _buildHeaderBlock(restaurantAsync)),
    );

    final featured = _filtered(menu.popularItems);
    final mostOrdered = _filtered(menu.mostOrderedItems);

    // Featured Items → tab 0
    if (featured.isNotEmpty) {
      tabStart[0] = rows.length;
      rows.add(
        _MenuRow(
          tab: 0,
          builder: (_) => _buildFeaturedSection(featured, isSearching),
        ),
      );
    }

    // Most Ordered → tab 1
    if (mostOrdered.isNotEmpty) {
      tabStart[1] = rows.length;
      rows.add(
        _MenuRow(tab: 1, builder: (_) => _buildMostOrderedSection(mostOrdered)),
      );
    }

    // API categories → tab 2+. Each item is its own row → lazily built.
    for (var c = 0; c < menu.categories.length; c++) {
      final cat = menu.categories[c];
      final items = _filtered(cat.displayItems);
      if (items.isEmpty) continue;
      final tab = c + 2;
      tabStart[tab] = rows.length;
      rows.add(
        _MenuRow(tab: tab, builder: (_) => _buildCategoryHeader(cat.name)),
      );
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        final divider = i > 0;
        rows.add(
          _MenuRow(
            tab: tab,
            builder: (_) => _buildMenuItemRow(item, divider),
          ),
        );
      }
    }

    rows.add(_MenuRow(tab: -1, builder: (_) => const Gap(80)));
    return (rows, tabStart);
  }

  Widget _statusRow({required bool loading}) => Padding(
    padding: const EdgeInsets.all(48),
    child: Center(
      child: loading
          ? const CircularProgressIndicator()
          : const Text(
              'Failed to load menu',
              style: TextStyle(color: Colors.grey),
            ),
    ),
  );

  // ── Header block (hero + info + search + rating) ──────────────

  Widget _buildHeaderBlock(AsyncValue<RestaurantData> restaurantAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHero(restaurantAsync),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              restaurantAsync.when(
                data: (r) => Text(
                  r.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    height: 1.28,
                    letterSpacing: -1.0,
                    color: Color(0xFF040707),
                  ),
                ),
                loading: () => _skeleton(160, 28),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const Gap(6),
              // Location row
              restaurantAsync.when(
                data: (r) => Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFF737780),
                      size: 16,
                    ),
                    const Gap(5),
                    Flexible(
                      child: Text(
                        r.addressStr ?? r.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF040707),
                        ),
                      ),
                    ),
                    if (r.deliveryTime != null) ...[
                      const Gap(16),
                      const Icon(
                        Icons.access_time,
                        color: Color(0xFF737780),
                        size: 16,
                      ),
                      const Gap(5),
                      Text(
                        r.deliveryTime!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          height: 1.5,
                          color: Color(0xFF040707),
                        ),
                      ),
                    ],
                  ],
                ),
                loading: () => _skeleton(220, 16),
                error: (_, _) => const SizedBox.shrink(),
              ),
              const Gap(16),
              _buildDeliveryPickupCard(restaurantAsync),
              const Gap(16),
              // Search bar
              Container(
                height: 48,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Search menu',
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Color(0xFF9EA3B0),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF9EA3B0),
                      size: 20,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchCtrl.clear();
                              setState(() => _searchQuery = '');
                            },
                            child: const Icon(
                              Icons.close_rounded,
                              color: Color(0xFF9EA3B0),
                              size: 18,
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const Gap(24),
              // Rating card
              restaurantAsync.when(
                data: (r) => _buildRatingCard(r),
                loading: () => _skeleton(double.infinity, 56),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Hero ──────────────────────────────────────────────────────

  Widget _buildHero(AsyncValue<RestaurantData> async) {
    final banner = async.whenOrNull(
      data: (r) => r.banner != null && r.banner!.isNotEmpty ? r.banner : null,
    );
    final logo = async.whenOrNull(
      data: (r) => r.logo != null && r.logo!.isNotEmpty ? r.logo : null,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: 238,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            image: banner != null
                ? DecorationImage(
                    image: CachedNetworkImageProvider(banner),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          child: const RoundedBackButton.primary(),
        ),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 16,
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _isFavourite = !_isFavourite),
                child: _circleBtn(
                  Icon(
                    _isFavourite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: _isFavourite
                        ? const Color(0xFFE53935)
                        : const Color(0xFF040707),
                    size: 20,
                  ),
                ),
              ),
              const Gap(8),
              _circleBtn(
                const Icon(
                  Icons.ios_share_rounded,
                  color: Color(0xFF040707),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          bottom: -32,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6EFFC), width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: logo != null
                  ? CachedNetworkImage(
                      imageUrl: logo,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => const Icon(
                        Icons.restaurant,
                        size: 32,
                        color: Color(0xFFBDBDBD),
                      ),
                    )
                  : const Icon(
                      Icons.restaurant,
                      size: 32,
                      color: Color(0xFFBDBDBD),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Delivery / Pickup Card ────────────────────────────────────

  Widget _buildDeliveryPickupCard(AsyncValue<RestaurantData> async) {
    final deliveryTime =
        async.whenOrNull(data: (r) => r.deliveryTime ?? '30–45 min') ??
        '30–45 min';
    final address = async.whenOrNull(data: (r) => r.addressStr) ?? '';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF0F0F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isDelivery = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: _isDelivery
                              ? const Color(0xFF1C1F2E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Delivery',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: _isDelivery
                                ? Colors.white
                                : const Color(0xFF737780),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _isDelivery = false);
                        _ensureShopCoords(address);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: !_isDelivery
                              ? const Color(0xFF1C1F2E)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          'Pickup',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: !_isDelivery
                                ? Colors.white
                                : const Color(0xFF737780),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),
              if (_isDelivery)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Support your neighborhood\nkitchen',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          height: 1.4,
                          color: Color(0xFF040707),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: const Color(0xFFEBEBEB),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deliveryTime,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: Color(0xFF040707),
                          ),
                        ),
                        const Gap(2),
                        const Text(
                          'delivery time',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xFF737780),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No fees',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF040707),
                      ),
                    ),
                    const Gap(2),
                    Text(
                      '$deliveryTime ready time',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color(0xFF737780),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        if (!_isDelivery) ...[
          const Gap(12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF0F0F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: SizedBox(
                    height: 140,
                    child: _geocoding
                        ? const ColoredBox(
                            color: Color(0xFFF5F5F5),
                            child: Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF0156A7),
                                ),
                              ),
                            ),
                          )
                        : _shopLat != null && _shopLng != null
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(_shopLat!, _shopLng!),
                              zoom: 15,
                            ),
                            onMapCreated: (c) => _shopMapController = c,
                            markers: {
                              Marker(
                                markerId: const MarkerId('shop'),
                                position: LatLng(_shopLat!, _shopLng!),
                              ),
                            },
                            myLocationEnabled: false,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            scrollGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                          )
                        : const ColoredBox(
                            color: Color(0xFFF5F5F5),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 36,
                                    color: Color(0xFFCCCCCC),
                                  ),
                                  Gap(6),
                                  Text(
                                    'Map unavailable',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9EA3B0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PICK UP THIS ORDER AT:',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                          letterSpacing: 0.8,
                          color: Color(0xFF737780),
                        ),
                      ),
                      const Gap(4),
                      Text(
                        address.isNotEmpty ? address : 'Address unavailable',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF040707),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── Rating Card ───────────────────────────────────────────────

  Widget _buildRatingCard(RestaurantData r) {
    final rating = r.rating?.toStringAsFixed(1) ?? '–';
    final count = r.reviewCount ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: Color(0xFFFF6700),
                size: 26,
              ),
              const Gap(4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    rating,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 1.2,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '($count Review${count == 1 ? '' : 's'})',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.5,
                      color: context.color.text.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          TextButton(
            onPressed: () => context.push(Routes.restaurantReviews, extra: r),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'View All Reviews',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                height: 1.5,
                letterSpacing: -0.5,
                color: Color(0xFF0156A7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────

  Widget _buildTabBar(MenuData menu, List<String> tabs) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tabs.length,
              itemBuilder: (_, i) => _buildTabItem(i, tabs[i]),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEBEBEB)),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label) {
    return GestureDetector(
      onTap: () => _onTabTapped(index),
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedTab,
        builder: (_, selected, _) {
          final isSelected = index == selected;
          return Container(
            margin: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected
                      ? const Color(0xFF040707)
                      : Colors.transparent,
                  width: 2.5,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
                color: isSelected
                    ? const Color(0xFF040707)
                    : const Color(0xFF737780),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Menu sections ─────────────────────────────────────────────

  Widget _buildFeaturedSection(List<MenuItem> featured, bool isSearching) {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SectionHeader(title: 'Featured Items'),
                if (!isSearching)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (_featuredPage > 0) {
                            _featuredPageCtrl.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: _navArrow(Icons.chevron_left_rounded),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: () {
                          if (_featuredPage < featured.length - 1) {
                            _featuredPageCtrl.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: _navArrow(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const Gap(16),
          if (isSearching)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                itemCount: featured.length,
                itemBuilder: (_, i) => FoodGridTile(
                  item: featured[i],
                  onAddTap: () => _openAddFood(featured[i]),
                ),
              ),
            )
          else
            SizedBox(
              height: 260,
              child: PageView.builder(
                controller: _featuredPageCtrl,
                onPageChanged: (p) => setState(() => _featuredPage = p),
                itemCount: featured.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FeaturedItemCard(
                    item: featured[i],
                    onAddTap: () => _openAddFood(featured[i]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMostOrderedSection(List<MenuItem> mostOrdered) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Most Ordered',
            subtitle:
                'The most commonly ordered items and dishes from this store',
          ),
          const Gap(16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: mostOrdered.length,
            itemBuilder: (_, i) => FoodGridTile(
              item: mostOrdered[i],
              onAddTap: () => _openAddFood(mostOrdered[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(String name) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [SectionHeader(title: name), const Gap(16)],
      ),
    );
  }

  Widget _buildMenuItemRow(MenuItem item, bool divider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (divider)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(color: Color(0xFFF0F0F0), height: 1),
            ),
          MenuListItem(item: item, onAddTap: () => _openAddFood(item)),
        ],
      ),
    );
  }

  // ── Micro-widgets ─────────────────────────────────────────────

  Widget _navArrow(IconData icon) => Container(
    width: 36,
    height: 36,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 6),
      ],
    ),
    child: Icon(icon, color: const Color(0xFF040707), size: 22),
  );

  Widget _circleBtn(Widget child) => Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: child,
  );

  Widget _skeleton(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
