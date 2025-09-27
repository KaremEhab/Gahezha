import 'package:cloud_firestore/cloud_firestore.dart';

enum ShopStatus { open, closed }

enum ShopAcceptanceStatus { pending, accepted, rejected }

class ShopModel {
  final String id;
  final String shopName;
  final String shopLogo;
  final String shopBanner;
  final String shopCategory;
  final String shopLocation;
  final int preparingTimeFrom;
  final int preparingTimeTo;
  final int openingHoursFrom;
  final int openingHoursTo;
  final num shopRate;
  final String shopPhoneNumber;
  final String shopEmail;
  final ShopAcceptanceStatus shopAcceptanceStatus;
  final bool shopStatus;
  final bool blocked;
  final bool disabled;
  late bool reported;
  late int reportedCount;
  final bool notificationsEnabled;
  final String? referredByUserId; // ✅ who referred this shop
  final DateTime createdAt;

  ShopModel({
    required this.id,
    required this.shopName,
    required this.shopLogo,
    required this.shopBanner,
    required this.shopCategory,
    required this.shopLocation,
    required this.preparingTimeFrom,
    required this.preparingTimeTo,
    required this.openingHoursFrom,
    required this.openingHoursTo,
    required this.shopRate,
    required this.shopPhoneNumber,
    required this.shopEmail,
    required this.shopAcceptanceStatus,
    required this.shopStatus,
    required this.blocked,
    required this.disabled,
    this.reported = false,
    this.reportedCount = 0,
    required this.notificationsEnabled,
    required this.referredByUserId,
    required this.createdAt,
  });

  /// --- CopyWith method ---
  ShopModel copyWith({
    String? id,
    String? shopName,
    String? shopLogo,
    String? shopBanner,
    String? shopCategory,
    String? shopLocation,
    int? preparingTimeFrom,
    int? preparingTimeTo,
    int? openingHoursFrom,
    int? openingHoursTo,
    num? shopRate,
    String? shopPhoneNumber,
    String? shopEmail,
    ShopAcceptanceStatus? shopAcceptanceStatus,
    bool? shopStatus,
    bool? blocked,
    bool? disabled,
    bool? reported,
    int? reportedCount,
    bool? notificationsEnabled,
    String? referredByUserId,
    DateTime? createdAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      shopLogo: shopLogo ?? this.shopLogo,
      shopBanner: shopBanner ?? this.shopBanner,
      shopCategory: shopCategory ?? this.shopCategory,
      shopLocation: shopLocation ?? this.shopLocation,
      preparingTimeFrom: preparingTimeFrom ?? this.preparingTimeFrom,
      preparingTimeTo: preparingTimeTo ?? this.preparingTimeTo,
      openingHoursFrom: openingHoursFrom ?? this.openingHoursFrom,
      openingHoursTo: openingHoursTo ?? this.openingHoursTo,
      shopRate: shopRate ?? this.shopRate,
      shopPhoneNumber: shopPhoneNumber ?? this.shopPhoneNumber,
      shopEmail: shopEmail ?? this.shopEmail,
      shopAcceptanceStatus: shopAcceptanceStatus ?? this.shopAcceptanceStatus,
      shopStatus: shopStatus ?? this.shopStatus,
      blocked: blocked ?? this.blocked,
      disabled: disabled ?? this.disabled,
      reported: reported ?? this.reported,
      reportedCount: reportedCount ?? this.reportedCount,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      referredByUserId: referredByUserId ?? this.referredByUserId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

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
      'shopRate': shopRate,
      'shopPhoneNumber': shopPhoneNumber,
      'shopEmail': shopEmail,
      'shopStatus': shopStatus,
      'blocked': blocked,
      'disabled': disabled,
      'reported': reported,
      'reportedCount': reportedCount,
      'notificationsEnabled': notificationsEnabled,
      'shopAcceptanceStatus': shopAcceptanceStatus.index,
      'referredByUserId': referredByUserId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ShopModel(
      id: id ?? '',
      shopName: map['shopName'] ?? '',
      shopLogo: map['shopLogo'] ?? '',
      shopBanner: map['shopBanner'] ?? '',
      shopCategory: map['shopCategory'] ?? '',
      shopLocation: map['shopLocation'] ?? '',
      preparingTimeFrom: map['preparingTimeFrom']?.toInt() ?? 0,
      preparingTimeTo: map['preparingTimeTo']?.toInt() ?? 0,
      openingHoursFrom: map['openingHoursFrom']?.toInt() ?? 0,
      openingHoursTo: map['openingHoursTo']?.toInt() ?? 0,
      shopRate: (map['shopRate'] is int)
          ? (map['shopRate'] as int).toDouble()
          : (map['shopRate'] ?? 0.0).toDouble(),
      shopPhoneNumber: map['shopPhoneNumber'] ?? '',
      shopEmail: map['shopEmail'] ?? '',
      shopStatus: map['shopStatus'] ?? false,
      blocked: map['blocked'] ?? false,
      disabled: map['disabled'] ?? false,
      reported: map['reported'] ?? false,
      reportedCount: map['reportedCount'] ?? 0,
      notificationsEnabled: map['notificationsEnabled'] ?? false,
      shopAcceptanceStatus:
          ShopAcceptanceStatus.values[map['shopAcceptanceStatus'] ?? 0],
      referredByUserId: map['referredByUserId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
