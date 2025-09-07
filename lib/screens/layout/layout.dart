import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gahezha/constants/vars.dart';
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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebaseStuff();
  }

  Future<void> _initializeFirebaseStuff() async {
    await Future.wait([_initFirebase(), _initNotifications(), _initUserData()]);

    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<void> _initFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Future<void> _initNotifications() async {
    await setupFCM();
  }

  Future<void> _initUserData() async {
    // Load current user info or cached data if needed
  }

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

    return Scaffold(
      body: _isInitialized
          ? PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: _pages,
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
