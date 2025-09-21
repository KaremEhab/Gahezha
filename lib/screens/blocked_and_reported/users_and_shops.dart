import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/admin/admin_state.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/cubits/user/user_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/shop_model.dart';
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
                _UsersList(tabType: S.current.all),
                _UsersList(tabType: S.current.blocked),
                _UsersList(tabType: S.current.reported),
                _UsersList(tabType: S.current.disabled),
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
  final String tabType;

  const _UsersList({required this.tabType});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final cubit = UserCubit.instance;

        List<UserModel> usersList;
        switch (tabType) {
          case "Blocked":
            usersList = cubit.blockedCustomers;
            break;
          case "Reported":
            usersList = cubit.reportedCustomers;
            break;
          case "Disabled":
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
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: BlocConsumer<AdminCubit, AdminState>(
                listener: (context, state) {
                  // if (state is AdminCustomerDeleted &&
                  //     state.userId == user.userId) {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text("Customer deleted")),
                  //   );
                  // }
                },
                builder: (context, state) {
                  return AccountSettingsCard(
                    userType: UserType.customer,
                    id: user.userId,
                    avatarUrl: user.profileUrl,
                    userName: user.fullName,
                    userEmail: user.email,
                    userPhone: user.phoneNumber,
                    isBlocked: user.blocked,
                    isDisabled: user.disabled,
                    isReported: false,
                    reportedCount: 0,
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

        if (state is AllShopsLoaded) {
          // ✅ Use the updated lists from the cubit
          final cubit = ShopCubit.instance;

          List<ShopModel> shopsList;
          switch (tabType) {
            case "Blocked":
              shopsList = cubit.blockedShops;
              break;
            case "Reported":
              shopsList = cubit.reportedShops;
              break;
            case "Disabled":
              shopsList = cubit.disabledShops;
              break;
            default:
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
                      isReported: false,
                      shopAcceptanceStatus: shop.shopAcceptanceStatus.index,
                      reportedCount: 0,
                    );
                  },
                ),
              );
            },
          );
        }

        return const SizedBox();
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
