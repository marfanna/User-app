import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../../../../../data/services/cache/cache_service.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/rounded_back_button.dart';
import '../../../../core/widgets/toast.dart';
import '../models/franchise_model.dart';
import '../riverpod/franchise_provider.dart';

class SelectAreaScreen extends ConsumerStatefulWidget {
  const SelectAreaScreen({super.key});

  @override
  ConsumerState<SelectAreaScreen> createState() => _SelectAreaScreenState();
}

class _SelectAreaScreenState extends ConsumerState<SelectAreaScreen> {
  FranchiseModel? _selected;

  @override
  void initState() {
    super.initState();
    _restoreSelection();
  }

  void _restoreSelection() {
    final cache = ref.read(cacheServiceProvider);
    final savedId = cache.get<String>(CacheKey.selectedFranchiseId);
    if (savedId != null && savedId.isNotEmpty) {
      // Will be matched when franchises load
      setState(() {});
    }
  }

  void _showPicker(List<FranchiseModel> franchises) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FranchisePicker(
        franchises: franchises,
        selected: _selected,
        onSelect: (f) {
          setState(() => _selected = f);
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (_selected == null) {
      Toast.error(context, 'Please select your area');
      return;
    }
    final cache = ref.read(cacheServiceProvider);
    await cache.save<String>(CacheKey.selectedFranchiseId, _selected!.id);
    await cache.save<String>(CacheKey.selectedFranchiseName, _selected!.name);
    if (mounted) context.goNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(franchisesProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(8),
                RoundedBackButton.primary(
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                ),
                const Gap(24),
                const Text(
                  'Please Select\nYour Area',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w700,
                    fontSize: 41,
                    height: 1.28,
                    letterSpacing: -1,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(8),
                const Text(
                  'Select the area where you are right now',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF040707),
                  ),
                ),
                const Gap(24),
                async.when(
                  loading: () =>
                      _AreaButton(label: 'Loading areas...', onTap: null),
                  error: (e, _) => _AreaButton(
                    label: 'Failed to load — tap to retry',
                    onTap: () => ref.refresh(franchisesProvider),
                  ),
                  data: (franchises) {
                    // Restore persisted selection if not yet set
                    if (_selected == null) {
                      final cache = ref.read(cacheServiceProvider);
                      final savedId = cache.get<String>(
                        CacheKey.selectedFranchiseId,
                      );
                      if (savedId != null) {
                        final match = franchises
                            .where((f) => f.id == savedId)
                            .firstOrNull;
                        if (match != null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) setState(() => _selected = match);
                          });
                        }
                      }
                    }
                    return _AreaButton(
                      label: _selected?.displayName ?? 'Area',
                      isPlaceholder: _selected == null,
                      onTap: () => _showPicker(franchises),
                    );
                  },
                ),
                const Gap(12),
                _SubmitButton(onTap: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AreaButton extends StatelessWidget {
  const _AreaButton({
    required this.label,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFD2D3D6)),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isPlaceholder
                      ? const Color(0xFF585C67)
                      : const Color(0xFF040707),
                ),
              ),
            ),
            const Icon(Icons.expand_more, color: Color(0xFF1C1B1F), size: 24),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: const RadialGradient(
            center: Alignment(-0.27, -0.27),
            radius: 1.53,
            colors: [Color(0xFF0156A7), Color(0xFF2E3293)],
          ),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Submit',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _FranchisePicker extends StatefulWidget {
  const _FranchisePicker({
    required this.franchises,
    required this.selected,
    required this.onSelect,
  });

  final List<FranchiseModel> franchises;
  final FranchiseModel? selected;
  final ValueChanged<FranchiseModel> onSelect;

  @override
  State<_FranchisePicker> createState() => _FranchisePickerState();
}

class _FranchisePickerState extends State<_FranchisePicker> {
  final _search = TextEditingController();
  List<FranchiseModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _filtered = widget.franchises;
    _search.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _search.text.toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? widget.franchises
          : widget.franchises.where((f) {
              return f.name.toLowerCase().contains(q) ||
                  f.area.division.toLowerCase().contains(q) ||
                  f.area.district.toLowerCase().contains(q) ||
                  (f.area.city?.toLowerCase().contains(q) ?? false);
            }).toList();
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD2D3D6),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _search,
              autofocus: true,
              style: const TextStyle(fontFamily: 'Manrope', fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search area...',
                hintStyle: const TextStyle(
                  fontFamily: 'Manrope',
                  color: Color(0xFF585C67),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF585C67)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFD2D3D6)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF0156A7)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No areas found',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        color: Color(0xFF585C67),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) {
                      final f = _filtered[i];
                      final isSelected = widget.selected?.id == f.id;
                      return ListTile(
                        onTap: () => widget.onSelect(f),
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF0156A7,
                            ).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xFF0156A7),
                            size: 18,
                          ),
                        ),
                        title: Text(
                          f.name,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF040707),
                          ),
                        ),
                        subtitle: Text(
                          [f.area.division, f.area.district, f.area.city]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .join(', '),
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            color: Color(0xFF585C67),
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: Color(0xFF0156A7),
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
