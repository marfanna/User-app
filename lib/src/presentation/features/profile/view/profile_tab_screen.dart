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
      if (next is AsyncData && next.value == true) {
        context.replaceNamed(Routes.onboarding);
      } else if (next is AsyncError) {
        context.replaceNamed(Routes.onboarding);
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
                        title: 'Push notification',
                        onTap: () => context.pushNamed(Routes.notifications),
                      ),
                      const Gap(16),
                      // Kept Logout Button exactly as requested
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: logoutState.isLoading
                              ? null
                              : () =>
                                    ref.read(logoutProvider.notifier).execute(),
                          icon: logoutState.isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.logout,
                                  color: Color(0xFF0156A7),
                                ),
                          label: const Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Color(0xFF0156A7),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF0156A7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
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
