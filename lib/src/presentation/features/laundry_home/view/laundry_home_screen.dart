import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../home/riverpod/hero_banner_provider.dart';
import '../../medicine_home/widgets/medicine_home_header.dart';
import '../../medicine_home/widgets/medicine_promotional_banner.dart';
import '../../medicine_home/widgets/medicine_section_header.dart';
import '../riverpod/laundry_provider.dart';
import '../widgets/laundry_home_widgets.dart';
import '../widgets/laundry_service_card.dart';

/// Laundry service homepage.
///
/// Header → search → promise card → (banner) → category tiles, then a pinned
/// category tab bar over one vertical list per category, and a fixed cart
/// bar. Shares header, search pill, section header, card radius/shadow and
/// ৳ price styling with Mart and Medicine (see ui-registry.md).
class LaundryHomeScreen extends ConsumerStatefulWidget {
  const LaundryHomeScreen({super.key});

  @override
  ConsumerState<LaundryHomeScreen> createState() => _LaundryHomeScreenState();
}

class _LaundryHomeScreenState extends ConsumerState<LaundryHomeScreen> {
  final _scroll = ScrollController();
  final _scrollViewKey = GlobalKey();
  final _search = TextEditingController();
  final Map<String, GlobalKey> _sectionKeys = {};
  final Map<String, GlobalKey> _tabKeys = {};
  String _query = '';
  String? _active;

