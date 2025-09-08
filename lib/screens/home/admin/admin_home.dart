import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/generated/l10n.dart';
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

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

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
                                child: CustomCachedImage(
                                  imageUrl: currentUserModel!.profileUrl,
                                  height: double.infinity,
                                  borderRadius: BorderRadius.circular(200),
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
                SizedBox(
                  height: 290,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return SizedBox(width: 330, child: ShopCard());
                    },
                  ),
                ),

                // Section: Reports
                SectionHeader(
                  title: S.current.reports,
                  onSeeAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ReportsListPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      return ReportCard(fromHome: true);
                    },
                  ),
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
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: OrderCard(order: orders[index]),
              );
            }, childCount: orders.length),
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
