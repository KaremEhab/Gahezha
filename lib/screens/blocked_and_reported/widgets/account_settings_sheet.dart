import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/admin/admin_cubit.dart';
import 'package:gahezha/cubits/admin/admin_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/profile/customer/pages/edit_profile.dart';
import 'package:gahezha/screens/reports/account_reports.dart';
import 'package:gahezha/screens/reports/reports_list.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';
import 'package:iconly/iconly.dart';

class AccountDetailsSheet extends StatefulWidget {
  final UserType userType;
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String bannerUrl;
  final bool isBlocked;
  final bool isReported;
  final bool isDisabled;
  final int shopAcceptanceStatus;
  final int reportedCount;

  const AccountDetailsSheet({
    super.key,
    required this.userType,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.bannerUrl,
    this.isBlocked = false,
    this.isReported = false,
    this.isDisabled = false,
    this.shopAcceptanceStatus = 0,
    this.reportedCount = 0,
  });

  @override
  State<AccountDetailsSheet> createState() => _AccountDetailsSheetState();
}

class _AccountDetailsSheetState extends State<AccountDetailsSheet> {
  late bool _isBlocked;
  late bool _isDisabled;

  @override
  void initState() {
    super.initState();
    _isBlocked = widget.isBlocked;
    _isDisabled = widget.isDisabled;
  }

  void _toggleBlocked(bool value) {
    setState(() => _isBlocked = value);
  }

  void _toggleDisabled(bool value) {
    setState(() => _isDisabled = value);
  }

  @override
  Widget build(BuildContext context) {
    final List<int> reports = List.generate(widget.reportedCount, (i) => i);

    Color statusColor = _isBlocked
        ? Colors.red
        : _isDisabled
        ? Colors.grey
        : widget.isReported
        ? Colors.orange
        : Colors.transparent;

    IconData statusIcon = _isBlocked
        ? Icons.block
        : _isDisabled
        ? IconlyBold.lock
        : widget.isReported
        ? IconlyBold.danger
        : IconlyBold.info_circle;

    return BlocConsumer<AdminCubit, AdminState>(
      listener: (context, state) {
        if (state is AdminShopBlocked && state.shopId == widget.id) {
          _toggleBlocked(state.isBlocked);
        }
        if (state is AdminShopDisabled && state.shopId == widget.id) {
          _toggleDisabled(state.isDisabled);
        }
        if (state is AdminShopDeleted && state.shopId == widget.id) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: _isDisabled
              ? widget.userType.index == 2
                    ? 0.62
                    : 0.55
              : (!widget.isReported ||
                    (widget.isReported && widget.reportedCount == 0))
              ? (!widget.isReported && !_isBlocked
                    ? 0.38
                    : widget.userType.index == 2
                    ? 0.62
                    : 0.55)
              : 0.75,
          maxChildSize: 0.95,
          minChildSize: !widget.isReported && !_isBlocked
              ? 0.38
              : widget.userType.index == 2
              ? 0.62
              : 0.55,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- User Info ---
                        Center(
                          child: widget.userType == UserType.customer
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    /// Avatar
                                    CircleAvatar(
                                      radius: 32,
                                      backgroundColor: Colors.grey.shade300,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                          widget.avatarUrl,
                                        ),
                                        backgroundColor: Colors.grey.shade200,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      widget.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.email,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      widget.phone,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )
                              :
                                /// Profile Header
                                Container(
                                  height: 200,
                                  margin: const EdgeInsets.only(bottom: 15),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      CustomCachedImage(
                                        imageUrl: widget.bannerUrl,
                                        height: double.infinity,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                widget.avatarUrl,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              widget.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            Text(
                                              widget.email,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (widget.shopAcceptanceStatus == 0)
                                        Positioned.directional(
                                          textDirection: Directionality.of(
                                            context,
                                          ),
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 10,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                            ),
                                            child: Text(
                                              S.current.pending,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),

                        // --- Status Icon & Message ---
                        if (_isBlocked || widget.isReported || _isDisabled) ...[
                          Material(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(radius),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                vertical: 30,
                                horizontal: 20,
                              ),
                              child: Column(
                                spacing: 10,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        statusIcon,
                                        size: 60,
                                        color: statusColor,
                                      ),
                                      if (_isBlocked && widget.isReported)
                                        Icon(
                                          IconlyLight.danger,
                                          size: 60,
                                          color: Colors.orange,
                                        ),
                                    ],
                                  ),
                                  Text(
                                    _isBlocked && widget.isReported
                                        ? "${S.current.this_account_has_been_blocked_and_reported} ${widget.reportedCount > 1 ? "(${widget.reportedCount}) ${S.current.times}" : ""}"
                                        : _isDisabled
                                        ? S
                                              .current
                                              .this_account_has_been_disabled
                                        : _isBlocked
                                        ? S
                                              .current
                                              .this_account_has_been_blocked
                                        : "${S.current.this_account_has_been_reported} ${widget.reportedCount > 1 ? "(${widget.reportedCount}) ${S.current.times}" : ""}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: statusColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // --- Reports Section ---
                        if (widget.isReported && widget.reportedCount > 0) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.current.recent_reports,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccountReports(
                                        name: widget.name,
                                        initialTabIndex: 1,
                                        pendingReportsCount:
                                            widget.reportedCount,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
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
                          const SizedBox(height: 12),
                          Column(
                            children: reports
                                .take(3)
                                .map(
                                  (report) => Container(
                                    height: 145,
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ReportCard(
                                      report: ReportModel(
                                        id: "#110029",
                                        reportType:
                                            "Order prepared late / not ready on time",
                                        reportDescription: "reportDescription",
                                        reporter: ReportUser(
                                          id: "cscwfwdcaer2",
                                          name: "Alaa El-Sayed",
                                        ),
                                        reporting: ReportUser(
                                          id: "cscwfwdcaer2",
                                          name: "Kareem Ehab",
                                        ),
                                        createdAt: DateTime.now(),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ],
                    ),
                  ),
                ),

                // --- Action Buttons ---
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      spacing: 5,
                      children: [
                        if (!_isDisabled)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                context.read<AdminCubit>().adminBlockAccount(
                                  widget.id,
                                  widget.userType.name,
                                  !_isBlocked,
                                );
                              },
                              icon: const Icon(Icons.block),
                              label: Text(
                                _isBlocked
                                    ? S.current.unblock
                                    : S.current.block,
                              ),
                              style: OutlinedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                side: BorderSide(color: Colors.red),
                                foregroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        if (!_isBlocked)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context.read<AdminCubit>().adminDisableAccount(
                                  widget.id,
                                  widget.userType.name,
                                  !_isDisabled,
                                );
                              },
                              icon: const Icon(IconlyBold.lock),
                              label: Text(
                                _isDisabled
                                    ? S.current.enable
                                    : S.current.disable,
                              ),
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.grey.shade800,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<AdminCubit>().adminDeleteAccount(
                                widget.userType.name,
                                widget.id,
                              );
                            },
                            icon: const Icon(IconlyBold.delete),
                            label: Text(S.current.delete),
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
