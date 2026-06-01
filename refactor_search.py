import re

with open('d:/Duare Master/apps/user/lib/src/presentation/features/restaurant_detail/view/restaurant_detail_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. State Variables
state_vars = '''  // ── UI State ──────────────────────────────────────────────────
  bool _isFavourite = false;
  bool _isDelivery = true;
  int _selectedTabIndex = 0;
  int _featuredPage = 0;

  // ── Search State ──────────────────────────────────────────────
  final _searchKey = GlobalKey();
  late final FocusNode _searchFocusNode;
  late final TextEditingController _searchCtrl;
  String _searchQuery = '';'''

content = content.replace('''  // ── UI State ──────────────────────────────────────────────────
  bool _isFavourite = false;
  bool _isDelivery = true;
  int _selectedTabIndex = 0;
  int _featuredPage = 0;''', state_vars)

# 2. InitState
init_state_orig = '''  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _featuredPageCtrl = PageController(viewportFraction: 0.85);
    _scrollController.addListener(_onScroll);
  }'''

init_state_new = '''  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _featuredPageCtrl = PageController(viewportFraction: 0.85);
    _scrollController.addListener(_onScroll);
    
    _searchFocusNode = FocusNode();
    _searchCtrl = TextEditingController();

    _searchFocusNode.addListener(() {
      if (_searchFocusNode.hasFocus) {
        final ctx = _searchKey.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: 0.0,
          );
        }
      }
      setState(() {});
    });

    _searchCtrl.addListener(() {
      setState(() {
        _searchQuery = _searchCtrl.text;
      });
    });
  }'''

content = content.replace(init_state_orig, init_state_new)

# 3. Dispose
dispose_orig = '''  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _featuredPageCtrl.dispose();
    super.dispose();
  }'''

dispose_new = '''  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _featuredPageCtrl.dispose();
    _searchFocusNode.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }'''

content = content.replace(dispose_orig, dispose_new)

# 4. _buildSearchResults method
search_results_method = '''  Widget _buildSearchResults() {
    final query = _searchQuery.toLowerCase();
    
    final allItems = [
      ..._featuredItems,
      ..._mostOrderedItems,
      ..._categoryItems.values.expand((items) => items),
    ];
    
    final uniqueItems = <String, MenuItem>{};
    for (final item in allItems) {
      uniqueItems[item.name] = item;
    }
    
    final results = uniqueItems.values
        .where((item) => item.name.toLowerCase().contains(query))
        .toList();

    if (results.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            'No items found',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              color: Color(0xFF737780),
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: results.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Divider(color: Color(0xFFF0F0F0), height: 1),
      ),
      itemBuilder: (context, index) => MenuListItem(
        item: results[index],
        onAddTap: () {},
      ),
    );
  }

  @override'''

content = content.replace('''  @override
  Widget build(BuildContext context) {''', search_results_method + '''
  Widget build(BuildContext context) {''')

# 5. Search TextField
search_bar_orig = '''                  // ── Search Menu Bar ───────────
                  Container(
                    height: 48,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                      decoration: const InputDecoration(
                        hintText: 'Search menu',
                        hintStyle: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF9EA3B0),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Color(0xFF9EA3B0),
                          size: 20,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),'''

search_bar_new = '''                  // ── Search Menu Bar ───────────
                  Container(
                    key: _searchKey,
                    height: 48,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextField(
                      controller: _searchCtrl,
                      focusNode: _searchFocusNode,
                      textAlignVertical: TextAlignVertical.center,
                      onTapOutside: (event) {
                        _searchFocusNode.unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: 'Search menu',
                        hintStyle: const TextStyle(
                          fontFamily: 'Manrope',
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
                          ? IconButton(
                              icon: const Icon(Icons.close, color: Color(0xFF9EA3B0), size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                _searchFocusNode.unfocus();
                              },
                            ) 
                          : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),'''

content = content.replace(search_bar_orig, search_bar_new)

# 6. Conditionally render slivers
sliver_target = '''          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyTabBarDelegate('''

sliver_replacement = '''          if (!_searchFocusNode.hasFocus && _searchQuery.isEmpty) ...[
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate('''

content = content.replace(sliver_target, sliver_replacement)

end_target = '''            // Bottom safe area
            const Gap(80),
          ],
        ),
      ),
        ],'''

end_replacement = '''            // Bottom safe area
            const Gap(80),
          ],
        ),
      ),
          ] else
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildSearchResults(),
              ),
            ),
        ],'''

content = content.replace(end_target, end_replacement)

with open('d:/Duare Master/apps/user/lib/src/presentation/features/restaurant_detail/view/restaurant_detail_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("SUCCESS")
