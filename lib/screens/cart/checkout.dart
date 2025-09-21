import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/cart_model.dart';
import 'package:gahezha/screens/cart/widgets/preparing_order_page.dart';

class CheckoutPage extends StatelessWidget {
  final double total;
  final List<CartShop> cartShops;

  const CheckoutPage({super.key, required this.total, required this.cartShops});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(S.current.checkout), centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Orders Summary
                Expanded(
                  child: ListView.builder(
                    itemCount: cartShops.length,
                    itemBuilder: (context, shopIndex) {
                      final shop = cartShops[shopIndex];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.shopName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),

                          ...shop.orders.map((order) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Material(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadiusDirectional.circular(
                                  radius,
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  leading: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            radius,
                                          ),
                                          child: Image.network(
                                            order.productUrl,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (order.quantity > 1)
                                          Center(
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.white,
                                              child: Center(
                                                child: Text(
                                                  order.quantity > 99
                                                      ? "+99"
                                                      : order.quantity
                                                            .toString(),
                                                  style: TextStyle(
                                                    color: primaryBlue,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  title: Text(order.name),
                                  subtitle: Wrap(
                                    spacing: 4,
                                    runSpacing: 2,
                                    children: [
                                      if (order.specifications.isNotEmpty ||
                                          order.selectedAddOns.isNotEmpty)
                                        Text(
                                          [
                                            // Specs
                                            ...order.specifications.expand(
                                              (spec) => spec.entries.map((e) {
                                                final allValues = e.value
                                                    .map(
                                                      (v) =>
                                                          v['name'].toString(),
                                                    )
                                                    .toList();
                                                return allValues.join(', ');
                                              }),
                                            ),
                                            // Add-ons
                                            ...order.selectedAddOns.map(
                                              (a) => "${a['name']}",
                                            ),
                                          ].join(
                                            ' | ',
                                          ), // single line with | between everything
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: Text(
                                    "${S.current.sar} ${order.totalPrice.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          // ✅ Only show divider if this isn’t the last shop
                          if (shopIndex < cartShops.length - 1)
                            SizedBox(height: 10),
                          //   Divider(height: 20, color: Colors.grey.shade300),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S.current.total_price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${S.current.sar} ${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // Confirm & Prepare Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final state = await OrderCubit.instance
                            .placeOrderWithShops(
                              shops: cartShops,
                              customerInfo: currentUserModel!,
                            );

                        // Assuming your Cubit emits OrderPlaced with the OrderModel
                        if (OrderCubit.instance.state is OrderPlaced) {
                          final order =
                              (OrderCubit.instance.state as OrderPlaced).order;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OrderStatusPage(
                                orderModel: order,
                                isPlacingOrder: true,
                              ),
                            ),
                          );
                        } else if (OrderCubit.instance.state is OrderError) {
                          final error =
                              (OrderCubit.instance.state as OrderError).message;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(error)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        S.current.prepare_your_order,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
