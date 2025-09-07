import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/orders/widgets/order_details_sheet.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.newOrder = false});

  final OrderModel order;
  final bool newOrder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          borderRadius: BorderRadius.circular(radius),
          onTap: () => _showOrderDetails(context),
          child: Container(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: Colors.grey.withOpacity(0.12)),
              gradient: newOrder
                  ? LinearGradient(
                      colors: [Colors.blue.withOpacity(0.03), Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildOrderItems(),
                const SizedBox(height: 15),
                Divider(height: 1, color: Colors.grey.withOpacity(0.3)),
                const SizedBox(height: 5),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${S.current.viewing_details_of_order} ${order.id}"),
        duration: const Duration(seconds: 1),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(sheetRadius)),
      ),
      builder: (_) => OrderDetailsSheet(order: order),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (currentUserType == UserType.admin)
          _buildAdminAvatars()
        else if (currentUserType == UserType.shop)
          _buildCircleAvatar(
            "https://picsum.photos/200/200?random=21",
            profileRadius: 21,
          )
        else
          _buildStatusAvatar(),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOrderTitleAndStatus(context),
              const SizedBox(height: 4),
              Text(
                "${S.current.placed_on} ${intl.DateFormat('MMM d, yyyy – hh:mm a').format(order.date)}",
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdminAvatars() {
    return SizedBox(
      width: 58,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildCircleAvatar("https://picsum.photos/200/200?random=21"),
          Positioned.directional(
            start: 25,
            textDirection: TextDirection.ltr,
            child: _buildCircleAvatar(
              "https://picsum.photos/200/200?random=22",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar(String imageUrl, {double profileRadius = 18}) {
    return CircleAvatar(
      radius: profileRadius + 1 ?? 19,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: profileRadius ?? 18,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildStatusAvatar() {
    return CircleAvatar(
      radius: 22,
      backgroundColor: statusColor(order.status).withOpacity(0.12),
      child: Icon(
        Icons.receipt_long,
        color: statusColor(order.status),
        size: 20,
      ),
    );
  }

  Widget _buildOrderTitleAndStatus(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${S.current.order} ${order.id}",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor(order.status).withOpacity(0.12),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Text(
            OrderModel.getLocalizedStatus(context, order.status),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor(order.status),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Text(
      order.items.map((item) => item.name).join(" + "),
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical:
            order.status == OrderStatus.delivered ||
                order.status == OrderStatus.rejected
            ? 10
            : 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            order.totalPrice,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: primaryBlue,
            ),
          ),
          Row(
            children: [
              if (order.status != OrderStatus.delivered &&
                  order.status != OrderStatus.rejected)
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    IconlyBold.call,
                    color: primaryBlue,
                    size: 20,
                  ),
                ),
              const Icon(Icons.arrow_forward_ios, size: 18, color: primaryBlue),
            ],
          ),
        ],
      ),
    );
  }
}
