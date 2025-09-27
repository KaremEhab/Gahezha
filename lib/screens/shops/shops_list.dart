import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/models/shop_model.dart';

class ShopListPage extends StatefulWidget {
  const ShopListPage({super.key});

  @override
  State<ShopListPage> createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // ✅ Use 'this' as vsync
    _tabController = TabController(length: 4, vsync: this);

    // Fetch shops by status
    ShopCubit.instance.adminGetAllShops();
    ShopCubit.instance.getPendingShops();
    ShopCubit.instance.getAcceptedShops();
    ShopCubit.instance.getRejectedShops();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildShopList(List<ShopModel> shops) {
    if (shops.isEmpty) {
      return const Center(
        child: Text(
          "No shops found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        itemCount: shops.length,
        itemBuilder: (context, index) {
          final shop = shops[index];
          return Column(
            children: [
              ShopCard(shopModel: shop),
              if (shop.shopAcceptanceStatus.index != 0)
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Material(
                    color: shop.shopAcceptanceStatus.index == 1
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(radius),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      child: Center(
                        child: Text(
                          shop.shopAcceptanceStatus.index == 1
                              ? S.current.accepted
                              : S.current.rejected,
                          style: TextStyle(
                            color: shop.shopAcceptanceStatus.index == 1
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              if (shop.shopAcceptanceStatus.index == 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          ShopCubit.instance.changeShopAcceptanceStatus(
                            shop: shop,
                            newStatus: ShopAcceptanceStatus.rejected,
                          );
                        },
                        child: Text(
                          S.current.reject.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5), // spacing between buttons
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          ShopCubit.instance.changeShopAcceptanceStatus(
                            shop: shop,
                            newStatus: ShopAcceptanceStatus.accepted,
                          );
                        },
                        child: Text(
                          S.current.accept.toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                title: Text(
                  S.current.shops,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                centerTitle: true,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryBlue,
                    labelColor: Colors.black,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    tabs: [
                      Tab(text: S.current.all),
                      Tab(text: S.current.pending),
                      Tab(text: S.current.accepted),
                      Tab(text: S.current.rejected),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: BlocBuilder<ShopCubit, ShopState>(
            builder: (context, state) {
              final allShops = ShopCubit.instance.allShops;
              final pendingShops = ShopCubit.instance.pendingShops;
              final acceptedShops = ShopCubit.instance.acceptedShops;
              final rejectedShops = ShopCubit.instance.rejectedShops;

              return TabBarView(
                controller: _tabController,
                children: [
                  // All Shops
                  _buildShopList(allShops),
                  // Pending Shops
                  _buildShopList(pendingShops),
                  // Accepted Shops
                  _buildShopList(acceptedShops),
                  // Rejected Shops
                  _buildShopList(rejectedShops),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

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
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
