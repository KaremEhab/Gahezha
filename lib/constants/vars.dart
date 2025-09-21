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

final adminReportTypes = [
  S.current.admin_shop_not_fulfilling_orders,
  S.current.admin_shop_rejecting_orders_too_often,
  S.current.admin_wrong_items_sent,
  S.current.admin_shop_not_responsive,
  S.current.admin_customers_reporting_bad_behavior,
  S.current.admin_fake_or_invalid_orders,
  S.current.admin_customer_disputes,
  S.current.admin_order_not_picked_up,
  S.current.admin_order_missing_items,
  S.current.admin_miscommunication,
  S.current.admin_order_delayed,
  S.current.admin_technical_issues,
];

final shopReportTypes = [
  S.current.shop_customer_not_picked_up,
  S.current.shop_customer_wrong_info,
  S.current.shop_customer_complained_unnecessarily,
  S.current.shop_order_unclear_instructions,
  S.current.shop_unable_to_prepare_order,
  S.current.shop_extra_or_missing_items,
  S.current.shop_order_notifications_not_received,
  S.current.shop_app_crashes,
];

final customerReportTypes = [
  S.current.customer_wrong_items_received,
  S.current.customer_items_missing,
  S.current.customer_order_late,
  S.current.customer_poor_quality,
  S.current.customer_rude_staff,
  S.current.customer_wrong_shop_info,
  S.current.customer_shop_unresponsive,
  S.current.customer_app_crashes,
  S.current.customer_notifications_not_working,
  S.current.customer_order_tracking_issues,
];

final categories = [
  {"name": S.current.fast_food, "icon": Icons.fastfood},
  {"name": S.current.bakery, "icon": Icons.cake},
  {"name": S.current.cafe, "icon": Icons.local_cafe},
  {"name": S.current.supermarket, "icon": Icons.store},
  {"name": S.current.restaurant, "icon": Icons.restaurant},
  {"name": S.current.grocery, "icon": Icons.shopping_bag},
  {"name": S.current.dessert, "icon": Icons.icecream},
  {"name": S.current.juice_bar, "icon": Icons.local_drink},
  {"name": S.current.pizza, "icon": Icons.local_pizza},
  {"name": S.current.sushi, "icon": Icons.set_meal},
  {"name": S.current.seafood, "icon": Icons.set_meal_outlined},
  {"name": S.current.clothing, "icon": Icons.checkroom},
  {"name": S.current.electronics, "icon": Icons.electrical_services},
  {"name": S.current.mobile_phones, "icon": Icons.smartphone},
  {"name": S.current.home_appliances, "icon": Icons.kitchen},
  {"name": S.current.books, "icon": Icons.menu_book},
  {"name": S.current.stationery, "icon": Icons.edit},
  {"name": S.current.toys, "icon": Icons.toys},
  {"name": S.current.beauty_cosmetics, "icon": Icons.brush},
  {"name": S.current.jewelry, "icon": Icons.watch},
  {"name": S.current.sports, "icon": Icons.sports_soccer},
  {"name": S.current.fitness, "icon": Icons.fitness_center},
  {"name": S.current.pharmacy, "icon": Icons.local_pharmacy},
  {"name": S.current.flowers, "icon": Icons.local_florist},
  {"name": S.current.gifts, "icon": Icons.card_giftcard},
  {"name": S.current.furniture, "icon": Icons.chair},
  {"name": S.current.pet_shop, "icon": Icons.pets},
  {"name": S.current.music_instruments, "icon": Icons.music_note},
  {"name": S.current.car_accessories, "icon": Icons.directions_car},
  {"name": S.current.shoes, "icon": Icons.shopping_cart},
  {"name": S.current.handmade_crafts, "icon": Icons.handyman},
  {"name": S.current.ice_cream, "icon": Icons.icecream},
  {"name": S.current.fast_casual, "icon": Icons.restaurant_menu},
  {"name": S.current.organic_food, "icon": Icons.eco},
  {"name": S.current.vegan, "icon": Icons.spa},
  {"name": S.current.tea_house, "icon": Icons.local_cafe},
  {"name": S.current.dessert_cafe, "icon": Icons.icecream},
  {"name": S.current.bakery_coffee, "icon": Icons.coffee},
  {"name": S.current.street_food, "icon": Icons.ramen_dining},
  {"name": S.current.bar, "icon": Icons.wine_bar},
  {"name": S.current.night_club, "icon": Icons.nightlife},
  {"name": S.current.internet_cafe, "icon": Icons.wifi},
  {"name": S.current.photography_studio, "icon": Icons.camera_alt},
  {"name": S.current.bookstore_cafe, "icon": Icons.menu_book},
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
