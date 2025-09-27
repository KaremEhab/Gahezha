import 'package:flutter/material.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/notification_model.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/countdown_clock.dart';
import 'package:gahezha/public_widgets/custom_phone_call.dart';
import 'package:gahezha/screens/home/shop/shop_home.dart';
import 'package:intl/intl.dart' as intl;
import 'package:iconly/iconly.dart';

class OrderDetailsSheet extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String shopTotalPrice = "";

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      builder: (_, controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          titleSpacing: 10,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${S.current.order} ${order.id}"),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    IconlyLight.calendar,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${S.current.placed_on} ${intl.DateFormat('MMM d, yyyy – hh:mm a').format(order.startDate)}",
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            if (currentUserType == UserType.shop)
              Container(
                height: 27,
                margin: const EdgeInsetsDirectional.only(end: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: statusColor(
                    // find the current shop in the order
                    order.shops
                        .firstWhere(
                          (shop) => shop.shopId == uId,
                          orElse: () => order.shops.first, // fallback
                        )
                        .status,
                  ).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    OrderModel.getLocalizedStatus(
                      context,
                      order.shops
                          .firstWhere(
                            (shop) => shop.shopId == uId,
                            orElse: () => order.shops.first,
                          )
                          .status,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor(
                        order.shops
                            .firstWhere(
                              (shop) => shop.shopId == uId,
                              orElse: () => order.shops.first,
                            )
                            .status,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👤 Customer + Shop Info
              if (currentUserType == UserType.admin ||
                  currentUserType == UserType.shop) ...[
                _buildCustomerCard(),
                // const SizedBox(height: 12),
                // _buildShopsCard(),
                const SizedBox(height: 20),
              ],

              Text(
                S.current.order_details,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // 🛍️ Items per shop
              ...order.shops
                  .where((shop) {
                    // ✅ If user is shop → filter only my shopId
                    if (currentUserType == UserType.shop) {
                      return shop.shopId == uId;
                    }
                    return true; // Admin / customer → show all shops
                  })
                  .map((shop) {
                    shopTotalPrice = shop.shopTotalPrice;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                spacing: 5,
                                children: [
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
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(shop.shopName),
                                      Row(
                                        spacing: 5,
                                        children: [
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
                                                  BorderRadiusGeometry.circular(
                                                    5,
                                                  ),
                                            ),
                                            child: Text(
                                              OrderModel.getLocalizedStatus(
                                                context,
                                                shop.status,
                                              ),
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: statusColor(shop.status),
                                              ),
                                            ),
                                          ),
                                          if (shop.status !=
                                              OrderStatus.pending)
                                            CircleAvatar(
                                              radius: 3,
                                              backgroundColor: statusColor(
                                                shop.status,
                                              ),
                                            ),
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 500,
                                            ),
                                            child:
                                                shop.status ==
                                                    OrderStatus.delivered
                                                ? CircleAvatar(
                                                    radius: 11,
                                                    backgroundColor:
                                                        Colors.green,
                                                    child: CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: const Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                        key: ValueKey(1),
                                                        size: 15,
                                                      ),
                                                    ),
                                                  )
                                                : AnimatedSwitcher(
                                                    duration: const Duration(
                                                      milliseconds: 500,
                                                    ),
                                                    child:
                                                        (shop.status ==
                                                                OrderStatus
                                                                    .delivered ||
                                                            shop.status ==
                                                                OrderStatus
                                                                    .pending ||
                                                            shop.status ==
                                                                OrderStatus
                                                                    .rejected)
                                                        ? const SizedBox()
                                                        : OrderCountdownTimer(
                                                            status: shop.status,
                                                            endDate:
                                                                shop.endDate,
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
                                    ],
                                  ),
                                ],
                              ),
                              (currentUserType == UserType.admin ||
                                      currentUserType == UserType.customer)
                                  ? PhoneCallButton(number: shop.shopPhone)
                                  : const SizedBox.shrink(),
                            ],
                          ),
                          const SizedBox(height: 6),

                          // 🛒 Items
                          ...shop.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Material(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(7),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        spacing: 5,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${S.current.sar} ${item.price}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (item.extras.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: -6,
                                        children: item.extras
                                            .map(
                                              (extra) => Chip(
                                                label: Text(
                                                  extra,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                visualDensity:
                                                    VisualDensity.compact,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(color: Colors.grey.withOpacity(0.3)),

                // Total
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.total_price,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${S.current.sar} ${currentUserType == UserType.shop ? shopTotalPrice : order.totalPrice}",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Buttons
                _buildBottomActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            order.customerProfileUrl.isEmpty
                ? CircleAvatar(
                    radius: 24,
                    child: Center(
                      child: Icon(
                        IconlyBold.profile,
                        size: 20,
                        color: primaryBlue,
                      ),
                    ),
                  )
                : CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade300,
                    child: CircleAvatar(
                      radius: 23,
                      backgroundImage: NetworkImage(order.customerProfileUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                  ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customerFullName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.customerPhone,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            if (currentUserType == UserType.admin ||
                currentUserType == UserType.shop)
              PhoneCallButton(number: order.customerPhone),
          ],
        ),
      ),
    );
  }

  // Widget _buildShopsCard() {
  //   return Column(
  //     children: order.shops.map((shop) {
  //       return Card(
  //         elevation: 0,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //           side: BorderSide(color: Colors.grey.shade300),
  //         ),
  //         margin: EdgeInsets.zero,
  //         child: Padding(
  //           padding: const EdgeInsets.all(14),
  //           child: Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: 24,
  //                 backgroundImage: NetworkImage(
  //                   shop.shopLogo.isNotEmpty
  //                       ? shop.shopLogo
  //                       : "https://picsum.photos/200/200?random=20",
  //                 ),
  //                 backgroundColor: Colors.grey.shade200,
  //               ),
  //               const SizedBox(width: 12),
  //
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       shop.shopName,
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w600,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 4),
  //                     Text(
  //                       shop.shopPhone,
  //                       textDirection: TextDirection.ltr,
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                         color: Colors.black54,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //               if (currentUserType == UserType.admin)
  //                 IconButton(
  //                   onPressed: () {
  //                     // TODO: launch shop phone dialer
  //                   },
  //                   icon: const Icon(IconlyBold.call, color: primaryBlue),
  //                 ),
  //             ],
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  // Widget _buildCustomerCard() {
  //   return Card(
  //     elevation: 0,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       side: BorderSide(color: Colors.grey.shade300),
  //     ),
  //     margin: EdgeInsets.zero,
  //     child: Padding(
  //       padding: const EdgeInsets.all(14),
  //       child: Row(
  //         children: [
  //           CircleAvatar(
  //             radius: 24,
  //             backgroundImage: const NetworkImage(
  //               "https://picsum.photos/200/200?random=12",
  //             ),
  //             backgroundColor: Colors.grey.shade200,
  //           ),
  //           const SizedBox(width: 12),
  //
  //           // Name + Phone
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: const [
  //                 Text(
  //                   "Kareem Ehab",
  //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //                 ),
  //                 SizedBox(height: 4),
  //                 Text(
  //                   "+20 111 219 0563",
  //                   textDirection: TextDirection.ltr,
  //                   style: TextStyle(fontSize: 14, color: Colors.black54),
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //           // Call button
  //           if ((order.status != OrderStatus.delivered &&
  //                   order.status != OrderStatus.rejected) ||
  //               currentUserType == UserType.admin)
  //             IconButton(
  //               onPressed: () {
  //                 // TODO: launch phone dialer
  //               },
  //               icon: const Icon(IconlyBold.call, color: primaryBlue),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildShopCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: const NetworkImage(
                "https://picsum.photos/200/200?random=20",
              ),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),

            // Shop name + phone
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Demo Shop",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+20 100 555 8888",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            if (currentUserType == UserType.admin)
              IconButton(
                onPressed: () {
                  // TODO: launch shop phone dialer
                },
                icon: const Icon(IconlyBold.call, color: primaryBlue),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    if (currentUserType == UserType.admin) {
      return Row(
        spacing: 5,
        children: [
          // Delete Order
          Expanded(
            child: _buildAdminButtonAction(
              context,
              icon: IconlyBold.delete,
              label: S.current.delete,
              color: Colors.red,
              onTap: () {
                OrderCubit.instance.deleteOrder(order.id);
              },
            ),
          ),

          // Block Shop
          // Expanded(
          //   child: _buildAdminAvatarButtonAction(
          //     context,
          //     imageUrl: "https://picsum.photos/200/200?random=20",
          //     onTap: () {
          //       // TODO: block shop logic
          //     },
          //   ),
          // ),
          //
          // Block Customer
          // Expanded(
          //   child: _buildAdminAvatarButtonAction(
          //     context,
          //     imageUrl: "https://picsum.photos/200/200?random=12",
          //     onTap: () {
          //       // TODO: block customer logic
          //     },
          //   ),
          // ),
        ],
      );
    }

    if (currentUserType == UserType.shop) {
      // find the current shop in the order
      // Find current shop in the order
      final myShop = order.shops.firstWhere(
        (s) => s.shopId == uId,
        orElse: () => throw Exception("Shop not found in order"),
      );

      switch (myShop.status) {
        case OrderStatus.pending:
          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: statusColor(OrderStatus.rejected),
                    side: BorderSide(color: statusColor(OrderStatus.rejected)),
                  ),
                  onPressed: () {
                    OrderCubit.instance.changeOrderStatus(
                      order,
                      OrderStatus.rejected,
                      SenderReceiver(
                        id: order.customerId,
                        name: order.customerFullName,
                        profile: order.customerProfileUrl,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(S.current.reject),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor(OrderStatus.accepted),
                  ),
                  onPressed: () {
                    OrderCubit.instance.changeOrderStatus(
                      order,
                      OrderStatus.accepted,
                      SenderReceiver(
                        id: order.customerId,
                        name: order.customerFullName,
                        profile: order.customerProfileUrl,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(S.current.accept),
                ),
              ),
            ],
          );

        case OrderStatus.accepted:
          return _buildActionButton(
            context,
            S.current.preparing.toUpperCase(),
            () {
              OrderCubit.instance.changeOrderStatus(
                order,
                OrderStatus.preparing,
                SenderReceiver(
                  id: order.customerId,
                  name: order.customerFullName,
                  profile: order.customerProfileUrl,
                ),
              );
              Navigator.pop(context);
            },
            color: statusColor(OrderStatus.preparing),
          );

        case OrderStatus.preparing:
          return _buildActionButton(
            context,
            S.current.pickup.toUpperCase(),
            () {
              OrderCubit.instance.changeOrderStatus(
                order,
                OrderStatus.pickup,
                SenderReceiver(
                  id: order.customerId,
                  name: order.customerFullName,
                  profile: order.customerProfileUrl,
                ),
              );
              Navigator.pop(context);
            },
            color: statusColor(OrderStatus.pickup),
          );

        case OrderStatus.pickup:
          return _buildActionButton(
            context,
            S.current.delivered.toUpperCase(),
            () {
              OrderCubit.instance.changeOrderStatus(
                order,
                OrderStatus.delivered,
                SenderReceiver(
                  id: order.customerId,
                  name: order.customerFullName,
                  profile: order.customerProfileUrl,
                ),
              );
              Navigator.pop(context);
            },
            color: statusColor(OrderStatus.delivered),
          );

        case OrderStatus.rejected:
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: statusColor(OrderStatus.rejected).withOpacity(0.1),
            ),
            child: Center(
              child: Text(
                S.current.rejected.toUpperCase(),
                style: TextStyle(
                  color: statusColor(OrderStatus.rejected).withOpacity(0.5),
                ),
              ),
            ),
          );

        default:
          return const SizedBox.shrink();
      }
    }

    // Default (customer / others)
    return _buildActionButton(
      context,
      S.current.close,
      () => Navigator.pop(context),
      color: Colors.grey.shade200,
      textColor: Colors.black87,
    );
  }

  /// 🔹 Button with Icon
  Widget _buildAdminButtonAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  /// 🔹 Button with Avatar (circle image)
  Widget _buildAdminAvatarButtonAction(
    BuildContext context, {
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: BorderSide(color: Colors.red, width: 1.2),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              S.current.block,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CircleAvatar(radius: 12, backgroundImage: NetworkImage(imageUrl)),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String text,
    VoidCallback onPressed, {
    Color? color,
    Color? textColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
