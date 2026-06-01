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

class _LeaderboardHeader extends StatelessWidget {
  const _LeaderboardHeader();

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 24,
                height: 24,
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
                    fontSize: 12,
                    color: Color(0xFF28303F),
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
        if (isFirst) ...[
          const Gap(2),
          Text(
            '${entry.totalOrders} Orders',
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
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
                      errorBuilder: (_, __, ___) => const Icon(
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
                'Total Orders',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Color(0xFF0156A7),
                ),
              ),
              const Gap(2),
              Text(
                '${entry.totalOrders}',
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
