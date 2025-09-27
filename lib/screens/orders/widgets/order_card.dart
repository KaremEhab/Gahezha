import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/custom_phone_call.dart';
import 'package:gahezha/screens/cart/widgets/preparing_order_page.dart';
import 'package:gahezha/screens/orders/widgets/order_details_sheet.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart' as intl;

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order, this.newOrder = false});

  final OrderModel order;
  final bool newOrder;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        String shopTotalPrice = "";

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onLongPress: () => navigateTo(
                context: context,
                screen: OrderStatusPage(orderModel: order),
              ),
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
                    _buildOrderItems(order),
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
      },
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
          _buildCircleAvatar(order.customerProfileUrl, null, profileRadius: 21)
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
                "${S.current.placed_on} ${intl.DateFormat('MMM d, yyyy – hh:mm a').format(order.startDate)}",
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
      width: 65,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // First shop
          _buildCircleAvatar(order.customerProfileUrl, null),

          if (order.shops.length > 1)
            Positioned.directional(
              start: 25,
              textDirection: TextDirection.ltr,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Second shop
                  _buildCircleAvatar(
                    order.shops[0].shopLogo,
                    Colors.grey.shade300,
                  ),

                  // Remaining shops count
                  if (order.shops.length > 1)
                    Positioned(
                      right: -5,
                      top: -5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '+${order.shops.length - 1}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleAvatar(
    String imageUrl,
    Color? color, {
    double profileRadius = 18,
  }) {
    return CircleAvatar(
      radius: profileRadius + 1 ?? 19,
      backgroundColor: color ?? Colors.white,
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
      backgroundColor: primaryBlue.withOpacity(0.12),
      child: Icon(Icons.receipt_long, color: primaryBlue, size: 20),
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
        if (currentUserType == UserType.shop)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor(
                order.shops
                    .firstWhere(
                      (shop) => shop.shopId == uId,
                      orElse: () => order.shops.first, // fallback
                    )
                    .status,
              ).withOpacity(0.12),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Text(
              OrderModel.getLocalizedStatus(
                context,
                order.shops
                    .firstWhere(
                      (shop) => shop.shopId == uId,
                      orElse: () => order.shops.first, // fallback
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
                        orElse: () => order.shops.first, // fallback
                      )
                      .status,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildOrderItems(OrderModel order) {
    if (order.shops.isEmpty) {
      return const Text(
        'No items',
        style: TextStyle(fontSize: 14, color: Colors.black87),
      );
    }

    List<OrderItem> relevantItems;

    if (currentUserType == UserType.shop) {
      // Only include items from this shop
      relevantItems = order.shops
          .where((shop) => shop.shopId == uId)
          .expand((shop) => shop.items)
          .toList();
    } else {
      // Flatten all items from all shops
      relevantItems = order.shops.expand((shop) => shop.items).toList();
    }

    final itemNames = relevantItems.map((item) => item.name).toList();

    return Text(
      itemNames.isNotEmpty ? itemNames.join(" + ") : 'No items',
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "${S.current.sar} ${currentUserType == UserType.shop ? (order.shops.firstWhere(
                  (shop) => shop.shopId == currentShopModel?.id,
                  orElse: () => order.shops.first, // fallback
                ).shopTotalPrice) : order.totalPrice}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: primaryBlue,
          ),
        ),
        Row(
          children: [
            PhoneCallButton(
              number: currentUserType == UserType.shop
                  ? order.customerPhone
                  : order.shops
                        .firstWhere(
                          (shop) => shop.shopId == currentShopModel?.id,
                          orElse: () => order.shops.first,
                        )
                        .shopPhone,
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: primaryBlue),
          ],
        ),
      ],
    );
  }
}
