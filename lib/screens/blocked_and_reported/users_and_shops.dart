import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';
import 'package:gahezha/screens/accounts/widgets/account_settings_card.dart';

class UsersAndShopsPage extends StatelessWidget {
  const UsersAndShopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Main tabs: Users & Shops
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // --- SliverAppBar ---
              const SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                title: Text(
                  "Customers & Shops",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                centerTitle: true,
              ),

              // --- Main TabBar: Users / Shops ---
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: primaryBlue,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(text: "Customers"),
                      Tab(text: "Shops"),
                    ],
                  ),
                ),
              ),
            ];
          },

          // --- Main Tabs Content ---
          body: const TabBarView(children: [_UsersTab(), _ShopsTab()]),
        ),
      ),
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: CustomScrollView(
        slivers: [
          // --- Inner TabBar pinned ---
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryBlue,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Blocked"),
                  Tab(text: "Reported"),
                  Tab(text: "Disabled"),
                ],
              ),
            ),
          ),
          // --- TabBar content ---
          SliverFillRemaining(
            child: TabBarView(
              children: const [
                _UsersList(tabType: "All"),
                _UsersList(tabType: "Blocked"),
                _UsersList(tabType: "Reported"),
                _UsersList(tabType: "Disabled"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- SHOPS TAB (Pinned inner tabs) ----------
class _ShopsTab extends StatelessWidget {
  const _ShopsTab();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: CustomScrollView(
        slivers: [
          // --- Inner TabBar pinned ---
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: primaryBlue,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: "All"),
                  Tab(text: "Blocked"),
                  Tab(text: "Reported"),
                  Tab(text: "Disabled"),
                ],
              ),
            ),
          ),
          // --- TabBar content ---
          SliverFillRemaining(
            child: TabBarView(
              children: const [
                _ShopsList(tabType: "All"),
                _ShopsList(tabType: "Blocked"),
                _ShopsList(tabType: "Reported"),
                _ShopsList(tabType: "Disabled"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- USERS LIST ----------
class _UsersList extends StatelessWidget {
  final String tabType;
  const _UsersList({required this.tabType});

  @override
  Widget build(BuildContext context) {
    // Example fake data
    final List<int> users = List.generate(10, (i) => i);

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final Random random = Random();

        // Disabled is exclusive
        final bool isDisabled = random.nextBool(); // 50% chance

        bool isBlocked = false;
        bool isReported = false;
        int reportedCount = 0;

        if (!isDisabled) {
          // Only if not disabled, decide blocked/reported independently
          isBlocked = random.nextBool(); // 50% chance
          isReported = random.nextBool(); // 50% chance
          reportedCount = isReported ? random.nextInt(13) : 0;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: AcoountSettingsCard(
            userType: UserType.customer,
            isBlocked: isBlocked,
            isDisabled: isDisabled,
            isReported: isReported,
            reportedCount: reportedCount,
          ),
        );
      },
    );
  }
}

/// ---------- SHOPS LIST ----------
class _ShopsList extends StatelessWidget {
  final String tabType;
  const _ShopsList({required this.tabType});

  @override
  Widget build(BuildContext context) {
    // Example fake data
    final List<int> shops = List.generate(10, (i) => i);

    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      itemCount: shops.length,
      itemBuilder: (context, index) {
        final Random random = Random();

        // Disabled is exclusive
        final bool isDisabled = random.nextBool(); // 50% chance

        bool isBlocked = false;
        bool isReported = false;
        int reportedCount = 0;

        if (!isDisabled) {
          // Only if not disabled, decide blocked/reported independently
          isBlocked = random.nextBool(); // 50% chance
          isReported = random.nextBool(); // 50% chance
          reportedCount = isReported ? random.nextInt(13) : 0;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: AcoountSettingsCard(
            userType: UserType.shop,
            userName: "Shop ${index + 1}",
            userEmail: "Shop${index + 1}XFSE@example.com",
            isBlocked: isBlocked,
            isDisabled: isDisabled,
            isReported: isReported,
            reportedCount: reportedCount,
          ),
        );
      },
    );
  }
}

/// ---------- Custom SliverTabBarDelegate ----------
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
