import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/router/routes.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/text/typography.dart';
import '../riverpod/delete_account_provider.dart';

class AccountPrivacyScreen extends ConsumerStatefulWidget {
  const AccountPrivacyScreen({super.key});

  @override
  ConsumerState<AccountPrivacyScreen> createState() =>
      _AccountPrivacyScreenState();
}

class _AccountPrivacyScreenState extends ConsumerState<AccountPrivacyScreen> {
  static final _privacyPolicyUri = Uri.parse(
    'https://duare.net/privacy-policy',
  );
  static final _termsUri = Uri.parse('https://duare.net/terms-and-conditions');
  static final _supportUri = Uri.parse('mailto:hello@duare.net');

  @override
  void initState() {
    super.initState();
    ref.listenManual(deleteAccountProvider, (previous, next) {
      if (!mounted) return;

      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      } else if (next case AsyncData(value: true)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) context.goNamed(Routes.onboarding);
        });
      }
    });
  }

  Future<void> _open(Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open this link.')),
      );
    }
  }

  Future<void> _confirmDeletion() async {
    final confirmationController = TextEditingController();
    var canDelete = false;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const TitleText.medium('Delete account permanently?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BodyText.mediumRelaxedSecondary(
                'Your profile, saved addresses, favourites, and sign-in access '
                'will be permanently removed. Order and payment records may be '
                'retained where required for legal and business purposes.',
              ),
              Gap(context.dimensions.spacing.s16),
              const BodyText.medium('Type DELETE to confirm.'),
              Gap(context.dimensions.spacing.s8),
              TextField(
                controller: confirmationController,
                autocorrect: false,
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) {
                  setDialogState(() => canDelete = value.trim() == 'DELETE');
                },
                decoration: const InputDecoration(hintText: 'DELETE'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: canDelete
                  ? () => Navigator.of(dialogContext).pop(true)
                  : null,
              child: Text(
                'Delete permanently',
                style: context.textStyle.labelMedium.copyWith(
                  color: canDelete
                      ? context.color.error.defaultValue
                      : context.color.text.disabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    confirmationController.dispose();
    if (confirmed == true) {
      await ref.read(deleteAccountProvider.notifier).execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deletionState = ref.watch(deleteAccountProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DuareAppBar(title: 'Account & Privacy'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.dimensions.padding.p16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TitleText.medium('Legal & support'),
                      Gap(context.dimensions.spacing.s12),
                      _LinkTile(
                        title: 'Privacy Policy',
                        onTap: () => _open(_privacyPolicyUri),
                      ),
                      _LinkTile(
                        title: 'Terms & Conditions',
                        onTap: () => _open(_termsUri),
                      ),
                      _LinkTile(
                        title: 'Contact Support',
                        onTap: () => _open(_supportUri),
                      ),
                      Gap(context.dimensions.spacing.s24),
                      const TitleText.medium('Delete your account'),
                      Gap(context.dimensions.spacing.s8),
                      const BodyText.mediumRelaxedSecondary(
                        'Deletion is permanent and cannot be undone.',
                      ),
                      Gap(context.dimensions.spacing.s16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: deletionState.isLoading
                              ? null
                              : _confirmDeletion,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: context.color.error.defaultValue,
                            side: BorderSide(
                              color: context.color.error.defaultValue,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: context.dimensions.padding.p16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                context.dimensions.radius.r12,
                              ),
                            ),
                          ),
                          child: deletionState.isLoading
                              ? SizedBox.square(
                                  dimension: context.dimensions.size.s20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: context.dimensions.size.s2,
                                    color: context.color.error.defaultValue,
                                  ),
                                )
                              : const Text('Delete account'),
                        ),
                      ),
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
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.dimensions.padding.p12),
      child: Material(
        color: context.color.background.surfaceContainer,
        borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(context.dimensions.radius.r12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.dimensions.padding.p16,
              vertical: context.dimensions.padding.p16,
            ),
            child: Row(
              children: [
                Expanded(child: LabelText.large(title)),
                Icon(
                  Icons.open_in_new,
                  size: context.dimensions.size.s20,
                  color: context.color.icon.secondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
