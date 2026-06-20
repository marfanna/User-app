import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../riverpod/dispute_provider.dart';

class DisputeListScreen extends ConsumerStatefulWidget {
  const DisputeListScreen({super.key});

  @override
  ConsumerState<DisputeListScreen> createState() => _DisputeListScreenState();
}

class _DisputeListScreenState extends ConsumerState<DisputeListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disputesAsync = ref.watch(myDisputesProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              DuareAppBar(
                title: 'My Disputes',
                onBackPressed: () => context.pop(),
              ),
              _buildTabBar(),
              Expanded(
                child: disputesAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF036FFD),
                    ),
                  ),
                  error: (e, _) => _ErrorView(
                    onRetry: () => ref.invalidate(myDisputesProvider),
                  ),
                  data: (tickets) => RefreshIndicator(
                    color: const Color(0xFF036FFD),
                    onRefresh: () async {
                      ref.invalidate(myDisputesProvider);
                      await ref.read(myDisputesProvider.future);
                    },
                    child: TabBarView(
                    controller: _tabs,
                    children: [
                      _TicketList(tickets: tickets, filter: null),
                      _TicketList(
                        tickets: tickets,
                        filter: (t) => t.isOpen,
                      ),
                      _TicketList(
                        tickets: tickets,
                        filter: (t) => !t.isOpen,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabs,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Active'),
          Tab(text: 'Past'),
        ],
        labelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Manrope',
          fontWeight: FontWeight.w500,
          fontSize: 13,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: const Color(0xFF6B6E82),
        indicator: BoxDecoration(
          color: const Color(0xFF036FFD),
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(4),
      ),
    );
  }
}

class _TicketList extends StatelessWidget {
  const _TicketList({required this.tickets, required this.filter});

  final List<DisputeTicket> tickets;
  final bool Function(DisputeTicket)? filter;

  @override
  Widget build(BuildContext context) {
    final filtered =
        filter == null ? tickets : tickets.where(filter!).toList();

    if (filtered.isEmpty) {
      return const _EmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: filtered.length,
      separatorBuilder: (_, _) => const Gap(10),
      itemBuilder: (_, i) => _TicketCard(ticket: filtered[i]),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final DisputeTicket ticket;

  Color get _statusColor => ticket.isOpen
      ? const Color(0xFFF59E0B)
      : const Color(0xFF10B981);

  String get _statusLabel {
    return switch (ticket.status) {
      'open' => 'Open',
      'under_review' => 'Under Review',
      'resolved' => 'Resolved',
      'rejected' => 'Rejected',
      _ => ticket.status,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket.categoryLabel,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Color(0xFF040707),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _statusLabel,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    color: _statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (ticket.shopName != null) ...[
            const Gap(4),
            Text(
              ticket.shopName!,
              style: const TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                color: Color(0xFF6B6E82),
              ),
            ),
          ],
          const Gap(8),
          Text(
            ticket.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              height: 1.4,
              color: Color(0xFF374151),
            ),
          ),
          if (ticket.resolutionNotes != null) ...[
            const Gap(8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF10B981), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 14,
                    color: Color(0xFF10B981),
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      ticket.resolutionNotes!,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const Gap(10),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 12,
                color: Color(0xFF9CA3AF),
              ),
              const Gap(4),
              Text(
                DateFormat('d MMM yyyy, h:mm a').format(ticket.createdAt),
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              if (ticket.orderId != null) ...[
                const Gap(12),
                const Icon(
                  Icons.receipt_outlined,
                  size: 12,
                  color: Color(0xFF9CA3AF),
                ),
                const Gap(4),
                Text(
                  '#${ticket.orderId}',
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 36,
              color: Color(0xFF9CA3AF),
            ),
          ),
          const Gap(16),
          const Text(
            'No tickets yet',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF040707),
            ),
          ),
          const Gap(6),
          const Text(
            'Dispute tickets will appear here',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              color: Color(0xFF6B6E82),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Color(0xFF9CA3AF),
          ),
          const Gap(12),
          const Text(
            'Failed to load disputes',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF374151),
            ),
          ),
          const Gap(12),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              'Try again',
              style: TextStyle(color: Color(0xFF036FFD)),
            ),
          ),
        ],
      ),
    );
  }
}
