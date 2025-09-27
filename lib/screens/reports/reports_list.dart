import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/reports/widgets/create_report.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';

class ReportsListPage extends StatefulWidget {
  const ReportsListPage({
    super.key,
    this.initialTabIndex = 0,
    required this.userType,
    this.userName = "",
  });

  final int initialTabIndex;
  final UserType userType;
  final String? userName;

  @override
  State<ReportsListPage> createState() => _ReportsListPageState();
}

class _ReportsListPageState extends State<ReportsListPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialTabIndex != 4) {
      if (widget.userType == UserType.admin) {
        ReportCubit.instance.getAllReports();
      } else {
        log("FETCHING REPORTS---------------");
        ReportCubit.instance.getMyReports(uId);
        ReportCubit.instance.getReportsAboutMe(uId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.userType != UserType.admin ? 5 : 4,
      initialIndex: widget.initialTabIndex, // USE the initial tab index
      child: Scaffold(
        floatingActionButton: widget.initialTabIndex == 4
            ? null
            : FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) => CreateReportSheet(
                      currentUserId: widget.userType == UserType.admin
                          ? "support_team"
                          : uId,
                      currentUserName: widget.userType == UserType.customer
                          ? currentUserModel!.fullName
                          : widget.userType == UserType.admin
                          ? "Gahezha Support Team"
                          : currentShopModel!.shopName,
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
              title: Text("${widget.userName} ${S.current.reports}"),
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
                  isScrollable: widget.userType != UserType.admin
                      ? true
                      : false,
                  labelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabAlignment: widget.userType != UserType.admin
                      ? TabAlignment.center
                      : null,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: primaryBlue,
                  tabs: [
                    Tab(text: S.current.all),
                    Tab(text: S.current.pending_lower),
                    Tab(text: S.current.resolved),
                    Tab(text: S.current.dismissed),
                    if (widget.userType != UserType.admin)
                      Tab(text: "About Me"),
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
              if (widget.userType != UserType.admin) _buildReportsListAboutMe(),
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

        if (state is ReportsDataLoaded) {
          List<ReportModel> reports = state.myReports;

          // Filter by status if needed
          if (status != null) {
            reports = reports.where((r) => r.status == status).toList();
          }

          if (reports.isEmpty) {
            return Center(child: Text(S.current.no_reports_found));
          }

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              10,
              10,
              10,
              widget.initialTabIndex == 4 ? 10 : 130,
            ),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ReportCard(report: report, canEdit: false),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildReportsListAboutMe() {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        if (state is ReportLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ReportsDataLoaded) {
          List<ReportModel> reports = state.reportsAboutMe;

          if (reports.isEmpty) {
            return Center(child: Text(S.current.no_reports_found));
          }

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(
              10,
              10,
              10,
              widget.initialTabIndex == 4 ? 10 : 130,
            ),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ReportCard(
                  report: report,
                  canEdit: currentUserType == UserType.admin ? false : true,
                ),
              );
            },
          );
        }

        return const SizedBox.shrink();
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
