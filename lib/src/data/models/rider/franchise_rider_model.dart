class FranchiseRiderModel {
  const FranchiseRiderModel({this.id, this.name, this.phone});

  factory FranchiseRiderModel.fromJson(Map<String, dynamic> json) {
    return FranchiseRiderModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }

  final String? id;
  final String? name;
  final String? phone;
}
