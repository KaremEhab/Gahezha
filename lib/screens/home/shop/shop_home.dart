import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/notifications/notifications.dart';
import 'package:gahezha/screens/orders/widgets/order_card.dart';
import 'package:iconly/iconly.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({super.key});

  /// 🌍 Global key to access TabController
  static final GlobalKey<_ShopHomePageState> globalKey =
      GlobalKey<_ShopHomePageState>();

  /// 🌍 Global method to navigate tab bar
  static void navigateToTab(int index) {
    final state = globalKey.currentState;
    if (state == null) {
      debugPrint(
        "⚠️ ShopHomePage state not found (did you attach the globalKey?)",
      );
    } else {
      state.tabController?.animateTo(index);
    }
  }

  @override
  State<ShopHomePage> createState() => _ShopHomePageState();
}

class _ShopHomePageState extends State<ShopHomePage>
    with TickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();

    // Assign globalKey
    if (widget.key != ShopHomePage.globalKey) {
      // rebuild with the global key
    }

    final orderCubit = OrderCubit.instance;
    orderCubit.getLast5PickupOrdersStream(uId);
    orderCubit.getAllPendingOrdersStream(uId);
    orderCubit.getAcceptedOrdersStream(uId);
    orderCubit.getRejectedOrdersStream(uId);
    orderCubit.getPreparingOrdersStream(uId);
    orderCubit.getShopPickupOrdersStream(uId);
    orderCubit.getDeliveredOrdersStream(uId);
  }

  @override
  void dispose() {
    tabController?.dispose();
    OrderCubit.instance.dispose(); // 🔥 cancel all streams
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = OrderCubit.instance;

        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderError) {
          return Center(child: Text(state.message));
        }

        if (state is OrderLoaded || state is OrderStatusChanged) {
          tabController ??= TabController(
            length: OrderStatus.values.length,
            vsync: this,
          );

          return Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  // ---------------- SliverAppBar ----------------
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    backgroundColor: Colors.white,
                    forceMaterialTransparency: true,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    titleSpacing: 0,
                    flexibleSpace: Material(
                      color: Colors.white,
                      child: Column(
                        children: [
                          const SafeArea(child: SizedBox()),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BlocBuilder<
                                  ProfileToggleCubit,
                                  HomeToggleState
                                >(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () {
                                        ProfileToggleCubit.instance
                                            .homeProfileButtonToggle();
                                      },
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundColor: Colors.grey.shade300,
                                        child: CircleAvatar(
                                          radius: 20,
                                          child: CustomCachedImage(
                                            imageUrl:
                                                currentShopModel!.shopLogo,
                                            height: double.infinity,
                                            borderRadius: BorderRadius.circular(
                                              200,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SvgPicture.asset(
                                  'assets/images/logo.svg',
                                  height: 28,
                                ),
                                Stack(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const NotificationsPage(),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        IconlyLight.notification,
                                        size: 28,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      top: 10,
                                      child: Container(
                                        height: 10,
                                        width: 10,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // --- Last 5 Orders (above TabBar) ---
                  if (cubit.last5PickupOrders.isNotEmpty)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Text(
                              S.current.ready_to_pickup,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 190,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              itemCount: cubit.last5PickupOrders.length,
                              itemBuilder: (context, index) {
                                final order = cubit.last5PickupOrders[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: cubit.last5PickupOrders.length > 1
                                      ? 360
                                      : MediaQuery.sizeOf(context).width * 0.95,
                                  child: OrderCard(
                                    order: order,
                                    newOrder: true,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  // --- Sticky TabBar ---
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverTabBarDelegate(
                      TabBar(
                        controller: tabController,
                        isScrollable: true,
                        labelColor: Colors.black,
                        dividerColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        tabAlignment: TabAlignment.center,
                        tabs: OrderStatus.values
                            .map(
                              (s) => Tab(
                                text: OrderModel.getLocalizedStatus(context, s),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ];
              },

              // --- Tabs Content ---
              body: TabBarView(
                controller: tabController,
                children: OrderStatus.values.map((status) {
                  final orders = switch (status) {
                    OrderStatus.pending => cubit.allPendingOrders,
                    OrderStatus.accepted => cubit.acceptedOrders,
                    OrderStatus.rejected => cubit.rejectedOrders,
                    OrderStatus.preparing => cubit.preparingOrders,
                    OrderStatus.pickup => cubit.pickupOrders,
                    OrderStatus.delivered => cubit.deliveredOrders,
                  };
                  if (orders.isEmpty) {
                    return const Center(child: Text("No orders"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return OrderCard(order: order);
                    },
                  );
                }).toList(),
              ),
            ),
          );
        }
        return const Center(child: SizedBox());
      },
    );
  }
}

/// --- Sticky TabBar Helper ---
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) => false;
}
