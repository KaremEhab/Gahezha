import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/screens/cart/cart.dart';
import 'package:gahezha/screens/home/home.dart';
import 'package:gahezha/screens/layout/widgets/custom_nav_bar.dart';
import 'package:gahezha/screens/orders/orders.dart';
import 'package:gahezha/screens/profile/profile.dart';
import 'package:iconly/iconly.dart';

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

  final List<Widget> _pages = [
    const HomePage(),
    const CartPage(),
    const OrdersPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.white,
      ),
    );
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // disable swipe
        children: _pages,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
