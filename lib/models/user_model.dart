enum UserType { guest, customer, shop, admin }

enum UserTabType { all, blocked, reported, disabled }

enum Gender { male, female }

class UserModel {
  final String userId;
  final String profileUrl;
  final String firstName;
  final String lastName;
  final Gender gender;
  final String email;
  final String phoneNumber; // ✨ جديد
  final bool notificationsEnabled;
  final UserType userType;
  final bool blocked;
  final bool disabled;
  late bool reported;
  late int reportedCount;
  double commissionBalance; // ✅ total balance in SAR
  double paidCommissionBalance; // ✅ total balance in SAR
  List<String> referredShopIds; // ✅ shops referred by this user
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.profileUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber, // ✨ مطلوب
    this.gender = Gender.male,
    this.notificationsEnabled = true,
    this.blocked = false,
    this.disabled = false,
    this.reported = false,
    this.reportedCount = 0,
    this.userType = UserType.customer,
    this.commissionBalance = 0,
    this.paidCommissionBalance = 0,
    this.referredShopIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get fullName => '$firstName $lastName';

  double get remainingCommissionBalance =>
      commissionBalance - paidCommissionBalance;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'profileUrl': profileUrl,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.name,
      'email': email,
      'phoneNumber': phoneNumber, // ✨
      'notificationsEnabled': notificationsEnabled,
      'blocked': blocked,
      'disabled': disabled,
      'reported': reported,
      'reportedCount': reportedCount,
      'userType': userType.name,
      'commissionBalance': commissionBalance,
      'paidCommissionBalance': paidCommissionBalance,
      'referredShopIds': referredShopIds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? userId}) {
    return UserModel(
      userId: map['userId'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      gender: map['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.name == map['gender'],
              orElse: () => Gender.male,
            )
          : Gender.male,
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      blocked: map['blocked'] ?? false,
      disabled: map['disabled'] ?? false,
      reported: map['reported'] ?? false,
      reportedCount: map['reportedCount'] ?? 0,
      userType: map['userType'] != null
          ? UserType.values.firstWhere(
              (e) => e.name == map['userType'],
              orElse: () => UserType.customer,
            )
          : UserType.customer,
      commissionBalance: map['commissionBalance'] != null
          ? (map['commissionBalance'] as num).toDouble()
          : 0,
      paidCommissionBalance: map['paidCommissionBalance'] != null
          ? (map['paidCommissionBalance'] as num).toDouble()
          : 0,
      referredShopIds: map['referredShopIds'] != null
          ? List<String>.from(map['referredShopIds'])
          : [],
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// ✅ copyWith
  UserModel copyWith({
    String? userId,
    String? profileUrl,
    String? firstName,
    String? lastName,
    Gender? gender,
    String? email,
    String? phoneNumber, // ✨
    bool? notificationsEnabled,
    bool? blocked,
    bool? disabled,
    bool? reported,
    int? reportedCount,
    UserType? userType,
    double? commissionBalance,
    double? paidCommissionBalance,
    List<String>? referredShopIds,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      profileUrl: profileUrl ?? this.profileUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber, // ✨
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      blocked: blocked ?? this.blocked,
      disabled: disabled ?? this.disabled,
      reported: reported ?? this.reported,
      reportedCount: reportedCount ?? this.reportedCount,
      userType: userType ?? this.userType,
      commissionBalance: commissionBalance ?? this.commissionBalance,
      paidCommissionBalance:
          paidCommissionBalance ?? this.paidCommissionBalance,
      referredShopIds: referredShopIds ?? this.referredShopIds,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GuestUserModel extends UserModel {
  static const String defaultProfileUrl =
      "https://res.cloudinary.com/dl0wayiab/image/upload/v1757279005/samples/people/kitchen-bar.jpg";

  final String guestId;

  GuestUserModel({
    required this.guestId,
    super.firstName = "Guest",
    super.lastName = "Account",
    super.email = "",
    super.phoneNumber = "", // ✨ جديد
    super.gender = Gender.male,
    super.notificationsEnabled = true,
    super.createdAt,
  }) : super(
         userId: guestId,
         profileUrl: defaultProfileUrl,
         userType: UserType.guest,
       );

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'profileUrl': profileUrl,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.name,
      'email': email,
      'phoneNumber': phoneNumber, // ✨
      'notificationsEnabled': notificationsEnabled,
      'userType': userType.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GuestUserModel.fromMap(Map<String, dynamic> map) {
    return GuestUserModel(
      guestId: map['userId'] ?? '',
      firstName: map['firstName'] ?? "Guest",
      lastName: map['lastName'] ?? "User",
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      gender: map['gender'] != null
          ? Gender.values.firstWhere(
              (e) => e.name == map['gender'],
              orElse: () => Gender.male,
            )
          : Gender.male,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// ✅ copyWith
  GuestUserModel copyWithGuest({
    String? guestId,
    String? firstName,
    String? lastName,
    Gender? gender,
    String? email,
    String? phoneNumber, // ✨
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) {
    return GuestUserModel(
      guestId: guestId ?? this.guestId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber, // ✨
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
