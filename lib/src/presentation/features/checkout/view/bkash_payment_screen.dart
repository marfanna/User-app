import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/base/base.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../core/router/routes.dart';

class BkashPaymentScreen extends ConsumerStatefulWidget {
  const BkashPaymentScreen({
    super.key,
    required this.checkoutUrl,
    required this.paymentId,
    required this.orderId,
  });

  final String checkoutUrl;
  final String paymentId;
  final String orderId;

  @override
  ConsumerState<BkashPaymentScreen> createState() => _BkashPaymentScreenState();
}

class _BkashPaymentScreenState extends ConsumerState<BkashPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            if (url.contains('/payment/bkash/success')) {
              _verifyPayment();
              return NavigationDecision.prevent;
            } else if (url.contains('/payment/bkash/failure')) {
              _handleFailure('Payment failed. Please try again.');
              return NavigationDecision.prevent;
            } else if (url.contains('/payment/bkash/cancel')) {
              _handleFailure('Payment was cancelled by the user.');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  Future<void> _verifyPayment() async {
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );

    try {
      final repository = ref.read(bkashRepositoryProvider);
      final result = await repository.verifyPayment(widget.paymentId);

      // Dismiss dialog
      if (mounted && context.canPop()) context.pop();

      result.when(
        success: (data) {
          if (data?.transactionStatus == 'Completed') {
            if (mounted) {
              context.pushReplacementNamed(
                Routes.orderSuccess,
                pathParameters: {'id': widget.orderId},
              );
            }
          } else {
            _handleFailure('Payment verification failed. Status: ${data?.transactionStatus}');
          }
        },
        error: (failure) {
          _handleFailure(failure.message);
        },
      );
    } catch (e) {
      if (mounted && context.canPop()) context.pop();
      _handleFailure(e.toString());
    }
  }

  void _handleFailure(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      context.pop(); // Go back to checkout screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('bKash Payment'),
        backgroundColor: const Color(0xFFE2136E), // bKash brand color
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFE2136E),
              ),
            ),
        ],
      ),
    );
  }
}
