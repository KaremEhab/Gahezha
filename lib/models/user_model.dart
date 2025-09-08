enum UserType { guest, customer, shop, admin }

enum Gender { male, female }

class UserModel {
  final String userId;
  final String profileUrl;
  final String firstName;
  final String lastName;
  final Gender gender;
  final String email;
  final bool notificationsEnabled;
  final UserType userType;
  final DateTime createdAt;

  UserModel({
    required this.userId,
    required this.profileUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.gender = Gender.male,
    this.notificationsEnabled = true,
    this.userType = UserType.customer,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'profileUrl': profileUrl,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender.name,
      'email': email,
      'notificationsEnabled': notificationsEnabled,
      'userType': userType.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
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
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      userType: map['userType'] != null
          ? UserType.values.firstWhere(
              (e) => e.name == map['userType'],
              orElse: () => UserType.customer,
            )
          : UserType.customer,
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
    bool? notificationsEnabled,
    UserType? userType,
    DateTime? createdAt,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      profileUrl: profileUrl ?? this.profileUrl,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GuestUserModel extends UserModel {
  static const String defaultProfileUrl =
      "https://example.com/assets/guest_avatar.png";

  final String guestId;

  GuestUserModel({
    required this.guestId,
    super.firstName = "Guest",
    super.lastName = "Account",
    super.email = "",
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
      email: map['email'] ?? "",
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
    bool? notificationsEnabled,
    DateTime? createdAt,
  }) {
    return GuestUserModel(
      guestId: guestId ?? this.guestId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
