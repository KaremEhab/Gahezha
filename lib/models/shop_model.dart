enum ShopStatus { open, closed }

class ShopModel {
  final String shopName;
  final String shopLogo;
  final String shopBanner;
  final String shopCategory;
  final String shopLocation;
  final int preparingTimeFrom;
  final int preparingTimeTo;
  final int openingHoursFrom;
  final int openingHoursTo;
  final String shopPhoneNumber;
  final String shopEmail;
  final bool shopStatus;
  final bool notificationsEnabled;
  final DateTime createdAt;

  ShopModel({
    required this.shopName,
    required this.shopLogo,
    required this.shopBanner,
    required this.shopCategory,
    required this.shopLocation,
    required this.preparingTimeFrom,
    required this.preparingTimeTo,
    required this.openingHoursFrom,
    required this.openingHoursTo,
    required this.shopPhoneNumber,
    required this.shopEmail,
    required this.shopStatus,
    required this.notificationsEnabled,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'shopName': shopName,
      'shopLogo': shopLogo,
      'shopBanner': shopBanner,
      'shopCategory': shopCategory,
      'shopLocation': shopLocation,
      'preparingTimeFrom': preparingTimeFrom,
      'preparingTimeTo': preparingTimeTo,
      'openingHoursFrom': openingHoursFrom,
      'openingHoursTo': openingHoursTo,
      'shopPhoneNumber': shopPhoneNumber,
      'shopEmail': shopEmail,
      'shopStatus': shopStatus,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      shopName: map['shopName'] ?? '',
      shopLogo: map['shopLogo'] ?? '',
      shopBanner: map['shopBanner'] ?? '',
      shopCategory: map['shopCategory'] ?? '',
      shopLocation: map['shopLocation'] ?? '',
      preparingTimeFrom: map['preparingTimeFrom']?.toInt() ?? 0,
      preparingTimeTo: map['preparingTimeTo']?.toInt() ?? 0,
      openingHoursFrom: map['openingHoursFrom']?.toInt() ?? 0,
      openingHoursTo: map['openingHoursTo']?.toInt() ?? 0,
      shopPhoneNumber: map['shopPhoneNumber'] ?? '',
      shopEmail: map['shopEmail'] ?? '',
      shopStatus: map['shopStatus'] ?? false,
      notificationsEnabled: map['notificationsEnabled'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
