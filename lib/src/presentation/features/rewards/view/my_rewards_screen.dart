import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/widgets/gradient_background.dart';
import '../models/delivery_reward_model.dart';
import '../riverpod/rewards_provider.dart';

class MyRewardsScreen extends ConsumerWidget {
  const MyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myRewardsProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DuareAppBar(title: 'My Rewards'),
              Expanded(
                child: async.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) => Center(
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
                          'Failed to load rewards',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: Color(0xFF737780),
                          ),
                        ),
                        const Gap(16),
                        TextButton(
                          onPressed: () =>
                              ref.invalidate(myRewardsProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                  data: (rewards) {
                    if (rewards.isEmpty) {
                      return const _EmptyState();
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      itemCount: rewards.length,
                      separatorBuilder: (_, _) => const Gap(12),
                      itemBuilder: (_, i) => _RewardCard(reward: rewards[i]),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE6EFFC),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: Color(0xFF0156A7),
                size: 40,
              ),
            ),
            const Gap(20),
            const Text(
              'No active rewards',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Color(0xFF040707),
              ),
            ),
            const Gap(8),
            const Text(
              'Win the monthly leaderboard to earn '
              'free delivery rewards!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                height: 1.6,
                color: Color(0xFF737780),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.reward});

  final DeliveryReward reward;

  Color get _rankColor {
    switch (reward.sourcePrizeRank) {
      case 1: return const Color(0xFFFBBB00);
      case 2: return const Color(0xFFD223FB);
      default: return const Color(0xFF23A2FE);
    }
  }

  IconData get _rankIcon {
    return reward.sourcePrizeRank == 1
        ? Icons.emoji_events_rounded
        : Icons.military_tech_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final color = _rankColor;
    final isCount = reward.type == 'count';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_rankIcon, color: color, size: 24),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        reward.title,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xFF040707),
                        ),
                      ),
                    ),
                    _StatusBadge(status: reward.status),
                  ],
                ),
                const Gap(4),
                Text(
                  'Won in ${_formatMonth(reward.sourceMonth)}',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                const Gap(8),
                Text(
                  reward.description,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Color(0xFF363A33),
                  ),
                ),
                if (isCount) ...[
                  const Gap(10),
                  _CreditsBar(
                    remaining: reward.remainingCount ?? 0,
                    total: reward.initialCount ?? 1,
                    color: color,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatMonth(String yyyyMm) {
    if (yyyyMm.length < 7) return yyyyMm;
    final parts = yyyyMm.split('-');
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final m = int.tryParse(parts[1]) ?? 1;
    return '${months[m - 1]} ${parts[0]}';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color fg;
    final String label;
    switch (status) {
      case 'exhausted':
        bg = const Color(0xFFF5F5F5);
        fg = const Color(0xFF9E9E9E);
        label = 'Used';
        break;
      case 'expired':
        bg = const Color(0xFFFBE9E7);
        fg = const Color(0xFFE53935);
        label = 'Expired';
        break;
      default:
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Active';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w600,
          fontSize: 11,
          color: fg,
        ),
      ),
    );
  }
}

class _CreditsBar extends StatelessWidget {
  const _CreditsBar({
    required this.remaining,
    required this.total,
    required this.color,
  });

  final int remaining;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? remaining / total : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$remaining remaining',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: Color(0xFF737780),
              ),
            ),
            Text(
              '$total total',
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: Color(0xFF737780),
              ),
            ),
          ],
        ),
        const Gap(6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 6,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
