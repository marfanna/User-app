import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/routes.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../riverpod/logout_provider.dart';

class ProfileTabScreen extends ConsumerStatefulWidget {
  const ProfileTabScreen({super.key});

  @override
  ConsumerState<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends ConsumerState<ProfileTabScreen> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(logoutProvider, (previous, next) {
      // goNamed (not replaceNamed): we're inside the StatefulShellRoute,
      // and /onboarding is a root route. replaceNamed only swaps the top
      // of the shell branch stack and won't exit the shell — go() rebuilds
      // the whole route tree from root and leaves the shell cleanly.
      // Defer to next frame so GoRouter doesn't drop the nav when it's
      // fired during the provider-notification cycle.
      final done = (next is AsyncData && next.value == true) ||
          next is AsyncError;
      if (done) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.goNamed(Routes.onboarding);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final logoutState = ref.watch(logoutProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DuareAppBar(title: 'Account'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const Gap(16),
                      _buildMenuItem(
                        title: 'My Balance',
                        trailing: const Text(
                          'BDT 0',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFF0156A7),
                          ),
                        ),
                      ),
                      _buildMenuItem(
                        title: 'Delivery Address',
                        onTap: () => context.pushNamed(Routes.addressBook),
                      ),
                      _buildMenuItem(title: 'Coupon', onTap: () {}),
                      _buildMenuItem(
                        title: 'Edit Profile',
                        onTap: () => context.pushNamed(Routes.editProfile),
                      ),
                      _buildMenuItem(title: 'Order On Whatsapp', onTap: () {}),
                      _buildMenuItem(title: 'Request a Product', onTap: () {}),
                      _buildMenuItem(
                        title: 'My Favourite',
                        onTap: () => context.pushNamed(Routes.favourites),
                      ),
                      _buildMenuItem(
                        title: 'My Rewards',
                        onTap: () => context.pushNamed(Routes.myRewards),
                      ),
                      _buildMenuItem(
                        title: 'My Disputes',
                        onTap: () => context.pushNamed(Routes.disputes),
                      ),
                      _buildMenuItem(
                        title: 'Push notification',
                        onTap: () => context.pushNamed(Routes.notifications),
                      ),
                      const Gap(16),
                      // Kept Logout Button exactly as requested
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: logoutState.isLoading
                              ? null
                              : () =>
                                    ref.read(logoutProvider.notifier).execute(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF0156A7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: logoutState.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF0156A7),
                                  ),
                                )
                              : const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: Color(0xFF0156A7),
                                  ),
                                ),
                        ),
                      ),
                      const Gap(32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF040707),
                  ),
                ),
                trailing ??
                    const Icon(Icons.chevron_right, color: Color(0xFF040707)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
