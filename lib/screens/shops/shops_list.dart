import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';

class ShopListPage extends StatelessWidget {
  const ShopListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake shop data
    final List<int> allShops = List.generate(10, (i) => i);
    final List<int> pendingShops = List.generate(4, (i) => i);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // --- SliverAppBar ---
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                title: Text(
                  S.current.shops,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                centerTitle: true,
              ),

              // --- Sticky TabBar ---
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryBlue,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: S.current.all_shops),
                      Tab(text: S.current.pending_shops),
                    ],
                  ),
                ),
              ),
            ];
          },

          // --- Tabs Content ---
          body: TabBarView(
            children: [
              // All Shops
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: allShops.length,
                  itemBuilder: (context, index) => ShopCard(),
                ),
              ),

              // Pending Shops
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: pendingShops.length,
                  itemBuilder: (context, index) => ShopCard(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Custom SliverTabBarDelegate (same as in HomePage) ---
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
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
