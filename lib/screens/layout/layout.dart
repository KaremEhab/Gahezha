import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/firebase_options.dart';
import 'package:gahezha/main.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/blocked_and_reported/users_and_shops.dart';
import 'package:gahezha/screens/cart/cart.dart';
import 'package:gahezha/screens/home/admin/admin_home.dart';
import 'package:gahezha/screens/home/customer/customer_home.dart';
import 'package:gahezha/screens/home/shop/shop_home.dart';
import 'package:gahezha/screens/layout/widgets/custom_nav_bar.dart';
import 'package:gahezha/screens/layout/widgets/home_profile_popup.dart';
import 'package:gahezha/screens/menu/shop_menu.dart';
import 'package:gahezha/screens/orders/orders.dart';
import 'package:gahezha/screens/profile/customer/customer_profile.dart';
import 'package:gahezha/screens/profile/shop/shop_profile.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = currentUserType == UserType.customer
        ? [
            const CustomerHomePage(),
            const CartPage(),
            const OrdersPage(),
            const CustomerProfilePage(),
          ]
        : currentUserType == UserType.shop
        ? [const ShopHomePage(), const ShopMenuPage(), const ShopProfilePage()]
        : [
            const AdminHomePage(),
            const UsersAndShopsPage(),
            const CustomerProfilePage(),
          ];
    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          bottomNavigationBar: CustomNavBar(
            currentIndex: _currentIndex,
            onItemTapped: _onItemTapped,
          ),
        ),
        // ================= Profile Pop-up Container =================
        Material(color: Colors.transparent, child: HomeProfilePopup()),
      ],
    );
  }
}
