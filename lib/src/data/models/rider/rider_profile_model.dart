class RiderProfileModel {
  const RiderProfileModel({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.userType,
    this.status,
    this.address,
    this.franchiseId,
    this.isPhoneVerified,
    this.riderInfo,
    this.lastLogin,
    this.registrationDate,
    this.lastActiveDate,
    this.createdAt,
    this.updatedAt,
  });

  factory RiderProfileModel.fromJson(Map<String, dynamic> json) {
    return RiderProfileModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      userType: json['userType'] as String?,
      status: json['status'] as String?,
      address: json['address'] == null
          ? null
          : RiderAddressModel.fromJson(json['address'] as Map<String, dynamic>),
      franchiseId: json['franchiseId'] == null
          ? null
          : RiderFranchiseModel.fromJson(
              json['franchiseId'] as Map<String, dynamic>,
            ),
      isPhoneVerified: json['isPhoneVerified'] as bool?,
      riderInfo: json['riderInfo'] == null
          ? null
          : RiderInfoModel.fromJson(json['riderInfo'] as Map<String, dynamic>),
      lastLogin: json['lastLogin'] as String?,
      registrationDate: json['registrationDate'] as String?,
      lastActiveDate: json['lastActiveDate'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? userType;
  final String? status;
  final RiderAddressModel? address;
  final RiderFranchiseModel? franchiseId;
  final bool? isPhoneVerified;
  final RiderInfoModel? riderInfo;
  final String? lastLogin;
  final String? registrationDate;
  final String? lastActiveDate;
  final String? createdAt;
  final String? updatedAt;
}

class RiderAddressModel {
  const RiderAddressModel({
    this.street,
    this.city,
    this.district,
    this.division,
  });

  factory RiderAddressModel.fromJson(Map<String, dynamic> json) {
    return RiderAddressModel(
      street: json['street'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      division: json['division'] as String?,
    );
  }

  final String? street;
  final String? city;
  final String? district;
  final String? division;
}

class RiderFranchiseModel {
  const RiderFranchiseModel({this.id, this.name});

  factory RiderFranchiseModel.fromJson(Map<String, dynamic> json) {
    return RiderFranchiseModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
    );
  }

  final String? id;
  final String? name;
}

class RiderInfoModel {
  const RiderInfoModel({
    this.vehicleType,
    this.isAvailable,
    this.rating,
    this.totalDeliveries,
    this.completedDeliveries,
    this.onTimeDeliveries,
    this.totalEarnings,
    this.totalTips,
    this.averageRating,
    this.currentStreak,
    this.longestStreak,
    this.totalWorkingHours,
  });

  factory RiderInfoModel.fromJson(Map<String, dynamic> json) {
    return RiderInfoModel(
      vehicleType: json['vehicleType'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      rating: (json['rating'] as num?)?.toDouble(),
      totalDeliveries: json['totalDeliveries'] as int?,
      completedDeliveries: json['completedDeliveries'] as int?,
      onTimeDeliveries: json['onTimeDeliveries'] as int?,
      totalEarnings: (json['totalEarnings'] as num?)?.toDouble(),
      totalTips: (json['totalTips'] as num?)?.toDouble(),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      currentStreak: json['currentStreak'] as int?,
      longestStreak: json['longestStreak'] as int?,
      totalWorkingHours: (json['totalWorkingHours'] as num?)?.toDouble(),
    );
  }

  final String? vehicleType;
  final bool? isAvailable;
  final double? rating;
  final int? totalDeliveries;
  final int? completedDeliveries;
  final int? onTimeDeliveries;
  final double? totalEarnings;
  final double? totalTips;
  final double? averageRating;
  final int? currentStreak;
  final int? longestStreak;
  final double? totalWorkingHours;
}
