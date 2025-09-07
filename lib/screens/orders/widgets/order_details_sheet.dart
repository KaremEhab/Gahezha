import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:iconly/iconly.dart';

class OrderDetailsSheet extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsSheet({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: order.items.length == 1 ? 0.4 : 0.6,
      maxChildSize: 0.95,
      minChildSize: order.items.length == 1 ? 0.4 : 0.6,
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
                    intl.DateFormat("MMM d, yyyy – hh:mm a").format(order.date),
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            Container(
              height: 27,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: statusColor(order.status).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  OrderModel.getLocalizedStatus(context, order.status),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor(order.status),
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
              if (currentUserType == UserType.admin) ...[
                _buildCustomerCard(),
                const SizedBox(height: 12),
                _buildShopCard(),
                const SizedBox(height: 20),
              ] else if (currentUserType == UserType.shop) ...[
                _buildCustomerCard(),
                const SizedBox(height: 20),
              ],

              Text(
                "Order Details",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // 🛍️ Items
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                IconlyBold.bag,
                                size: 18,
                                color: Colors.black54,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item.price,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Extras
                      if (item.extras.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: -6,
                          children: item.extras
                              .map(
                                (extra) => Chip(
                                  label: Text(
                                    extra,
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  backgroundColor: Colors.grey.shade100,
                                  visualDensity: VisualDensity.compact,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Bottom nav
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                        order.totalPrice,
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
            CircleAvatar(
              radius: 24,
              backgroundImage: const NetworkImage(
                "https://picsum.photos/200/200?random=12",
              ),
              backgroundColor: Colors.grey.shade200,
            ),
            const SizedBox(width: 12),

            // Name + Phone
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Kareem Ehab",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+20 111 219 0563",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Call button
            if ((order.status != OrderStatus.delivered &&
                    order.status != OrderStatus.rejected) ||
                currentUserType == UserType.admin)
              IconButton(
                onPressed: () {
                  // TODO: launch phone dialer
                },
                icon: const Icon(IconlyBold.call, color: primaryBlue),
              ),
          ],
        ),
      ),
    );
  }

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

            if ((order.status != OrderStatus.delivered &&
                    order.status != OrderStatus.rejected) ||
                currentUserType == UserType.admin)
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
              label: "Delete",
              color: Colors.red,
              onTap: () {
                // TODO: delete order logic
              },
            ),
          ),

          // Block Shop
          Expanded(
            child: _buildAdminAvatarButtonAction(
              context,
              imageUrl: "https://picsum.photos/200/200?random=20",
              onTap: () {
                // TODO: block shop logic
              },
            ),
          ),

          // Block Customer
          Expanded(
            child: _buildAdminAvatarButtonAction(
              context,
              imageUrl: "https://picsum.photos/200/200?random=12",
              onTap: () {
                // TODO: block customer logic
              },
            ),
          ),
        ],
      );
    }

    if (currentUserType == UserType.shop) {
      switch (order.status) {
        case OrderStatus.pending:
          return Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: statusColor(OrderStatus.rejected),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(
                      color: statusColor(OrderStatus.rejected),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // TODO: reject order
                  },
                  child: const Text(
                    "REJECT",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statusColor(OrderStatus.accepted),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    // TODO: accept order
                  },
                  child: const Text(
                    "ACCEPT",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          );

        case OrderStatus.accepted:
          return _buildActionButton(
            context,
            S.current.preparing.toUpperCase(),
            () {},
            color: statusColor(OrderStatus.preparing),
          );

        case OrderStatus.preparing:
          return _buildActionButton(
            context,
            S.current.pickup.toUpperCase(),
            () {},
            color: statusColor(OrderStatus.pickup),
          );

        case OrderStatus.pickup:
          return _buildActionButton(
            context,
            S.current.delivered.toUpperCase(),
            () {},
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
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
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
              "BLOCK",
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
