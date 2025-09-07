import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';

class ReportsListPage extends StatelessWidget {
  const ReportsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake reports data
    final List<int> allReports = List.generate(12, (i) => i);
    final List<int> pendingReports = List.generate(4, (i) => i);
    final List<int> resolvedReports = List.generate(5, (i) => i);
    final List<int> dismissedReports = List.generate(3, (i) => i);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // --- SliverAppBar ---
              SliverAppBar(
                pinned: true,
                floating: true,
                elevation: 0,
                title: const Text(
                  "Reports",
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
                    isScrollable: true,
                    labelColor: Colors.black,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blue,
                    tabAlignment: TabAlignment.center,
                    tabs: const [
                      Tab(text: "All Reports"),
                      Tab(text: "Pending"),
                      Tab(text: "Resolved"),
                      Tab(text: "Dismissed"),
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
                    child: const ReportCard(),
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
                    child: const ReportCard(),
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
                    child: const ReportCard(),
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
                    child: const ReportCard(),
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

// --- Custom SliverTabBarDelegate (same as Shops) ---
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
