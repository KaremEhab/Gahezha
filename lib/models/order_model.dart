import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';

enum OrderStatus { pending, accepted, rejected, preparing, pickup, delivered }

class OrderModel {
  final String id;
  final DateTime startDate;
  final List<String> shopIds;
  final List<OrderShop> shops;
  final String totalPrice;
  final String customerId;
  final String customerFullName;
  final String customerProfileUrl;
  final String customerPhone;

  OrderModel({
    required this.id,
    required this.startDate,
    required this.shopIds,
    required this.shops,
    required this.totalPrice,
    required this.customerId,
    required this.customerFullName,
    required this.customerProfileUrl,
    required this.customerPhone,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      shopIds: List<String>.from(map['shopIds'] ?? []),
      shops: (map['shops'] as List<dynamic>? ?? [])
          .map((shop) => OrderShop.fromMap(shop))
          .toList(),
      totalPrice: map['totalPrice'] ?? '0.0',
      customerId: map['customerId'] ?? '',
      customerFullName: map['customerFullName'] ?? '',
      customerProfileUrl: map['customerProfileUrl'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'startDate': Timestamp.fromDate(startDate),
    'shopIds': shopIds,
    'shops': shops.map((s) => s.toMap()).toList(),
    'totalPrice': totalPrice,
    'customerId': customerId,
    'customerFullName': customerFullName,
    'customerProfileUrl': customerProfileUrl,
    'customerPhone': customerPhone,
  };

  /// Localized status for UI
  static String getLocalizedStatus(BuildContext context, OrderStatus status) {
    switch (status) {
      case OrderStatus.accepted:
        return S.of(context).accepted;
      case OrderStatus.rejected:
        return S.of(context).rejected;
      case OrderStatus.preparing:
        return S.of(context).preparing;
      case OrderStatus.pickup:
        return S.of(context).pickup;
      case OrderStatus.delivered:
        return S.of(context).delivered;
      default:
        return S.of(context).pending;
    }
  }

  /// Helper: remaining time
  Duration get remainingTime {
    late Duration timeLeft;
    for (int i = 0; i < shops.length; i++) {
      timeLeft = shops[i].endDate.difference(DateTime.now());
    }
    return timeLeft;
  }
}

class OrderShop {
  final String shopId;
  final OrderStatus status;
  final String shopName;
  final String shopLogo;
  final String shopPhone;
  final DateTime endDate;
  final int preparingTimeFrom;
  final int preparingTimeTo;
  final List<OrderItem> items;
  final String shopTotalPrice;

  OrderShop({
    required this.shopId,
    required this.status,
    required this.shopName,
    required this.shopLogo,
    required this.shopPhone,
    required this.endDate,
    required this.preparingTimeFrom,
    required this.preparingTimeTo,
    required this.items,
    required this.shopTotalPrice,
  });

  factory OrderShop.fromMap(Map<String, dynamic> map) {
    int statusIndex = map['statusIndex'] ?? 0;
    return OrderShop(
      shopId: map['shopId'] ?? '',
      status: OrderStatus.values[statusIndex],
      shopName: map['shopName'] ?? '',
      shopLogo: map['shopLogo'] ?? '',
      shopPhone: map['shopPhone'] ?? '',
      endDate:
          (map['endDate'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(minutes: 30)),
      preparingTimeFrom: map['preparingTimeFrom'] ?? 0,
      preparingTimeTo: map['preparingTimeTo'] ?? 0,
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      shopTotalPrice: map['shopTotalPrice'] ?? '0.0',
    );
  }

  Map<String, dynamic> toMap() => {
    'shopId': shopId,
    'statusIndex': status.index,
    'shopName': shopName,
    'shopLogo': shopLogo,
    'shopPhone': shopPhone,
    'endDate': Timestamp.fromDate(endDate),
    'preparingTimeFrom': preparingTimeFrom,
    'preparingTimeTo': preparingTimeTo,
    'items': items.map((i) => i.toMap()).toList(),
    'shopTotalPrice': shopTotalPrice,
  };
}

class OrderItem {
  final String name;
  final String price;
  final List<String> extras;

  OrderItem({required this.name, required this.price, this.extras = const []});

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      extras: List<String>.from(map['extras'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'price': price, 'extras': extras};
  }
}
