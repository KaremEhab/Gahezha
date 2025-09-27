import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gahezha/models/order_model.dart';

class CartModel {
  final List<CartItem> items;

  CartModel({this.items = const []});

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  String get totalPrice => subtotal.toStringAsFixed(2);

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => CartItem.fromMap(item))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items.map((i) => i.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }
}

class CartShop {
  final String shopId;
  final OrderStatus status;
  final String shopName;
  final String shopLogo;
  final String shopPhone;
  final int preparingTimeFrom;
  final int preparingTimeTo;
  final List<CartItem> orders;

  CartShop({
    required this.shopId,
    required this.status,
    required this.shopName,
    required this.shopLogo,
    required this.shopPhone,
    required this.preparingTimeFrom,
    required this.preparingTimeTo,
    this.orders = const [],
  });

  /// ✅ Total price of this shop’s cart
  double get totalPrice =>
      orders.fold(0.0, (sum, item) => sum + item.totalPrice);

  factory CartShop.fromMap(Map<String, dynamic> map, List<CartItem> orders) {
    int statusIndex = map['statusIndex'] ?? 0;
    return CartShop(
      shopId: map['shopId'] ?? '',
      status: OrderStatus.values[statusIndex],
      shopName: map['shopName'] ?? '',
      shopLogo: map['shopLogo'] ?? '',
      shopPhone: map['shopPhoneNumber'] ?? '',
      preparingTimeFrom: map['preparingTimeFrom'] ?? 0,
      preparingTimeTo: map['preparingTimeTo'] ?? 0,
      orders: orders,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'shopId': shopId,
      'statusIndex': status.index,
      'shopName': shopName,
      'shopLogo': shopLogo,
      'shopPhoneNumber': shopPhone,
      'preparingTimeFrom': preparingTimeFrom,
      'preparingTimeTo': preparingTimeTo,
    };
  }
}

class CartItem {
  final String cartId;
  final String productId;
  final String name;
  final double basePrice;
  int quantity;
  final String productUrl;
  final List<Map<String, List<Map<String, dynamic>>>> specifications;
  final List<Map<String, dynamic>> selectedAddOns;

  CartItem({
    String? cartId,
    required this.productId,
    required this.name,
    required this.basePrice,
    this.quantity = 1,
    required this.productUrl,
    this.specifications = const [],
    this.selectedAddOns = const [],
  }) : cartId = cartId ?? '';

  double get totalPrice {
    double total = basePrice;

    // ✅ Sum all spec prices
    for (var spec in specifications) {
      for (var values in spec.values) {
        for (var value in values) {
          total += (value['price'] ?? 0.0) as double;
        }
      }
    }

    // ✅ Sum all add-on prices
    for (var addon in selectedAddOns) {
      total += (addon['price'] ?? 0.0) as double;
    }

    return total * quantity;
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    // Helper to sort the specs list
    List<Map<String, List<Map<String, dynamic>>>> sortSpecs(
      List<dynamic> specs,
    ) {
      if (specs.isEmpty) return [];

      final normalizedSpecs = specs.map((s) {
        final specMap = Map<String, dynamic>.from(s);
        return specMap.map(
          (key, value) => MapEntry(
            key,
            List<Map<String, dynamic>>.from(
              (value as List).map((e) => Map<String, dynamic>.from(e)),
            ),
          ),
        );
      }).toList();

      // Sort the main list of maps by their keys
      normalizedSpecs.sort((a, b) => a.keys.first.compareTo(b.keys.first));

      // Now, iterate through the sorted list and sort the nested values
      return normalizedSpecs.map((spec) {
        final key = spec.keys.first;
        final sortedValues = List<Map<String, dynamic>>.from(
          spec[key]!,
        )..sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
        return {key: sortedValues};
      }).toList();
    }

    // Helper to sort add-ons
    List<Map<String, dynamic>> sortAddOns(List<dynamic> addOns) {
      if (addOns.isEmpty) return [];
      final sorted = List<Map<String, dynamic>>.from(addOns)
        ..sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));
      return sorted;
    }

    return CartItem(
      cartId: map['cartId'] ?? '',
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      basePrice: (map['basePrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      productUrl: map['productUrl'] ?? '',
      specifications: sortSpecs(map['specifications'] as List? ?? []),
      selectedAddOns: sortAddOns(
        map['selectedAddOns'] as List? ?? [],
      ), // ✅ Corrected line
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId, // include in map
      'productId': productId,
      'name': name,
      'basePrice': basePrice,
      'quantity': quantity,
      'productUrl': productUrl,
      'specifications': specifications,
      'selectedAddOns': selectedAddOns,
    };
  }
}

extension CartToOrder on List<CartShop> {
  OrderModel toOrder({
    required String orderId,
    required DateTime endDate,
    required String customerId,
    required String customerFullName,
    required String customerProfileUrl,
    required String customerPhone,
  }) {
    // ✅ Collect all shopIds
    final shopIds = map((cartShop) => cartShop.shopId).toList();

    // Convert each CartShop to OrderShop
    final orderShops = map((cartShop) {
      final items = cartShop.orders.map((c) {
        return OrderItem(
          name: c.name,
          price: c.totalPrice.toStringAsFixed(2),
          extras: c.extras,
        );
      }).toList();

      return OrderShop(
        shopId: cartShop.shopId,
        status: OrderStatus.pending,
        shopName: cartShop.shopName,
        shopLogo: cartShop.shopLogo,
        shopPhone: cartShop.shopPhone,
        endDate: DateTime.now().add(
          Duration(minutes: cartShop.preparingTimeTo),
        ),
        preparingTimeFrom: cartShop.preparingTimeFrom,
        preparingTimeTo: cartShop.preparingTimeTo,
        items: items,
        shopTotalPrice: cartShop.totalPrice.toStringAsFixed(2),
      );
    }).toList();

    // ✅ Calculate total order price
    final total = orderShops.fold<double>(
      0.0,
      (sum, s) => sum + double.parse(s.shopTotalPrice),
    );

    return OrderModel(
      id: orderId,
      startDate: DateTime.now(),
      shopIds: shopIds,
      shops: orderShops,
      totalPrice: total.toStringAsFixed(2),
      customerId: customerId,
      customerFullName: customerFullName,
      customerProfileUrl: customerProfileUrl,
      customerPhone: customerPhone,
    );
  }
}

extension CartItemExtras on CartItem {
  List<String> get extras {
    final List<String> result = [];

    // ✅ Specifications: include first option if none selected
    for (var spec in specifications) {
      final key = spec.keys.first;
      final values = spec[key]!;

      if (values.isEmpty) continue;

      // Always take the first option
      final firstValue = values.first;

      if (firstValue['name'] != null &&
          firstValue['name'].toString().isNotEmpty) {
        result.add(firstValue['name'].toString());
      }
    }

    // ✅ Add-ons
    for (var addon in selectedAddOns) {
      if (addon['name'] != null && addon['name'].toString().isNotEmpty) {
        result.add(addon['name'].toString());
      }
    }

    return result;
  }
}
