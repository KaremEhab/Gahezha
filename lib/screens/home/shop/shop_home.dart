import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/notifications/notifications.dart';
import 'package:gahezha/screens/orders/widgets/order_card.dart';
import 'package:iconly/iconly.dart';

class ShopHomePage extends StatelessWidget {
  const ShopHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Fake sample orders ---
    final List<OrderModel> sampleOrders = [
      OrderModel(
        id: "98",
        status: OrderStatus.pending,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 120",
        items: [
          OrderItem(
            name: "Burger",
            price: "${S.current.sar} 50",
            extras: ["Large", "Cheese"],
          ),
          OrderItem(name: "Fries", price: "${S.current.sar} 20"),
        ],
      ),
      OrderModel(
        id: "98",
        status: OrderStatus.rejected,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 120",
        items: [
          OrderItem(
            name: "Burger",
            price: "${S.current.sar} 50",
            extras: ["Large", "Cheese"],
          ),
          OrderItem(name: "Fries", price: "${S.current.sar} 20"),
        ],
      ),
      OrderModel(
        id: "98",
        status: OrderStatus.preparing,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 120",
        items: [
          OrderItem(
            name: "Burger",
            price: "${S.current.sar} 50",
            extras: ["Large", "Cheese"],
          ),
          OrderItem(name: "Fries", price: "${S.current.sar} 20"),
        ],
      ),
      OrderModel(
        id: "99",
        status: OrderStatus.pending,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 120",
        items: [
          OrderItem(
            name: "Burger",
            price: "${S.current.sar} 50",
            extras: ["Large", "Cheese"],
          ),
          OrderItem(name: "Fries", price: "${S.current.sar} 20"),
        ],
      ),
      OrderModel(
        id: "100",
        status: OrderStatus.pending,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 120",
        items: [
          OrderItem(
            name: "Burger",
            price: "${S.current.sar} 50",
            extras: ["Large", "Cheese"],
          ),
          OrderItem(name: "Fries", price: "${S.current.sar} 20"),
        ],
      ),
      OrderModel(
        id: "101",
        status: OrderStatus.pending,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 120",
        items: [
          OrderItem(
            name: "Burger",
            price: "${S.current.sar} 50",
            extras: ["Large", "Cheese"],
          ),
          OrderItem(name: "Fries", price: "${S.current.sar} 20"),
        ],
      ),
      OrderModel(
        id: "102",
        status: OrderStatus.pending,
        date: DateTime.now(),
        totalPrice: "${S.current.sar} 90",
        items: [
          OrderItem(name: "Chicken Ranch Pizza", price: "${S.current.sar} 90"),
        ],
      ),
      OrderModel(
        id: "103",
        status: OrderStatus.accepted,
        date: DateTime.now().subtract(const Duration(minutes: 5)),
        totalPrice: "${S.current.sar} 75",
        items: [
          OrderItem(
            name: "Pizza",
            price: "${S.current.sar} 75",
            extras: ["Medium"],
          ),
        ],
      ),
      OrderModel(
        id: "104",
        status: OrderStatus.pickup,
        date: DateTime.now().subtract(const Duration(minutes: 15)),
        totalPrice: "${S.current.sar} 45",
        items: [OrderItem(name: "Salad", price: "${S.current.sar} 45")],
      ),
      OrderModel(
        id: "105",
        status: OrderStatus.delivered,
        date: DateTime.now().subtract(const Duration(hours: 1)),
        totalPrice: "${S.current.sar} 99",
        items: [OrderItem(name: "Shawarma Wrap", price: "${S.current.sar} 99")],
      ),
    ];

    final last3Orders = sampleOrders
        .where((o) => o.status == OrderStatus.pending)
        .take(3)
        .toList();

    return DefaultTabController(
      length: OrderStatus.values.length,
      child: Scaffold(
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
                            BlocBuilder<ProfileToggleCubit, HomeToggleState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    ProfileToggleCubit.instance
                                        .homeProfileButtonToggle();
                                  },
                                  child: // Profile picture
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey.shade300,
                                    child: CircleAvatar(
                                      radius: 22,
                                      child: CustomCachedImage(
                                        imageUrl: currentShopModel!.shopLogo,
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

              // --- Last 3 Orders (above TabBar) ---
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
                        S.current.new_orders,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        itemCount: last3Orders.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 360,
                            child: OrderCard(
                              order: last3Orders[index],
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
            children: OrderStatus.values.map((status) {
              final filtered = sampleOrders
                  .where((o) => o.status == status)
                  // exclude the last3Orders
                  .where((o) => !last3Orders.contains(o))
                  .toList();

              if (filtered.isEmpty) {
                return const Center(child: Text("No orders"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 15,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return OrderCard(order: filtered[index]);
                },
              );
            }).toList(),
          ),
        ),
      ),
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
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
