import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer_order_model.dart';
import '../riverpod/order_review_provider.dart';

class OrderReviewDialog extends ConsumerStatefulWidget {
  const OrderReviewDialog({super.key, required this.order});

  final CustomerOrderModel order;

  @override
  ConsumerState<OrderReviewDialog> createState() => _OrderReviewDialogState();
}

class _OrderReviewDialogState extends ConsumerState<OrderReviewDialog> {
  final _pageController = PageController();
  final _foodReviewController = TextEditingController();
  final _riderReviewController = TextEditingController();
  late final ConfettiController _confettiController;

  String? _sentiment;
  int _foodRating = 0;
  int _riderRating = 0;
  int _currentPage = 0;
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _foodReviewController.dispose();
    _riderReviewController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _toPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() { _currentPage = page; _submitError = null; });
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    setState(() { _isSubmitting = true; _submitError = null; });
    try {
      await ref.read(orderReviewProvider.notifier).submitReview(
            orderId: widget.order.id,
            sentiment: _sentiment!,
            foodRating: _foodRating,
            foodReview: _foodReviewController.text.trim().isEmpty
                ? null
                : _foodReviewController.text.trim(),
            riderRating: _riderRating,
            riderReview: _riderReviewController.text.trim().isEmpty
                ? null
                : _riderReviewController.text.trim(),
          );
      _toPage(3);
    } catch (e) {
      if (mounted) {
        final detail = e.toString().replaceFirst('Exception: ', '');
        setState(() => _submitError = 'Failed: $detail');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _dismiss() {
    ref.read(orderReviewProvider.notifier).dismiss(widget.order.id);
    Navigator.of(context).pop();
  }

  void _foodNext() {
    if (_foodRating == 0) {
      setState(() => _submitError = 'Please tap the stars to rate');
      return;
    }
    setState(() => _submitError = null);
    _toPage(2);
  }

  void _riderSubmit() {
    if (_riderRating == 0) {
      setState(() => _submitError = 'Please tap the stars to rate');
      return;
    }
    _submit();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final safeBottom = MediaQuery.of(context).padding.bottom;

    final height = max(
      280.0,
      min(min(screenHeight * 0.82, 600.0), screenHeight - bottomInset - 20),
    );

    // Explicit page height so SingleChildScrollView gets a proper bound.
    // header ≈ 100px (drag + shop name + progress + close) for pages 0-2.
    final headerH = _currentPage < 3 ? 104.0 : 20.0;
    final pageHeight = max(200.0, height - safeBottom - 32.0 - headerH);

    return Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 10),
                // Order context — always visible on all steps
                if (_currentPage < 3) ...[
                  Text(
                    widget.order.shopName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    '#${widget.order.displayId}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Progress bar
                  Row(
                    children: List.generate(3, (i) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                          decoration: BoxDecoration(
                            color: i <= _currentPage
                                ? const Color(0xFF036FFD)
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _dismiss,
                      child: const Icon(
                        Icons.close,
                        size: 22,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                SizedBox(
                  height: pageHeight,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _SentimentPage(
                        selectedSentiment: _sentiment,
                        onSelected: (s) => setState(() => _sentiment = s),
                        onNext: _sentiment != null ? () => _toPage(1) : null,
                      ),
                      _RatingPage(
                        title: 'Rate the Food',
                        subtitle: _sentiment == 'loved'
                            ? 'What did you love about the food?'
                            : 'What could the food be better?',
                        rating: _foodRating,
                        controller: _foodReviewController,
                        onRatingChanged: (r) =>
                            setState(() => _foodRating = r),
                        onBack: () => _toPage(0),
                        onNext: _foodNext,
                        nextLabel: 'Next',
                        contextLabel: widget.order.shopName,
                        errorMessage: _currentPage == 1 ? _submitError : null,
                      ),
                      _RatingPage(
                        title: 'Rate the Rider',
                        subtitle: _sentiment == 'loved'
                            ? 'How was the delivery experience?'
                            : 'What went wrong with the delivery?',
                        rating: _riderRating,
                        controller: _riderReviewController,
                        onRatingChanged: (r) =>
                            setState(() => _riderRating = r),
                        onBack: () => _toPage(1),
                        onNext: !_isSubmitting ? _riderSubmit : null,
                        nextLabel:
                            _isSubmitting ? 'Submitting...' : 'Submit',
                        errorMessage: _currentPage == 2 ? _submitError : null,
                      ),
                      _CelebrationPage(
                        confettiController: _confettiController,
                        onDone: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

// ── Step 1: Sentiment ──────────────────────────────────────────────────────

class _SentimentPage extends StatelessWidget {
  const _SentimentPage({
    required this.selectedSentiment,
    required this.onSelected,
    required this.onNext,
  });

  final String? selectedSentiment;
  final ValueChanged<String> onSelected;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'How was your order?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'Share your experience with us',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SentimentButton(
              icon: Icons.thumb_up_rounded,
              label: 'Loved it',
              isSelected: selectedSentiment == 'loved',
              selectedColor: const Color(0xFF036FFD),
              onTap: () => onSelected('loved'),
            ),
            const SizedBox(width: 16),
            _SentimentButton(
              icon: Icons.thumb_down_rounded,
              label: 'Disliked',
              isSelected: selectedSentiment == 'disliked',
              selectedColor: Colors.red,
              onTap: () => onSelected('disliked'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF036FFD),
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD1D5DB),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Next',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}

class _SentimentButton extends StatelessWidget {
  const _SentimentButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor.withValues(alpha: 0.08)
              : const Color(0xFFF9FAFB),
          border: Border.all(
            color: isSelected ? selectedColor : const Color(0xFFE5E7EB),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? selectedColor : const Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? selectedColor : const Color(0xFF374151),
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Steps 2 & 3: Rating ───────────────────────────────────────────────────

class _RatingPage extends StatelessWidget {
  const _RatingPage({
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.controller,
    required this.onRatingChanged,
    required this.onBack,
    required this.onNext,
    required this.nextLabel,
    this.contextLabel,
    this.errorMessage,
  });

  final String title;
  final String subtitle;
  final int rating;
  final TextEditingController controller;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final String nextLabel;
  final String? contextLabel;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (contextLabel != null) ...[
            Row(
              children: [
                const Icon(
                  Icons.store_rounded,
                  size: 14,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 4),
                Text(
                  contextLabel!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
          ],
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
          const SizedBox(height: 14),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => onRatingChanged(i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            maxLength: 500,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: 'Write a review (optional)',
              hintStyle: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 13,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF036FFD),
                  width: 2,
                ),
              ),
              counterStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.all(10),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Color(0xFF374151), fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF036FFD),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    nextLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 14,
                  color: Color(0xFFDC2626),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Step 4: Celebration ────────────────────────────────────────────────────

class _CelebrationPage extends StatefulWidget {
  const _CelebrationPage({
    required this.confettiController,
    required this.onDone,
  });

  final ConfettiController confettiController;
  final VoidCallback onDone;

  @override
  State<_CelebrationPage> createState() => _CelebrationPageState();
}

class _CelebrationPageState extends State<_CelebrationPage> {
  @override
  void initState() {
    super.initState();
    widget.confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF036FFD),
                size: 44,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Thank you!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your review helps us improve\nfor everyone.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7280),
                height: 1.5,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF036FFD),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
        ConfettiWidget(
          confettiController: widget.confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          colors: const [
            Color(0xFF036FFD),
            Colors.orange,
            Colors.pink,
            Colors.green,
            Colors.yellow,
          ],
        ),
      ],
    );
  }
}
