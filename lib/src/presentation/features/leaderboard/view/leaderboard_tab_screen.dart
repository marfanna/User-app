import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/theme/src/theme_extensions/src/gradients.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../profile/riverpod/customer_profile_provider.dart';
import '../models/leaderboard_models.dart';
import '../riverpod/leaderboard_provider.dart';

class LeaderboardTabScreen extends ConsumerWidget {
  const LeaderboardTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final profileAsync = ref.watch(customerProfileProvider);
    final currentUserId = profileAsync.asData?.value.id ?? '';

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _LeaderboardHeader(),
              Expanded(
                child: leaderboardAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFFCCCCCC),
                        ),
                        const Gap(12),
                        const Text(
                          'Failed to load leaderboard',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: Color(0xFF737780),
                          ),
                        ),
                        const Gap(16),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(leaderboardProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (data) {
                    if (data.standings.isEmpty) {
                      return const Center(
                        child: Text(
                          'No standings yet this month.',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: Color(0xFF737780),
                          ),
                        ),
                      );
                    }
                    final top3 = data.standings.take(3).toList();
                    final rest = data.standings.skip(3).toList();
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _LeaderboardPodium(top3: top3),
                          const Gap(16),
                          _LeaderboardList(
                            entries: rest,
                            currentUserId: currentUserId,
                          ),
                          const Gap(32),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardHeader extends ConsumerWidget {
  const _LeaderboardHeader();

  void _showRankingRules(BuildContext context, String theme) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RankingRulesSheet(activeTheme: theme),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(
      leaderboardProvider.select((v) => v.asData?.value.theme ?? 'order_volume'),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: -1,
                      color: Color(0xFF040707),
                    ),
                  ),
                  Gap(4),
                  Row(
                    children: [
                      Text(
                        'Restaurants',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          letterSpacing: -1,
                          color: Color(0xFF040707),
                        ),
                      ),
                      Gap(4),
                      Icon(
                        Icons.expand_more,
                        color: Color(0xFF1C1B1F),
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF1C1C1C),
                  size: 24,
                ),
              ),
            ],
          ),
          const Gap(24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ranking',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF040707),
                ),
              ),
              GestureDetector(
                onTap: () => _showRankingRules(context, theme),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF28303F),
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'i',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Color(0xFF28303F),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }
}

// ── Ranking Rules Bottom Sheet ─────────────────────────────────────────────

class _RankingRulesSheet extends StatelessWidget {
  const _RankingRulesSheet({required this.activeTheme});

  final String activeTheme;

