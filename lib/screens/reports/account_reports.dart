import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';

class AccountReports extends StatelessWidget {
  const AccountReports({
    super.key,
    required this.name,
    required this.pendingReportsCount,
    this.initialTabIndex = 0, // NEW: initial tab
  });

  final String name;
  final int pendingReportsCount;
  final int initialTabIndex;

  @override
  Widget build(BuildContext context) {
    // Fake reports data
    final List<int> allReports = List.generate(12, (i) => i);
    final List<int> pendingReports = List.generate(
      pendingReportsCount,
      (i) => i,
    );
    final List<int> resolvedReports = List.generate(5, (i) => i);
    final List<int> dismissedReports = List.generate(3, (i) => i);

    return DefaultTabController(
      length: 4,
      initialIndex: initialTabIndex, // USE the initial tab index
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
                  "$name ${S.current.reports}",
                  style: const TextStyle(
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
                    isScrollable: true,
                    labelColor: Colors.black,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabAlignment: TabAlignment.center,
                    tabs: [
                      Tab(text: S.current.all_reports),
                      Tab(text: S.current.pending),
                      Tab(text: S.current.resolved),
                      Tab(text: S.current.dismissed),
                    ],
                  ),
                ),
              ),
            ];
          },

          // --- Tabs Content ---
          body: TabBarView(
            children: [
              // All Reports
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: allReports.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 150,
                    child: ReportCard(
                      report: ReportModel(
                        id: "#110029",
                        reportType: "Order prepared late / not ready on time",
                        reportDescription: "reportDescription",
                        reporter: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Alaa El-Sayed",
                          userType: UserType.customer.name,
                        ),
                        reporting: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Adidas",
                          userType: UserType.customer.name,
                        ),
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                ),
              ),

              // Pending Reports
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: pendingReports.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 150,
                    child: ReportCard(
                      report: ReportModel(
                        id: "#110029",
                        reportType: "Order prepared late / not ready on time",
                        reportDescription: "reportDescription",
                        reporter: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Alaa El-Sayed",
                          userType: UserType.customer.name,
                        ),
                        reporting: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Adidas",
                          userType: UserType.customer.name,
                        ),
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                ),
              ),

              // Resolved Reports
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: resolvedReports.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 150,
                    child: ReportCard(
                      report: ReportModel(
                        id: "#110029",
                        reportType: "Order prepared late / not ready on time",
                        reportDescription: "reportDescription",
                        reporter: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Alaa El-Sayed",
                          userType: UserType.customer.name,
                        ),
                        reporting: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Adidas",
                          userType: UserType.customer.name,
                        ),
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                ),
              ),

              // Dismissed Reports
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemCount: dismissedReports.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 150,
                    child: ReportCard(
                      report: ReportModel(
                        id: "#110029",
                        reportType: "Order prepared late / not ready on time",
                        reportDescription: "reportDescription",
                        reporter: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Alaa El-Sayed",
                          userType: UserType.customer.name,
                        ),
                        reporting: ReportUser(
                          id: "cscwfwdcaer2",
                          name: "Adidas",
                          userType: UserType.customer.name,
                        ),
                        createdAt: DateTime.now(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Custom SliverTabBarDelegate ---
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
