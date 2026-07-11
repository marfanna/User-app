import 'package:flutter/material.dart';

import '../riverpod/monthly_winners_provider.dart';

/// Monthly winners celebration popup — last month's masked top-3 customers.
/// Shown once per month from the home screen (see RestaurantsHomeScreen).
class MonthlyWinnersDialog extends StatelessWidget {
  const MonthlyWinnersDialog({super.key, required this.data});

  final MonthlyWinnersData data;

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static const _rankColors = {
    1: Color(0xFFF5B301), // gold
    2: Color(0xFF9AA5B1), // silver
    3: Color(0xFFCD7F32), // bronze
  };

  String _monthLabel(String m) {
    final parts = m.split('-');
    if (parts.length != 2) return m;
    final year = int.tryParse(parts[0]);
    final mon = int.tryParse(parts[1]);
    if (year == null || mon == null || mon < 1 || mon > 12) return m;
    return '${_months[mon - 1]} $year';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F46E5), Color(0xFF036FFD)],
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 40),
                const SizedBox(height: 8),
                const Text(
                  'Monthly Champions',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Top customers of ${_monthLabel(data.month)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Winners
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final w in data.winners) ...[
                  _WinnerRow(
                    winner: w,
                    color: _rankColors[w.rank] ?? _rankColors[3]!,
                  ),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 2),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF036FFD),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Awesome!'),
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

class _WinnerRow extends StatelessWidget {
  const _WinnerRow({required this.winner, required this.color});

  final MonthlyWinner winner;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final subtitle = winner.prizeAwarded != null
        ? '${winner.points} pts · ${winner.prizeAwarded}'
        : '${winner.points} pts';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Icon(Icons.emoji_events, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  winner.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '#${winner.rank}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
