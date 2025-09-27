import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/admin/admin_state.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart' hide AllShopsLoaded;
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/cubits/user/user_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';
import 'package:gahezha/screens/accounts/widgets/account_settings_card.dart';

class UsersAndShopsPage extends StatefulWidget {
  const UsersAndShopsPage({super.key});

  @override
  State<UsersAndShopsPage> createState() => _UsersAndShopsPageState();
}

class _UsersAndShopsPageState extends State<UsersAndShopsPage> {
  @override
  void initState() {
    super.initState();
    ReportCubit.instance.getAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Main tabs: Users & Shops
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
                  S.current.gahezha_accounts,
                  style: const TextStyle(
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
                    tabs: [
                      Tab(text: S.current.customers),
                      Tab(text: S.current.shops),
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

class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  @override
  void initState() {
    super.initState();
    ReportCubit.instance.processCustomerReports(
      ReportCubit.instance.allReports,
    );
    UserCubit.instance.adminGetAllCustomers();
  }

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
                tabs: [
                  Tab(text: S.current.all),
                  Tab(text: S.current.blocked),
                  Tab(text: S.current.reported),
                  Tab(text: S.current.disabled),
                ],
              ),
            ),
          ),
          // --- TabBar content ---
          SliverFillRemaining(
            child: TabBarView(
              children: [
                _UsersList(tabType: UserTabType.all),
                _UsersList(tabType: UserTabType.blocked),
                _UsersList(tabType: UserTabType.reported),
                _UsersList(tabType: UserTabType.disabled),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- SHOPS TAB (Pinned inner tabs) ----------
class _ShopsTab extends StatefulWidget {
  const _ShopsTab();

  @override
  State<_ShopsTab> createState() => _ShopsTabState();
}

class _ShopsTabState extends State<_ShopsTab> {
  @override
  void initState() {
    super.initState();
    ReportCubit.instance.processShopReports(ReportCubit.instance.allReports);
    ShopCubit.instance.adminGetAllShops();
  }

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
                tabs: [
                  Tab(text: S.current.all),
                  Tab(text: S.current.blocked),
                  Tab(text: S.current.reported),
                  Tab(text: S.current.disabled),
                ],
              ),
            ),
          ),
          // --- TabBar content ---
          SliverFillRemaining(
            child: TabBarView(
              children: [
                _ShopsList(tabType: S.current.all),
                _ShopsList(tabType: S.current.blocked),
                _ShopsList(tabType: S.current.reported),
                _ShopsList(tabType: S.current.disabled),
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
  final UserTabType tabType;

  const _UsersList({required this.tabType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final cubit = UserCubit.instance;
        List<UserModel> usersList;

        switch (tabType) {
          case UserTabType.blocked:
            usersList = cubit.blockedCustomers;
            break;
          case UserTabType.reported:
            usersList = cubit.reportedCustomers;
            break;
          case UserTabType.disabled:
            usersList = cubit.disabledCustomers;
            break;
          default:
            usersList = cubit.allCustomers;
        }

        if (usersList.isEmpty) {
          return const Center(child: Text("No Customers"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            final user = usersList[index];
            return AccountSettingsCard(
              userType: UserType.customer,
              id: user.userId,
              avatarUrl: user.profileUrl,
              userName: user.fullName,
              userEmail: user.email,
              userPhone: user.phoneNumber,
              isBlocked: user.blocked,
              isDisabled: user.disabled,
              isReported: user.reported,
              reportedCount: user.reportedCount,
            );
          },
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
    return BlocBuilder<ShopCubit, ShopState>(
      builder: (context, state) {
        if (state is ShopLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // ✅ Use the updated lists from the cubit
        final cubit = ShopCubit.instance;

        List<ShopModel> shopsList;

        if (tabType == S.current.blocked) {
          shopsList = cubit.blockedShops;
        } else if (tabType == S.current.reported) {
          shopsList = cubit.reportedShops;
        } else if (tabType == S.current.disabled) {
          shopsList = cubit.disabledShops;
        } else {
          shopsList = cubit.allShops;
        }

        if (shopsList.isEmpty) {
          return const Center(child: Text("No Shops"));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          itemCount: shopsList.length,
          itemBuilder: (context, index) {
            final shop = shopsList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: BlocConsumer<AdminCubit, AdminState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return AccountSettingsCard(
                    userType: UserType.shop,
                    id: shop.id,
                    avatarUrl: shop.shopLogo,
                    bannerUrl: shop.shopBanner,
                    userName: shop.shopName,
                    userEmail: shop.shopEmail,
                    isBlocked: shop.blocked,
                    isDisabled: shop.disabled,
                    userPhone: shop.shopPhoneNumber,
                    isReported: shop.reported, // ✅ use real value
                    reportedCount: shop.reportedCount, // ✅ use real count
                    shopAcceptanceStatus: shop.shopAcceptanceStatus.index,
                  );
                },
              ),
            );
          },
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