  static const double _tabsHeight = 56;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_updateActive);
  }

  @override
  void dispose() {
    _scroll.dispose();
    _search.dispose();
    super.dispose();
  }

  GlobalKey _keyFor(String category) =>
      _sectionKeys.putIfAbsent(category, GlobalKey.new);

  /// Section whose top has passed under the pinned tab bar is "active".
  void _updateActive() {
    final viewport = _scrollViewKey.currentContext?.findRenderObject();
    if (viewport is! RenderBox || !viewport.attached) return;
    final lineY = viewport.localToGlobal(Offset.zero).dy + _tabsHeight + 8;

    String? current;
    for (final entry in _sectionKeys.entries) {
      final box = entry.value.currentContext?.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= lineY) current = entry.key;
    }
    current ??= _sectionKeys.keys.firstOrNull;
    // Short last sections never reach the tab line; at the bottom of the
    // page the last section is the one being viewed.
    if (_scroll.hasClients &&
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 4) {
      current = _sectionKeys.keys.lastOrNull ?? current;
    }
    if (current != _active) {
      setState(() => _active = current);
      if (current != null) _revealTab(current);
    }
  }

  /// Slides the horizontal tab bar so the active tab is visible.
  void _revealTab(String category) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tab = _tabKeys[category]?.currentContext;
      final box = tab?.findRenderObject();
      if (tab == null || box == null || !mounted) return;
      // Only the horizontal tab list — Scrollable.ensureVisible would also
      // scroll the page and interrupt a section jump in progress.
      Scrollable.maybeOf(tab)?.position.ensureVisible(
        box,
        alignment: 0.5,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _jumpTo(String category) {
    final target = _sectionKeys[category]?.currentContext?.findRenderObject();
    if (target == null) return;
    final viewport = RenderAbstractViewport.maybeOf(target);
    if (viewport == null) return;
    setState(() => _active = category);
    _revealTab(category);
    // getOffsetToReveal already accounts for the pinned tab bar.
    final offset = viewport.getOffsetToReveal(target, 0).offset;
    _scroll.animateTo(
      offset.clamp(0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  List<LaundryCatalogItem> _filter(List<LaundryCatalogItem> items) {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items
        .where(
          (i) =>
              i.service.name.toLowerCase().contains(q) ||
              (i.service.itemCategory?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  /// Groups items by category, keeping the catalog's own category order.
  Map<String, List<LaundryCatalogItem>> _group(List<LaundryCatalogItem> items) {
    final groups = <String, List<LaundryCatalogItem>>{};
    for (final item in items) {
      final category = item.service.itemCategory?.trim();
      final key = (category == null || category.isEmpty)
          ? 'Other services'
          : category;
      groups.putIfAbsent(key, () => []).add(item);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;
    final servicesAsync = ref.watch(laundryServicesProvider);
    final hasBanner =
        (ref.watch(heroBannerProvider('laundry')).value ?? const []).isNotEmpty;

    final all = servicesAsync.value ?? const <LaundryCatalogItem>[];
    final allGroups = _group(all);
    final groups = _group(_filter(all));
    final searching = _query.trim().isNotEmpty;

    return Scaffold(
      bottomNavigationBar: const LaundryCartBar(),
      body: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            key: _scrollViewKey,
            controller: _scroll,
            // Keep every category section built (~70 rows) so tab/tile taps
            // can find far-away sections and the active tab tracks them.
            scrollCacheExtent: const ScrollCacheExtent.pixels(100000),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(dims.spacing.s16),
                      const MedicineHomeHeader(currentRoute: Routes.laundry),
                      Gap(dims.spacing.s24),
                      LaundrySearchField(
                        controller: _search,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      if (!searching) ...[
                        Gap(dims.spacing.s16),
                        const LaundryPromiseCard(),
                        if (hasBanner) ...[
                          Gap(dims.spacing.s16),
                          const MedicinePromotionalBanner(
                            bannerCategory: 'laundry',
                          ),
                        ],
                        if (allGroups.length > 1) ...[
                          Gap(dims.spacing.s24),
                          const MedicineSectionHeader(title: 'Categories'),
                          Gap(dims.spacing.s12),
                          LaundryCategoryTiles(
                            categories: allGroups.keys.toList(),
                            counts: {
                              for (final e in allGroups.entries)
                                e.key: e.value.length,
                            },
                            onTap: _jumpTo,
                          ),
                        ],
                      ],
                      Gap(dims.spacing.s16),
                    ],
                  ),
                ),
              ),
              if (!searching && groups.length > 1)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: LaundryCategoryTabsDelegate(
                    categories: groups.keys.toList(),
                    active: _active ?? groups.keys.first,
                    onTap: _jumpTo,
                    height: _tabsHeight,
                    background: colors.background.surfaceContainerHigh,
                    tabKeys: _tabKeys,
                  ),
                ),
              ..._body(context, servicesAsync, groups, searching),
              SliverToBoxAdapter(child: Gap(dims.spacing.s100)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _body(
    BuildContext context,
    AsyncValue<List<LaundryCatalogItem>> async,
    Map<String, List<LaundryCatalogItem>> groups,
    bool searching,
  ) {
    final dims = context.dimensions;

    if (async.isLoading && !async.hasValue) {
      return [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: dims.padding.p16),
          sliver: SliverList.separated(
            itemCount: 3,
            separatorBuilder: (_, _) => Gap(dims.spacing.s16),
            itemBuilder: (_, _) => const _SectionSkeleton(),
          ),
        ),
      ];
    }
    if (async.hasError && !async.hasValue) {
      return const [
        SliverToBoxAdapter(
          child: _Message(text: "Couldn't load laundry services"),
        ),
      ];
    }
    if (groups.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: _Message(
            text: searching
                ? 'No items match "${_query.trim()}"'
                : 'Laundry is not available in your area yet',
          ),
        ),
      ];
    }

    return [
      for (final entry in groups.entries)
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            dims.padding.p16,
            dims.padding.p8,
            dims.padding.p16,
            dims.padding.p16,
          ),
          sliver: SliverToBoxAdapter(
            child: _CategorySection(
              key: _keyFor(entry.key),
              title: entry.key,
              items: entry.value,
            ),
          ),
        ),
    ];
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({super.key, required this.title, required this.items});

  final String title;
  final List<LaundryCatalogItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MedicineSectionHeader(title: title),
        Gap(dims.spacing.s12),
        Container(
          padding: EdgeInsets.symmetric(horizontal: dims.padding.p12),
          decoration: BoxDecoration(
            color: colors.background.surface,
            borderRadius: BorderRadius.circular(dims.radius.r12),
            boxShadow: [
              BoxShadow(
                color: colors.elevation.elevationLow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) Divider(height: 1, color: colors.border.divider),
                LaundryServiceRow(item: items[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionSkeleton extends StatelessWidget {
  const _SectionSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.color;
    final dims = context.dimensions;

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: colors.background.surface,
        borderRadius: BorderRadius.circular(dims.radius.r12),
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

    return Padding(
      padding: EdgeInsets.all(dims.padding.p32),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.local_laundry_service_outlined,
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
    );
  }
}
