import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/widgets/gradient_background.dart';
import '../../../core/widgets/app_bar/duare_app_bar.dart';
import '../../../core/widgets/button/primary_gradient_button.dart';
import '../riverpod/dispute_provider.dart';

class DisputeScreen extends ConsumerStatefulWidget {
  const DisputeScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends ConsumerState<DisputeScreen> {
  int _step = 0; // 0 = category, 1 = details, 2 = success
  DisputeCategory? _category;
  final _descController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final state = ref.read(disputeProvider);
    if (state.photoUrls.length >= 5 || state.isUploading) return;

    final xFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xFile == null) return;

    final index = state.photoUrls.length;
    await ref
        .read(disputeProvider.notifier)
        .uploadPhoto(File(xFile.path), index);
  }

  Future<void> _submit() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ref
          .read(disputeProvider.notifier)
          .setError('Please describe the issue before submitting.');
      return;
    }
    final ok = await ref.read(disputeProvider.notifier).submit(
          orderId: widget.orderId,
          category: _category!,
          description: desc,
        );
    if (ok && mounted) setState(() => _step = 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              DuareAppBar(
                title: 'Help',
                onBackPressed: _step == 1
                    ? () => setState(() => _step = 0)
                    : () => context.pop(),
              ),
              if (_step < 2) _buildProgressBar(),
              Expanded(child: _buildStep()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: List.generate(2, (i) {
          return Expanded(
            child: Container(
              height: 4,
              margin: EdgeInsets.only(right: i < 1 ? 6 : 0),
              decoration: BoxDecoration(
                color: i <= _step
                    ? const Color(0xFF036FFD)
                    : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep() {
    return switch (_step) {
      0 => _CategoryStep(
          selected: _category,
          onSelected: (c) {
            setState(() {
              _category = c;
              _step = 1;
            });
          },
        ),
      1 => _DetailsStep(
          category: _category!,
          descController: _descController,
          onPickImage: _pickImage,
          onSubmit: _submit,
          onRemovePhoto: (i) =>
              ref.read(disputeProvider.notifier).removePhoto(i),
        ),
      _ => const _SuccessStep(),
    };
  }
}

// ── Step 1: Category ──────────────────────────────────────────────────────────

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({required this.selected, required this.onSelected});

  final DisputeCategory? selected;
  final ValueChanged<DisputeCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What went wrong?',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Color(0xFF040707),
            ),
          ),
          const Gap(4),
          const Text(
            'Select the issue with your order',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: Color(0xFF6B6E82),
            ),
          ),
          const Gap(20),
          ...DisputeCategory.values.map(
            (c) => _CategoryTile(
              category: c,
              isSelected: selected == c,
              onTap: () => onSelected(c),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final DisputeCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  IconData get _icon => switch (category) {
        DisputeCategory.missingItem => Icons.remove_shopping_cart_outlined,
        DisputeCategory.wrongItem => Icons.swap_horiz_rounded,
        DisputeCategory.qualityIssue => Icons.sentiment_dissatisfied_outlined,
        DisputeCategory.lateDelivery => Icons.timer_off_outlined,
        DisputeCategory.other => Icons.help_outline_rounded,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF036FFD).withValues(alpha: 0.06)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF036FFD)
                : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _icon,
              size: 22,
              color: isSelected
                  ? const Color(0xFF036FFD)
                  : const Color(0xFF6B6E82),
            ),
            const Gap(12),
            Expanded(
              child: Text(
                category.label,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: isSelected
                      ? const Color(0xFF036FFD)
                      : const Color(0xFF040707),
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isSelected
                  ? const Color(0xFF036FFD)
                  : const Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Details ───────────────────────────────────────────────────────────

class _DetailsStep extends ConsumerWidget {
  const _DetailsStep({
    required this.category,
    required this.descController,
    required this.onPickImage,
    required this.onSubmit,
    required this.onRemovePhoto,
  });

  final DisputeCategory category;
  final TextEditingController descController;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;
  final ValueChanged<int> onRemovePhoto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(disputeProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.label,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(4),
                const Text(
                  'Describe what happened',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Color(0xFF6B6E82),
                  ),
                ),
                const Gap(20),
                // Description
                TextField(
                  controller: descController,
                  maxLines: 5,
                  maxLength: 500,
                  onTapOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Tell us more about the issue...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF036FFD),
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    counterStyle:
                        const TextStyle(color: Color(0xFF9CA3AF)),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const Gap(20),
                // Photo upload
                const Text(
                  'Add Photos (optional, max 5)',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(10),
                _PhotoGrid(
                  photoUrls: state.photoUrls,
                  isUploading: state.isUploading,
                  uploadingIndex: state.uploadingIndex,
                  onAdd: state.photoUrls.length < 5 ? onPickImage : null,
                  onRemove: onRemovePhoto,
                ),
                if (state.error != null) ...[
                  const Gap(12),
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 14,
                        color: Color(0xFFDC2626),
                      ),
                      const Gap(4),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        // Submit button
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: PrimaryGradientButton(
            text: state.isSubmitting ? 'Submitting...' : 'Submit Dispute',
            height: 52,
            borderRadius: 12,
            onPressed:
                state.isSubmitting || state.isUploading ? null : onSubmit,
          ),
        ),
      ],
    );
  }
}

class _PhotoGrid extends StatelessWidget {
  const _PhotoGrid({
    required this.photoUrls,
    required this.isUploading,
    required this.uploadingIndex,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> photoUrls;
  final bool isUploading;
  final int uploadingIndex;
  final VoidCallback? onAdd;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...List.generate(photoUrls.length, (i) {
          final isThisUploading = isUploading && uploadingIndex == i;
          return _PhotoThumbnail(
            url: photoUrls[i],
            isLoading: isThisUploading,
            onRemove: () => onRemove(i),
          );
        }),
        if (isUploading && uploadingIndex == photoUrls.length)
          const _UploadingTile(),
        if (onAdd != null && !isUploading)
          _AddPhotoTile(onTap: onAdd!),
      ],
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({
    required this.url,
    required this.isLoading,
    required this.onRemove,
  });

  final String url;
  final bool isLoading;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFFDC2626),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadingTile extends StatelessWidget {
  const _UploadingTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Color(0xFF036FFD),
          ),
        ),
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF036FFD),
            style: BorderStyle.solid,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: Color(0xFF036FFD),
              size: 24,
            ),
            Gap(4),
            Text(
              'Add',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF036FFD),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Step 3: Success ───────────────────────────────────────────────────────────

class _SuccessStep extends StatelessWidget {
  const _SuccessStep();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF036FFD),
              size: 48,
            ),
          ),
          const Gap(20),
          const Text(
            'Dispute Submitted',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              color: Color(0xFF040707),
            ),
          ),
          const Gap(8),
          const Text(
            'Our team will review your issue and get back to you within 24 hours.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF6B6E82),
            ),
          ),
          const Gap(32),
          PrimaryGradientButton(
            text: 'Back to Orders',
            height: 52,
            borderRadius: 12,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
