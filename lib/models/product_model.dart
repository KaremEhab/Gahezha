import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String shopId; // 👈 Added shopId
  final String name;
  final String description;
  final int quantity;
  final double price;
  final List<Map<String, List<Map<String, dynamic>>>> specifications;
  final List<Map<String, dynamic>> selectedAddOns;
  final List<String> images;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.shopId,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.specifications,
    required this.selectedAddOns,
    required this.images,
    required this.createdAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      shopId: map['shopId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      specifications:
          (map['specifications'] as List?)?.map((s) {
            final specMap = Map<String, dynamic>.from(s);
            return specMap.map(
              (key, value) => MapEntry(
                key,
                List<Map<String, dynamic>>.from(
                  (value as List).map((e) => Map<String, dynamic>.from(e)),
                ),
              ),
            );
          }).toList() ??
          [],

      selectedAddOns: List<Map<String, dynamic>>.from(
        map['selectedAddOns'] ?? [],
      ),
      images: List<String>.from(map['images'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// ✅ Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'shopId': shopId,
      'name': name,
      'description': description,
      'quantity': quantity,
      'price': price,
      'specifications': specifications,
      'selectedAddOns': selectedAddOns,
      'images': images,
      'createdAt': createdAt, // ✅ include timestamp
    };
  }

  /// ✅ Calculate the total price for this product
  double calculateTotalPrice({
    required Map<String, String> selectedSpecs,
    required Map<String, bool> addOns,
    int quantity = 1,
  }) {
    double total = price;

    // Add specification extra prices
    for (var spec in specifications) {
      final key = spec.keys.first;
      final values = spec[key] ?? [];
      final selectedName = selectedSpecs[key];

      final selectedValue = values.firstWhere(
        (v) => v["name"] == selectedName,
        orElse: () => {}, // 👈 prevent crash if not found
      );

      if (selectedValue.isNotEmpty) {
        total += (selectedValue["price"] ?? 0.0) as double;
      }
    }

    // Add selected add-ons
    for (var entry in addOns.entries) {
      if (entry.value) {
        final addon = selectedAddOns.firstWhere(
          (a) => a["name"] == entry.key,
          orElse: () => {},
        );
        if (addon.isNotEmpty) {
          total += (addon["price"] ?? 0.0) as double;
        }
      }
    }

    return total * quantity;
  }
}
