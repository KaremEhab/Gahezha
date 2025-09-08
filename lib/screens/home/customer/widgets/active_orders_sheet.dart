import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/screens/orders/widgets/order_card.dart';
import 'package:iconly/iconly.dart';

class ActiveOrdersBottomSheet extends StatelessWidget {
  const ActiveOrdersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      OrderModel(
        id: "#1023",
        status: OrderStatus.pickup,
        date: DateTime.now().copyWith(hour: 10, minute: 30),
        totalPrice: "${S.current.sar} 24.99",
        items: [
          OrderItem(
            name: "Latte",
            price: "${S.current.sar} 12.50",
            extras: ["Medium", "Extra Shot"],
          ),
          OrderItem(name: "Croissant", price: "${S.current.sar} 12.49", extras: ["Butter"]),
        ],
      ),
      OrderModel(
        id: "#1024",
        status: OrderStatus.pickup,
        date: DateTime.now().copyWith(hour: 11, minute: 00),
        totalPrice: "${S.current.sar} 18.50",
        items: [
          OrderItem(
            name: "Cappuccino",
            price: "${S.current.sar} 9.50",
            extras: ["Small", "Oat Milk"],
          ),
          OrderItem(name: "Muffin", price: "${S.current.sar} 9.00", extras: ["Blueberry"]),
        ],
      ),
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(radius),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.current.active_orders,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Divider(height: 1, color: Colors.grey.withOpacity(0.3)),

            // Orders List
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: orders.length,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                itemBuilder: (context, index) {
                  OrderModel order = orders[index];
                  return OrderCard(order: order);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
