import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/orders/widgets/order_card.dart';
import 'package:iconly/iconly.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        leadingWidth: 53,
        leading:
            currentUserType == UserType.admin ||
                currentUserType == UserType.guest
            ? null
            : Padding(
                padding: EdgeInsets.fromLTRB(
                  lang == 'en' ? 7 : 0,
                  6,
                  lang == 'ar' ? 7 : 0,
                  6,
                ),
                child: Material(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(radius),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(radius),
                    onTap: () {},
                    child: const Center(
                      child: Icon(
                        IconlyBold.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
        title: Text(S.current.orders),
        actions: [
          if (currentUserType != UserType.guest)
            Padding(
              padding: EdgeInsets.only(
                right: lang == 'en' ? 7 : 0,
                left: lang == 'ar' ? 7 : 0,
              ),
              child: Row(
                spacing: 5,
                children: [
                  Material(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(radius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(radius),
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(13),
                        child: Icon(IconlyLight.search, size: 16),
                      ),
                    ),
                  ),
                  if (currentUserType == UserType.admin)
                    Material(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(radius),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(radius),
                        onTap: () {},
                        child: const Padding(
                          padding: EdgeInsets.all(13),
                          child: Icon(
                            IconlyBold.delete,
                            color: Colors.red,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (currentUserType == UserType.guest) {
            // Guest view with signup button
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconlyLight.lock,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'You need an account to view orders',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to signup page
                        navigateTo(
                          context: context,
                          screen: Signup(isGuestMode: true),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(S.current.create_account),
                    ),
                  ],
                ),
              ),
            );
          } else if (orders.isEmpty) {
            // Logged-in user but no orders yet
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconlyLight.bag,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Once you place an order, it will appear here.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Show orders list
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                OrderModel order = orders[index];
                return OrderCard(order: order);
              },
            );
          }
        },
      ),
    );
  }
}
