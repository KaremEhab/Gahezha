import 'package:flutter/material.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:intl/intl.dart';

double radius = 12;
double sheetRadius = 25;
late String lang;
bool showProfileDetails = false; // toggle state for profile container
late UserType currentUserType;

const primaryBlue = Color(0xFF1B6BFF); // main brand blue
const onPrimary = Colors.white;
const secondaryBlue = Color(0xFF0F3DAD);
const accentCyan = Color(0xFF22D1EE);
const bg = Color(0xFFF7F9FC);
const surface = Colors.white;

Color statusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.delivered:
      return Colors.green;
    case OrderStatus.accepted:
      return primaryBlue;
    case OrderStatus.rejected:
      return Colors.red;
    case OrderStatus.pickup:
      return Colors.orange;
    case OrderStatus.preparing:
      return Colors.purple; // preparing state color
    default:
      return Colors.grey;
  }
}

// Sample orders
final orders = [
  OrderModel(
    id: "#1021",
    date: DateTime(2025, 9, 2), // year, month, day
    status: OrderStatus.delivered,
    totalPrice: "SAR 33.50",
    items: [
      OrderItem(
        name: "Black Coffee",
        price: "SAR 20.00",
        extras: ["Medium", "Milk", "No Sugar"],
      ),
      OrderItem(name: "Ice Cream", price: "SAR 13.50", extras: ["Vanilla"]),
    ],
  ),
  OrderModel(
    id: "#1020",
    date: DateTime(2025, 8, 28), // year, month, day
    status: OrderStatus.accepted,
    totalPrice: "SAR 99.90",
    items: [
      OrderItem(
        name: "Pizza",
        price: "SAR 49.95",
        extras: ["Chicken Ranch", "Large", "Extra Cheese"],
      ),
      OrderItem(
        name: "Shrimp Pasta",
        price: "SAR 49.95",
        extras: ["Mushrooms", "Extra Shrimp", "No Vegetables"],
      ),
    ],
  ),
  OrderModel(
    id: "#1019",
    date: DateTime(2025, 8, 25), // year, month, day
    status: OrderStatus.pending,
    totalPrice: "SAR 12.00",
    items: [
      OrderItem(
        name: "Red Flowers",
        price: "SAR 12.00",
        extras: ["Large Size", "Gift Wrapped"],
      ),
    ],
  ),
];

IconData backIcon() {
  return lang == 'en' ? Icons.keyboard_arrow_left : Icons.keyboard_arrow_right;
}

IconData forwardIcon() {
  return lang == 'en' ? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left;
}