  // Returns the single active scoring rule based on the admin-selected theme
  Map<String, dynamic> get _activeRule {
    switch (activeTheme) {
      case 'weekend_warrior':
        return {
          'icon': Icons.weekend_rounded,
          'color': const Color(0xFF9C27B0),
          'title': 'Weekend Warrior',
          'description':
              'Earn 2× points on all orders placed on weekends (Saturday & Sunday). Order more on weekends to climb faster!',
        };
      case 'spend_master':
        return {
          'icon': Icons.trending_up_rounded,
          'color': const Color(0xFF4CAF50),
          'title': 'Spend Master',
          'description':
              'Earn bonus points when your order total exceeds 2,000 BDT. Spend more per order to score higher!',
        };
      default: // order_volume / standard
        return {
          'icon': Icons.monetization_on_rounded,
          'color': const Color(0xFF0156A7),
          'title': 'Standard',
          'description':
              'Earn 1 point for every 1 BDT you spend. The more you order, the higher you rank!',
        };
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + MediaQuery.of(context).padding.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Gap(20),
            // Title
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6EFFC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.emoji_events_rounded,
                    color: Color(0xFF0156A7),
                    size: 20,
                  ),
                ),
                const Gap(12),
                const Text(
                  'How Ranking Works',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xFF040707),
                  ),
                ),
              ],
            ),
            const Gap(20),
            const Divider(color: Color(0xFFF0F0F0)),
            const Gap(16),

            // ── Active Scoring Rule ────────────────────────────────
            const Text(
              'Active Scoring Rule',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(10),
            _RuleItem(
              icon: _activeRule['icon'] as IconData,
              iconColor: _activeRule['color'] as Color,
              title: _activeRule['title'] as String,
              description: _activeRule['description'] as String,
            ),
            const Gap(10),
            const _RuleItem(
              icon: Icons.calendar_month_rounded,
              iconColor: Color(0xFFFF9800),
              title: 'Monthly Reset',
              description:
                  'The leaderboard resets at the start of every month — a fresh start for all!',
            ),


            const Gap(20),
            const Divider(color: Color(0xFFF0F0F0)),
            const Gap(16),

            // ── Prizes ────────────────────────────────────────────
            const Text(
              'This Month\'s Prizes',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(10),
            const _PrizeItem(
              icon: Icons.emoji_events_rounded,
              rank: '1st Place',
              prize: '1 Month free home delivery',
              rankColor: Color(0xFFFBBB00),
            ),
            const Gap(8),
            const _PrizeItem(
              icon: Icons.military_tech_rounded,
              rank: '2nd Place',
              prize: '15 days free home delivery',
              rankColor: Color(0xFFD223FB),
            ),
            const Gap(8),
            const _PrizeItem(
              icon: Icons.military_tech_rounded,
              rank: '3rd Place',
              prize: '5 free home deliveries',
              rankColor: Color(0xFF23A2FE),
            ),

            const Gap(20),
            // CTA note
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE6EFFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Order more to earn more points and win prizes this month!',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  height: 1.6,
                  color: Color(0xFF0156A7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF040707),
                ),
              ),
              const Gap(2),
              Text(
                description,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  height: 1.6,
                  color: Color(0xFF60655C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrizeItem extends StatelessWidget {
  const _PrizeItem({
    required this.icon,
    required this.rank,
    required this.prize,
    required this.rankColor,
  });

  final IconData icon;
  final String rank;
  final String prize;
  final Color rankColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: rankColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: rankColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: rankColor,
              size: 22,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rank,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: rankColor,
                  ),
                ),
                const Gap(2),
                Text(
                  prize,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xFF363A33),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PodiumBadge extends StatelessWidget {
  const _PodiumBadge({
    required this.rank,
    required this.color,
  });

  final int rank;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$rank',
        style: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _PodiumAvatar extends StatelessWidget {
  const _PodiumAvatar({
    required this.entry,
    required this.badgeColor,
    required this.isFirst,
  });

  final LeaderboardEntry entry;
  final Color badgeColor;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = isFirst ? 84 : 74;
    const double badgeSize = 28;
    final name = entry.name.length > 10
        ? '${entry.name.substring(0, 10)}..'
        : entry.name;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: avatarSize,
          height: avatarSize + (badgeSize / 2),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE0E0E0),
                  border: Border.all(
                    color: isFirst
                        ? const Color(0xFFFBBB00)
                        : const Color(0xFF0156A7),
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: entry.profileImage != null &&
                          entry.profileImage!.isNotEmpty
                      ? Image.network(
                          entry.profileImage!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 40,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                ),
              ),
              if (isFirst)
                const Positioned(
                  top: -15,
                  child: Icon(
                    Icons.star,
                    color: Color(0xFFFBBB00),
                    size: 30,
                  ),
                ),
              Positioned(
                bottom: 0,
                child: _PodiumBadge(rank: entry.rank, color: badgeColor),
              ),
            ],
          ),
        ),
        const Gap(6),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const Gap(2),
        Text(
          '${entry.score.round()} Points',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _LeaderboardPodium extends StatelessWidget {
  const _LeaderboardPodium({required this.top3});

  final List<LeaderboardEntry> top3;

  @override
  Widget build(BuildContext context) {
    final first = top3.isNotEmpty ? top3[0] : null;
    final second = top3.length > 1 ? top3[1] : null;
    final third = top3.length > 2 ? top3[2] : null;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: AppGradients.primaryRadial,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (second != null)
            Positioned(
              left: 10,
              bottom: 25,
              child: _PodiumAvatar(
                entry: second,
                badgeColor: const Color(0xFFD223FB),
                isFirst: false,
              ),
            ),
          if (third != null)
            Positioned(
              right: 10,
              bottom: 25,
              child: _PodiumAvatar(
                entry: third,
                badgeColor: const Color(0xFF23A2FE),
                isFirst: false,
              ),
            ),
          if (first != null)
            Positioned(
              bottom: 20,
              child: _PodiumAvatar(
                entry: first,
                badgeColor: const Color(0xFFFBBB00),
                isFirst: true,
              ),
            ),
        ],
      ),
    );
  }
}

class _LeaderboardList extends StatelessWidget {
  const _LeaderboardList({
    required this.entries,
    required this.currentUserId,
  });

  final List<LeaderboardEntry> entries;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries
          .map((e) => _LeaderboardListTile(
                entry: e,
                isYou: e.id == currentUserId,
              ))
          .toList(),
    );
  }
}

class _LeaderboardListTile extends StatelessWidget {
  const _LeaderboardListTile({
    required this.entry,
    required this.isYou,
  });

  final LeaderboardEntry entry;
  final bool isYou;

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank.toString().padLeft(2, '0');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: isYou
            ? Border.all(color: const Color(0xFF0156A7), width: 1)
            : null,
        boxShadow: isYou
            ? null
            : const [
                BoxShadow(
                  color: Color.fromRGBO(90, 108, 234, 0.07),
                  blurRadius: 52,
                  offset: Offset(12.48, 27.04),
                ),
              ],
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF040707),
            ),
          ),
          const Gap(12),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFE0E0E0),
            ),
            child: ClipOval(
              child: entry.profileImage != null &&
                      entry.profileImage!.isNotEmpty
                  ? Image.network(
                      entry.profileImage!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: entry.name,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF040707),
                ),
                children: [
                  if (isYou)
                    const TextSpan(
                      text: ' (you)',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF0156A7),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Points',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF0156A7),
                ),
              ),
              const Gap(2),
              Text(
                '${entry.score.round()}',
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF0156A7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
