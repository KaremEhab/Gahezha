import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/countdown_clock.dart';
import 'package:gahezha/screens/home/customer/customer_home.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:intl/intl.dart' as intl;

class OrderStatusPage extends StatelessWidget {
  final OrderModel orderModel;
  final bool isPlacingOrder;

  const OrderStatusPage({
    super.key,
    required this.orderModel,
    this.isPlacingOrder = false,
  });

  Widget buildStatusTimeline(BuildContext context, OrderModel order) {
    final allStatuses = [
      OrderStatus.pending,
      OrderStatus.accepted,
      OrderStatus.preparing,
      OrderStatus.pickup,
      OrderStatus.delivered,
    ];

    return SizedBox(
      height: 100,
      child: Row(
        children: allStatuses.map((status) {
          // ✅ check if this status is reached by any shop
          final isActive = order.shops.any(
            (s) => allStatuses.indexOf(s.status) >= allStatuses.indexOf(status),
          );

          // ✅ shops currently on this status
          final shopsAtThisStatus = order.shops
              .where((s) => s.status == status)
              .toList();

          return Expanded(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Connecting line
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 12,
                      child: Container(height: 4, color: Colors.grey[300]),
                    ),

                    // Active line overlay
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 12,
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: isActive ? 1.0 : 0.0,
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                statusColor(status).withOpacity(0.7),
                                statusColor(status),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),

                    // Status circle
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isActive
                            ? statusColor(status)
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: isActive
                          ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Status text
                Text(
                  OrderModel.getLocalizedStatus(context, status),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: isActive ? statusColor(status) : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 5),

                // Shop logos under the status
                if (shopsAtThisStatus.isNotEmpty)
                  SizedBox(
                    height: 22,
                    child: Center(
                      child: SizedBox(
                        width:
                            14.0 *
                                (shopsAtThisStatus.length > 4
                                    ? 4
                                    : shopsAtThisStatus.length - 1) +
                            22, // total width
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: shopsAtThisStatus
                              .take(4) // show up to 4 shops
                              .toList()
                              .asMap()
                              .entries
                              .map(
                                (entry) => Positioned(
                                  left: entry.key * 14.0, // overlap
                                  child: CircleAvatar(
                                    radius: 11,
                                    backgroundColor: Colors.grey.shade300,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        entry.value.shopLogo,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(orderModel.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 🚨 Handle deleted/removed order
        if (!snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Order Status"),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.remove_shopping_cart_outlined,
                      size: 80,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "This order has been removed or deleted",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const Layout()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Back to Home",
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final order = OrderModel.fromMap(data);

        return WillPopScope(
          onWillPop: () async {
            if (isPlacingOrder) {
              // Navigate to CustomerHomePage and remove all other pages
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const Layout()),
                (route) => false,
              );
              return false; // Prevent default pop behavior}
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  const Text("Order Status"),
                  Text(
                    order.id,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (isPlacingOrder) {
                    // Navigate to CustomerHomePage and remove all other pages
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const Layout()),
                      (route) => false,
                    );
                  }
                  Navigator.pop(context);
                },
              ),
              actions: [
                // Padding(
                //   padding: EdgeInsetsGeometry.directional(end: 10),
                //   child: OrderCountdownTimer(
                //     startDate: DateTime.parse(
                //       order.startDate.toIso8601String(),
                //     ),
                //     endDate: DateTime.parse(order.endDate.toIso8601String()),
                //   ),
                // ),
              ],
              elevation: 0,
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 10,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Timeline
                      buildStatusTimeline(context, order),
                      // Status Card without shadow
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Icon(
                            //   Icons.receipt_long_outlined,
                            //   color: statusColor(order.status),
                            //   size: 40,
                            // ),
                            // const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${S.current.sar} ${order.totalPrice}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${S.current.placed_on} ${intl.DateFormat('MMM d, yyyy – hh:mm a').format(order.startDate)}",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        S.current.order_details,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: order.shops.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, shopIndex) {
                          final shop = order.shops[shopIndex];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Shop Header
                              Row(
                                children: [
                                  if (shop.shopLogo.isNotEmpty)
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.grey.shade300,
                                      child: CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(
                                          shop.shopLogo,
                                        ),
                                      ),
                                    ),
                                  if (shop.shopLogo.isNotEmpty)
                                    const SizedBox(width: 8),
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shop.shopName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 3,
                                          horizontal: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor(
                                            shop.status,
                                          ).withOpacity(0.1),
                                          borderRadius:
                                              BorderRadiusGeometry.circular(5),
                                        ),
                                        child: Text(
                                          shop.status.name,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: statusColor(shop.status),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: shop.status == OrderStatus.delivered
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            key: ValueKey(1),
                                            size: 30,
                                          )
                                        : // In the AppBar (actions) or inside the Status Card
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            child:
                                                (shop.status ==
                                                        OrderStatus.delivered ||
                                                    shop.status ==
                                                        OrderStatus.pending ||
                                                    shop.status ==
                                                        OrderStatus.rejected)
                                                ? const SizedBox() // 🚨 don't show timer if pending/rejected/delivered
                                                : OrderCountdownTimer(
                                                    status: shop.status,
                                                    displayClock: true,
                                                    endDate: shop.endDate,
                                                    shouldRun:
                                                        !(shop.status ==
                                                                OrderStatus
                                                                    .pending ||
                                                            shop.status ==
                                                                OrderStatus
                                                                    .rejected),
                                                  ),
                                          ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              // Shop Items
                              ...shop.items.map(
                                (item) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    spacing: 5,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          spacing: 5,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (item.extras.isNotEmpty)
                                              Text(
                                                item.extras.join(' | '),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${S.current.sar} ${item.price}",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
