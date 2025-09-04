enum OrderStatus { pending, accepted, rejected, pickup, delivered }

class OrderModel {
  final String id;
  final OrderStatus status;
  final DateTime date;
  final List<OrderItem> items; // ✅ multiple items instead of single label
  final String totalPrice; // ✅ final total

  OrderModel({
    required this.id,
    required this.status,
    required this.date,
    required this.items,
    required this.totalPrice,
  });

  // Convert Firestore/JSON → OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      status: _statusFromString(map['status'] ?? 'pending'),
      date: map['date'] is DateTime
          ? map['date']
          : DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      items: (map['items'] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      totalPrice: map['totalPrice'] ?? '',
    );
  }

  // Convert OrderModel → JSON/Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status.name,
      'date': date.toIso8601String(),
      'items': items.map((i) => i.toMap()).toList(),
      'totalPrice': totalPrice,
    };
  }

  // --- Helpers ---
  static OrderStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'accepted':
        return OrderStatus.accepted;
      case 'rejected':
        return OrderStatus.rejected;
      case 'ready':
      case 'pickup':
        return OrderStatus.pickup;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.pending;
    }
  }
}

class OrderItem {
  final String name; // e.g. "Pizza Chicken Ranch"
  final String price; // e.g. "$49.95"
  final List<String> extras; // e.g. ["Large", "Sprite", "Cheesy Fries"]

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
