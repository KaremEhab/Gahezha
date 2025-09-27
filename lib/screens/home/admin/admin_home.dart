import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/cubits/order/order_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/notifications/notifications.dart';
import 'package:gahezha/screens/orders/orders.dart';
import 'package:gahezha/screens/reports/reports_list.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';
import 'package:gahezha/screens/shops/shops_list.dart';
import 'package:gahezha/screens/shops/widgets/shop_card.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/screens/orders/widgets/order_card.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
    OrderCubit.instance.getLastTenOrdersStream();
    ShopCubit.instance.getHomePendingShops();
    ReportCubit.instance.getAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
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
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey.shade300,
                                child: CircleAvatar(
                                  radius: 20,
                                  child:
                                      currentUserModel != null &&
                                          currentUserModel!
                                              .profileUrl
                                              .isNotEmpty
                                      ? CustomCachedImage(
                                          imageUrl:
                                              currentUserModel!.profileUrl,
                                          height: double.infinity,
                                          borderRadius: BorderRadius.circular(
                                            200,
                                          ),
                                        )
                                      : Icon(
                                          IconlyBold.profile,
                                          color: primaryBlue,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                        SvgPicture.asset('assets/images/logo.svg', height: 28),
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

          // ---------------- Content ----------------
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: Pending Shops
                const SizedBox(height: 10),
                SectionHeader(
                  title: S.current.pending_shops,
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ShopListPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                BlocConsumer<ShopCubit, ShopState>(
                  listener: (context, state) {
                    // if (state is PendingShopsLoaded) {
                    //   display = true;
                    // }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      height: 320,
                      child: state is ShopLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ShopCubit.instance.pendingShops.isEmpty
                          ? const Center(child: Text("No pending shops"))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: ShopCubit.instance.pendingShops.length,
                              shrinkWrap: true,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 5),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              itemBuilder: (context, index) {
                                final shop =
                                    ShopCubit.instance.pendingShops[index];

                                return SizedBox(
                                  width:
                                      ShopCubit.instance.pendingShops.length > 1
                                      ? 330
                                      : MediaQuery.sizeOf(context).width * 0.95,
                                  child: ShopCard(
                                    isPending: true,
                                    shopModel: shop,
                                    onAccepted: () {
                                      ShopCubit.instance
                                          .changeShopAcceptanceStatus(
                                            shop: shop,
                                            newStatus:
                                                ShopAcceptanceStatus.accepted,
                                          );
                                    },
                                    onRejected: () {
                                      ShopCubit.instance
                                          .changeShopAcceptanceStatus(
                                            shop: shop,
                                            newStatus:
                                                ShopAcceptanceStatus.rejected,
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),

                // Section: Reports
                SectionHeader(
                  title: S.current.reports,
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReportsListPage(userType: currentUserType),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                BlocConsumer<ReportCubit, ReportState>(
                  listener: (context, state) {
                    // if (state is PendingShopsLoaded) {
                    //   display = true;
                    // }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      height: 150, // adjust based on ReportCard height
                      child: state is ReportLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ReportCubit.instance.allReports.isEmpty
                          ? const Center(child: Text("No pending Reports"))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemCount:
                                  ReportCubit.instance.allReports.length > 5
                                  ? 5
                                  : ReportCubit.instance.allReports.length,
                              // replace with your cubit reports length
                              itemBuilder: (context, index) {
                                final report =
                                    ReportCubit.instance.allReports[index];

                                return SizedBox(
                                  width: 300,
                                  child: ReportCard(
                                    report: report,
                                    fromHome: true,
                                    canEdit: false,
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Section: Orders
                SectionHeader(
                  title: S.current.recent_orders,
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OrdersPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Orders list
          BlocBuilder<OrderCubit, OrderState>(
            bloc: OrderCubit.instance,
            builder: (context, state) {
              if (state is OrderLoading) {
                return SliverToBoxAdapter(
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else if (state is OrderLoaded) {
                final orders = state.orders;
                if (orders.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 80),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconlyLight.bag, size: 64, color: Colors.grey),
                          const SizedBox(height: 12),
                          Text(
                            "No orders yet",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: OrderCard(order: orders[index]),
                    );
                  }, childCount: orders.length),
                );
              }
              return SliverToBoxAdapter(child: SizedBox());
            },
          ),
        ],
      ),
    );
  }
}

// ---------------- Section Header Widget ----------------
class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const SectionHeader({super.key, required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.directional(start: 10, end: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          InkWell(
            onTap: onSeeAll,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                spacing: 5,
                children: [
                  Text(
                    S.current.see_all,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                  Icon(
                    lang == "en"
                        ? IconlyLight.arrow_right_3
                        : IconlyLight.arrow_left_3,
                    color: primaryBlue,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
