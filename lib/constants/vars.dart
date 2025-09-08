import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:intl/intl.dart';

double radius = 12;
double sheetRadius = 25;
late String lang;
bool showProfileDetails = false;
bool skipOnboarding = false;
late UserType currentUserType;
UserModel? currentUserModel;
ShopModel? currentShopModel;
GuestUserModel? currentGuestModel;
late String uId;
String? fcmDeviceToken;
late String accessToken;

enum ImageType { customerProfile, shopLogo, shopBanner }

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

final categories = [
  {"name": "Fast Food", "icon": Icons.fastfood},
  {"name": "Bakery", "icon": Icons.cake},
  {"name": "Cafe", "icon": Icons.local_cafe},
  {"name": "Supermarket", "icon": Icons.store},
  {"name": "Restaurant", "icon": Icons.restaurant},
  {"name": "Grocery", "icon": Icons.shopping_bag},
  {"name": "Dessert", "icon": Icons.icecream},
  {"name": "Juice Bar", "icon": Icons.local_drink},
  {"name": "Pizza", "icon": Icons.local_pizza},
  {"name": "Sushi", "icon": Icons.set_meal},
  {"name": "Seafood", "icon": Icons.set_meal_outlined},
  {"name": "Clothing", "icon": Icons.checkroom},
  {"name": "Electronics", "icon": Icons.electrical_services},
  {"name": "Mobile Phones", "icon": Icons.smartphone},
  {"name": "Home Appliances", "icon": Icons.kitchen},
  {"name": "Books", "icon": Icons.menu_book},
  {"name": "Stationery", "icon": Icons.edit},
  {"name": "Toys", "icon": Icons.toys},
  {"name": "Beauty & Cosmetics", "icon": Icons.brush},
  {"name": "Jewelry", "icon": Icons.watch},
  {"name": "Sports", "icon": Icons.sports_soccer},
  {"name": "Fitness", "icon": Icons.fitness_center},
  {"name": "Pharmacy", "icon": Icons.local_pharmacy},
  {"name": "Flowers", "icon": Icons.local_florist},
  {"name": "Gifts", "icon": Icons.card_giftcard},
  {"name": "Furniture", "icon": Icons.chair},
  {"name": "Pet Shop", "icon": Icons.pets},
  {"name": "Music & Instruments", "icon": Icons.music_note},
  {"name": "Car Accessories", "icon": Icons.directions_car},
  {"name": "Shoes", "icon": Icons.shopping_cart},
  {"name": "Handmade Crafts", "icon": Icons.handyman},
  {"name": "Ice Cream", "icon": Icons.icecream},
  {"name": "Fast Casual", "icon": Icons.restaurant_menu},
  {"name": "Organic Food", "icon": Icons.eco},
  {"name": "Vegan", "icon": Icons.spa},
  {"name": "Tea House", "icon": Icons.local_cafe},
  {"name": "Dessert Cafe", "icon": Icons.icecream},
  {"name": "Bakery & Coffee", "icon": Icons.coffee},
  {"name": "Street Food", "icon": Icons.ramen_dining},
  {"name": "Bar", "icon": Icons.wine_bar},
  {"name": "Night Club", "icon": Icons.nightlife},
  {"name": "Internet Cafe", "icon": Icons.wifi},
  {"name": "Photography Studio", "icon": Icons.camera_alt},
  {"name": "Bookstore & Cafe", "icon": Icons.menu_book},
];

// Sample orders
final orders = [
  OrderModel(
    id: "#1021",
    date: DateTime(2025, 9, 2), // year, month, day
    status: OrderStatus.delivered,
    totalPrice: "${S.current.sar} 33.50",
    items: [
      OrderItem(
        name: "Black Coffee",
        price: "${S.current.sar} 20.00",
        extras: ["Medium", "Milk", "No Sugar"],
      ),
      OrderItem(
        name: "Ice Cream",
        price: "${S.current.sar} 13.50",
        extras: ["Vanilla"],
      ),
    ],
  ),
  OrderModel(
    id: "#1020",
    date: DateTime(2025, 8, 28), // year, month, day
    status: OrderStatus.accepted,
    totalPrice: "${S.current.sar} 99.90",
    items: [
      OrderItem(
        name: "Pizza",
        price: "${S.current.sar} 49.95",
        extras: ["Chicken Ranch", "Large", "Extra Cheese"],
      ),
      OrderItem(
        name: "Shrimp Pasta",
        price: "${S.current.sar} 49.95",
        extras: ["Mushrooms", "Extra Shrimp", "No Vegetables"],
      ),
    ],
  ),
  OrderModel(
    id: "#1019",
    date: DateTime(2025, 8, 25), // year, month, day
    status: OrderStatus.pending,
    totalPrice: "${S.current.sar} 12.00",
    items: [
      OrderItem(
        name: "Red Flowers",
        price: "${S.current.sar} 12.00",
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

void navigateTo({required BuildContext context, required Widget screen}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void navigateReplacement({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void navigateAndFinish({
  required BuildContext context,
  required Widget screen,
}) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (builder) => screen),
    (route) => false,
  );
}
