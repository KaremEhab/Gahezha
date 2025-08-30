import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:iconly/iconly.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  final int currentIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: Colors.grey.shade300,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          onTap: onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(IconlyLight.home, size: 24),
              activeIcon: Icon(
                IconlyBold.home,
                size: 25, // bigger size when selected
                color: Theme.of(context).primaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyLight.bag, size: 22),
              activeIcon: Icon(
                IconlyBold.bag,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyLight.paper, size: 22),
              activeIcon: Icon(
                IconlyBold.paper,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: const Icon(IconlyLight.profile, size: 22),
              activeIcon: Icon(
                IconlyBold.profile,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
