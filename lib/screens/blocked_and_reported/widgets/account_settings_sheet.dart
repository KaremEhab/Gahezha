import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/profile/customer/pages/edit_profile.dart';
import 'package:gahezha/screens/reports/account_reports.dart';
import 'package:gahezha/screens/reports/reports_list.dart';
import 'package:gahezha/screens/reports/widgets/report_card.dart';
import 'package:iconly/iconly.dart';

class AccountDetailsSheet extends StatelessWidget {
  final UserType userType;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final String bannerUrl;
  final bool isBlocked;
  final bool isReported;
  final bool isDisabled; // NEW
  final int reportedCount;
  // final List<dynamic> reports; // list of report models

  const AccountDetailsSheet({
    super.key,
    required this.userType,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.bannerUrl,
    this.isBlocked = false,
    this.isReported = false,
    this.isDisabled = false, // NEW
    this.reportedCount = 0,
    // this.reports = const [],
  });

  @override
  Widget build(BuildContext context) {
    final List<int> reports = List.generate(reportedCount, (i) => i);

    Color statusColor = isBlocked
        ? Colors.red
        : isDisabled
        ? Colors.grey
        : isReported
        ? Colors.orange
        : Colors.transparent;

    IconData statusIcon = isBlocked
        ? Icons.block
        : isDisabled
        ? IconlyBold.lock
        : isReported
        ? IconlyBold.danger
        : IconlyBold.info_circle;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: isDisabled
          ? 0.55
          : (!isReported || (isReported && reportedCount == 0))
          ? (!isReported && !isBlocked ? 0.38 : 0.55)
          : 0.75,
      maxChildSize: 0.95,
      minChildSize: !isReported && !isBlocked ? 0.38 : 0.55,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                      child: userType == UserType.customer
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                /// Avatar
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(avatarUrl),
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  phone,
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
                                    imageUrl: bannerUrl,
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
                                            avatarUrl,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        Text(
                                          email,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),

                    // --- Status Icon & Message ---
                    if (isBlocked || isReported || isDisabled) ...[
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
                                  if (isBlocked && isReported)
                                    Icon(
                                      IconlyLight.danger,
                                      size: 60,
                                      color: Colors.orange,
                                    ),
                                ],
                              ),
                              Text(
                                isBlocked && isReported
                                    ? "${S.current.this_account_has_been_blocked_and_reported} ${reportedCount > 1 ? "($reportedCount) ${S.current.times}" : ""}"
                                    : isDisabled
                                    ? S.current.this_account_has_been_disabled
                                    : isBlocked
                                    ? S.current.this_account_has_been_blocked
                                    : "${S.current.this_account_has_been_reported} ${reportedCount > 1 ? "($reportedCount) ${S.current.times}" : ""}",
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
                    if (isReported && reportedCount > 0) ...[
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
                                    name: name,
                                    initialTabIndex: 1,
                                    pendingReportsCount: reportedCount,
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
                                  userType: userType,
                                  name: name,
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
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          debugPrint("Block pressed");
                        },
                        icon: const Icon(Icons.block),
                        label: Text(
                          isBlocked ? S.current.unblock : S.current.block,
                        ),
                        style: OutlinedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          side: BorderSide(color: Colors.red),
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          debugPrint("Disable pressed");
                        },
                        icon: const Icon(IconlyBold.lock),
                        label: Text(S.current.disable),
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.grey.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          debugPrint("Delete pressed");
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
  }
}
