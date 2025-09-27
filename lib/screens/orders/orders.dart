import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/orders/widgets/order_card.dart';
import 'package:iconly/iconly.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  StreamSubscription? _ordersSub;

  @override
  void initState() {
    super.initState();
    // Trigger fetching orders depending on user type
    if (currentUserType == UserType.admin) {
      _ordersSub = OrderCubit.instance.getOrdersStream();
    } else if (currentUserType != UserType.guest) {
      _ordersSub = OrderCubit.instance.getOrdersByCustomerStream();
    }
  }

  @override
  void dispose() {
    // Cancel Firestore subscriptions
    _ordersSub?.cancel();
    super.dispose();
  }

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
      body: BlocBuilder<OrderCubit, OrderState>(
        bloc: OrderCubit.instance,
        builder: (context, state) {
          if (currentUserType == UserType.guest) {
            return _buildGuestView(context);
          }

          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) {
              return buildEmptyView(
                S.current.no_orders_yet,
                S.current.once_you_place_new_orders,
                IconlyLight.bag,
              );
            }

            return SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final OrderModel order = orders[index];
                  return OrderCard(order: order);
                },
              ),
            );
          } else if (state is OrderError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(IconlyLight.lock, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 20),
            Text(
              S.current.you_need_account_to_view_orders,
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
                navigateTo(context: context, screen: Signup(isGuestMode: true));
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
  }
}
