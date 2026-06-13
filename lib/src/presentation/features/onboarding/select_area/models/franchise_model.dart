class FranchiseModel {

  const FranchiseModel({
    required this.id,
    required this.name,
    required this.code,
    required this.area,
    required this.status,
  });

  factory FranchiseModel.fromJson(Map<String, dynamic> json) {
    final areaMap = json['area'] as Map<String, dynamic>? ?? {};
    return FranchiseModel(
      id: (json['_id'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      code: (json['code'] ?? '') as String,
      area: FranchiseArea(
        division: (areaMap['division'] ?? '') as String,
        district: (areaMap['district'] ?? '') as String,
        city: areaMap['city'] as String?,
      ),
      status: (json['status'] ?? '') as String,
    );
  }

  final String id;
  final String name;
  final String code;
  final FranchiseArea area;
  final String status;

  bool get isActive => status == 'active';

  String get displayName {
    final parts = [
      area.division,
      area.district,
      area.city,
    ].where((s) => s != null && s.isNotEmpty).toList();
    return parts.isEmpty ? name : '$name — ${parts.join(', ')}';
  }
}

class FranchiseArea {
  const FranchiseArea({
    required this.division,
    required this.district,
    this.city,
  });

  final String division;
  final String district;
  final String? city;
}
