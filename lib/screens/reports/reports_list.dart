import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/screens/reports/widgets/create_report.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';

class ReportsListPage extends StatefulWidget {
  const ReportsListPage({super.key});

  @override
  State<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends State<ReportsListPage> {
  @override
  void initState() {
    super.initState();
    // Load all reports initially
    ReportCubit.instance.getAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => CreateReportSheet(
                currentUserId: uId,
                currentUserName: currentUserModel!.fullName,
              ),
            );
          },
          shape: CircleBorder(),
          elevation: 0,
          backgroundColor: primaryBlue,
          tooltip: S.current.create_report,
          child: const Icon(Icons.report, color: Colors.white),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              floating: true,
              title: Text(S.current.reports),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await ReportCubit.instance.clearReports();
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  labelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryBlue,
                  tabs: [
                    Tab(text: S.current.all),
                    Tab(text: S.current.pending_lower),
                    Tab(text: S.current.resolved),
                    Tab(text: S.current.dismissed),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: [
              _buildReportsList(), // All
              _buildReportsList(status: ReportStatusType.pending),
              _buildReportsList(status: ReportStatusType.resolved),
              _buildReportsList(status: ReportStatusType.dismissed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsList({ReportStatusType? status}) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<ReportModel> reports = [];

        if (state is ReportLoaded) {
          reports = state.reports;
        }

        // Filter by status if needed
        if (status != null) {
          reports = reports.where((r) => r.status == status).toList();
        }

        if (reports.isEmpty) {
          return Center(child: Text(S.current.no_reports_found));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          itemCount: reports.length,
          itemBuilder: (context, index) {
            final report = reports[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReportCard(report: report),
            );
          },
        );
      },
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
