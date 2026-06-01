import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

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
  int _selectedTabIndex = 0;
  int _featuredPage = 0;
  String _searchQuery = '';

  // ── Controllers ───────────────────────────────────────────────
  late final ScrollController _scrollController;
  late final PageController _featuredPageCtrl;
  late final TextEditingController _searchCtrl;

  // ── Section Keys ──────────────────────────────────────────────
  final _featuredKey = GlobalKey();
  final _mostOrderedKey = GlobalKey();
  final Map<String, GlobalKey> _categoryKeys = {};

  // ── Cached menu for scroll detection ─────────────────────────
  MenuData? _cachedMenu;
  String _cachedShopName = '';
  final Map<String, ApiMenuItemData> _rawItems = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _featuredPageCtrl = PageController(viewportFraction: 0.85);
    _searchCtrl = TextEditingController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _featuredPageCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  GlobalKey _keyFor(String catId) =>
      _categoryKeys.putIfAbsent(catId, () => GlobalKey());

  List<String> _buildTabs(MenuData menu) => [
    'Featured Items',
    'Most Ordered',
    ...menu.categories.map((c) => c.name),
  ];

  void _onScroll() {
    final menu = _cachedMenu;
    if (menu == null) return;
    final sections = <(GlobalKey, int)>[
      ...menu.categories
          .asMap()
          .entries
          .map((e) => (_keyFor(e.value.id), e.key + 2))
          .toList()
          .reversed,
      (_mostOrderedKey, 1),
      (_featuredKey, 0),
    ];
    for (final (key, tabIndex) in sections) {
      final ctx = key.currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy <= 250) {
        if (_selectedTabIndex != tabIndex) {
          setState(() => _selectedTabIndex = tabIndex);
        }
        break;
      }
    }
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.05,
    );
  }

  void _onTabTapped(int index, MenuData menu) {
    setState(() => _selectedTabIndex = index);
    if (index == 0) {
      _scrollToKey(_featuredKey);
    } else if (index == 1) {
      _scrollToKey(_mostOrderedKey);
    } else {
      final catIndex = index - 2;
      if (catIndex < menu.categories.length) {
        _scrollToKey(_keyFor(menu.categories[catIndex].id));
      }
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
          _categoryKeys.putIfAbsent(cat.id, () => GlobalKey());
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
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
                        error: (_, __) => const SizedBox.shrink(),
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
                        error: (_, __) => const SizedBox.shrink(),
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                      const Gap(24),
                      // Rating card
                      restaurantAsync.when(
                        data: (r) => _buildRatingCard(r),
                        loading: () => _skeleton(double.infinity, 56),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                      const Gap(20),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Sticky Tab Bar ───────────────────────────────────
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(
                      height: 44,
                      child: menuAsync.when(
                        data: (menu) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: tabs.length,
                          itemBuilder: (_, i) =>
                              _buildTabItem(i, tabs[i], menu),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, __) => const SizedBox.shrink(),
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFEBEBEB)),
                  ],
                ),
              ),
            ),
          ),

          // ── Menu Content ─────────────────────────────────────
          SliverToBoxAdapter(
            child: menuAsync.when(
              data: _buildMenuContent,
              loading: () => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, __) => const Padding(
                padding: EdgeInsets.all(48),
                child: Center(
                  child: Text(
                    'Failed to load menu',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
                    image: NetworkImage(banner),
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
                  ? Image.network(
                      logo,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
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
                      onTap: () => setState(() => _isDelivery = false),
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
                Container(
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: const Center(
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
            onPressed: () => context.push(Routes.restaurantReviews),
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

  // ── Tab Item ──────────────────────────────────────────────────

  Widget _buildTabItem(int index, String label, MenuData menu) {
    final isSelected = index == _selectedTabIndex;
    return GestureDetector(
      onTap: () => _onTabTapped(index, menu),
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? const Color(0xFF040707) : Colors.transparent,
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
      ),
    );
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

  // ── Menu Content ─────────────────────────────────────────────

  Widget _buildMenuContent(MenuData menu) {
    final featured = _filtered(menu.popularItems);
    final mostOrdered = _filtered(menu.mostOrderedItems);
    final isSearching = _searchQuery.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(24),

        // Featured Items
        if (featured.isNotEmpty)
          Column(
            key: _featuredKey,
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
        const Gap(32),

        // Most Ordered
        if (mostOrdered.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              key: _mostOrderedKey,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
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
          ),
        const Gap(32),

        // API Category Sections
        ...menu.categories.map((cat) {
          final items = _filtered(cat.displayItems);
          if (items.isEmpty) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
            child: Column(
              key: _keyFor(cat.id),
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(title: cat.name),
                const Gap(16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(color: Color(0xFFF0F0F0), height: 1),
                  ),
                  itemBuilder: (_, i) => MenuListItem(
                    item: items[i],
                    onAddTap: () => _openAddFood(items[i]),
                  ),
                ),
              ],
            ),
          );
        }),

        const Gap(80),
      ],
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

// ── Sticky Header Delegate ────────────────────────────────────

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  _StickyTabBarDelegate({required this.child});
  final Widget child;

  @override
  double get minExtent => 45;
  @override
  double get maxExtent => 45;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyTabBarDelegate oldDelegate) => true;
}
