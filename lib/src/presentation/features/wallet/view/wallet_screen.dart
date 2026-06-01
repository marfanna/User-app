import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/rounded_back_button.dart';
import '../../../core/widgets/text/typography.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton.primary(),
        title: TitleText.large('Wallet & Payments'),
        centerTitle: true,
      ),
      body: Center(
        child: BodyText.medium('Wallet and Payment options will be here.'),
      ),
    );
  }
}
