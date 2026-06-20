import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';
import '../../../../data/services/network/endpoints.dart';

part 'dispute_provider.g.dart';

// ── Category ─────────────────────────────────────────────────────────────────

enum DisputeCategory {
  missingItem,
  wrongItem,
  qualityIssue,
  lateDelivery,
  other;

  String get apiValue => switch (this) {
        DisputeCategory.missingItem => 'missing_item',
        DisputeCategory.wrongItem => 'wrong_item',
        DisputeCategory.qualityIssue => 'quality_issue',
        DisputeCategory.lateDelivery => 'late_delivery',
        DisputeCategory.other => 'other',
      };

  String get label => switch (this) {
        DisputeCategory.missingItem => 'Missing Item',
        DisputeCategory.wrongItem => 'Wrong Item',
        DisputeCategory.qualityIssue => 'Quality Issue',
        DisputeCategory.lateDelivery => 'Late Delivery',
        DisputeCategory.other => 'Other',
      };
}

// ── State ─────────────────────────────────────────────────────────────────────

class DisputeState {
  const DisputeState({
    this.uploadingIndex = -1,
    this.photoUrls = const [],
    this.isSubmitting = false,
    this.error,
  });

  final int uploadingIndex;
  final List<String> photoUrls;
  final bool isSubmitting;
  final String? error;

  bool get isUploading => uploadingIndex >= 0;

  DisputeState copyWith({
    int? uploadingIndex,
    List<String>? photoUrls,
    bool? isSubmitting,
    String? error,
  }) =>
      DisputeState(
        uploadingIndex: uploadingIndex ?? this.uploadingIndex,
        photoUrls: photoUrls ?? this.photoUrls,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        error: error,
      );
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class DisputeNotifier extends _$DisputeNotifier {
  @override
  DisputeState build() => const DisputeState();

  Future<void> uploadPhoto(File file, int index) async {
    state = state.copyWith(uploadingIndex: index, error: null);
    try {
      final dio = ref.read(dioProvider);
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });
      final response = await dio.post('upload/single', data: formData);
      final data = response.data['data'] as Map<String, dynamic>?;
      final url =
          data?['url'] as String? ?? data?['imageUrl'] as String?;
      if (url == null) throw Exception('Upload returned no URL');
      final updated = List<String>.from(state.photoUrls)..add(url);
      state = state.copyWith(uploadingIndex: -1, photoUrls: updated);
    } catch (_) {
      state = state.copyWith(
        uploadingIndex: -1,
        error: 'Photo upload failed. Try again.',
      );
    }
  }

  void removePhoto(int index) {
    final updated = List<String>.from(state.photoUrls)..removeAt(index);
    state = state.copyWith(photoUrls: updated, error: null);
  }

  Future<bool> submit({
    required String orderId,
    required DisputeCategory category,
    required String description,
  }) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      final dio = ref.read(dioProvider);
      final endpoint =
          Endpoints.createDispute.replaceFirst('{orderId}', orderId);
      await dio.post(endpoint, data: {
        'category': category.apiValue,
        'description': description,
        'evidencePhotos': state.photoUrls,
      });
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: _extractMessage(e),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);

  void setError(String message) => state = state.copyWith(error: message);

  String _extractMessage(Object e) {
    final str = e.toString();
    if (str.contains('Dispute window has closed')) {
      return 'Dispute window has closed (2 hours after delivery)';
    }
    if (str.contains('already')) {
      return 'A dispute already exists for this order';
    }
    return 'Failed to submit dispute. Please try again.';
  }
}

// ── Ticket model ─────────────────────────────────────────────────────────────

class DisputeTicket {
  const DisputeTicket({
    required this.id,
    required this.category,
    required this.description,
    required this.status,
    required this.createdAt,
    this.orderId,
    this.shopName,
    this.resolutionType,
    this.resolutionNotes,
  });

  final String id;
  final String category;
  final String description;
  final String status;
  final DateTime createdAt;
  final String? orderId;
  final String? shopName;
  final String? resolutionType;
  final String? resolutionNotes;

  factory DisputeTicket.fromJson(Map<String, dynamic> json) {
    final orderRaw = json['orderId'];
    final shopRaw = json['shopId'];
    final resolution = json['resolution'] as Map<String, dynamic>?;
    return DisputeTicket(
      id: json['_id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
      createdAt: DateTime.tryParse(
            json['createdAt'] as String? ?? '',
          ) ??
          DateTime.now(),
      orderId: orderRaw is Map ? orderRaw['orderId'] as String? : null,
      shopName: shopRaw is Map ? shopRaw['name'] as String? : null,
      resolutionType: resolution?['type'] as String?,
      resolutionNotes: resolution?['notes'] as String?,
    );
  }

  String get categoryLabel => switch (category) {
        'missing_item' => 'Missing Item',
        'wrong_item' => 'Wrong Item',
        'quality_issue' => 'Quality Issue',
        'late_delivery' => 'Late Delivery',
        _ => 'Other',
      };

  bool get isOpen => status == 'open' || status == 'under_review';
}

// ── My disputes provider ──────────────────────────────────────────────────────

@riverpod
Future<List<DisputeTicket>> myDisputes(Ref ref) async {
  final dio = ref.read(dioProvider);
  final response = await dio.get(Endpoints.myDisputes);
  final body = response.data as Map<String, dynamic>;
  final raw = body['data'];
  final list = raw is List ? raw : <dynamic>[];
  return list
      .whereType<Map<String, dynamic>>()
      .map(DisputeTicket.fromJson)
      .toList();
}
