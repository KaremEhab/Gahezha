import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/reports/widgets/edit_report.dart';
import 'package:gahezha/screens/reports/widgets/report_details_sheet.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:intl/intl.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;
  final bool fromHome;

  const ReportCard({super.key, required this.report, this.fromHome = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (currentUserType == UserType.admin) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(sheetRadius),
                  topRight: Radius.circular(sheetRadius),
                ),
              ),
              builder: (_) => ReportDetailsSheet(report: report),
            );
          } else {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(sheetRadius),
                  topRight: Radius.circular(sheetRadius),
                ),
              ),
              builder: (_) => EditReportSheet(report: report),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // <-- important: makes height flexible
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report ID row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${S.current.report} ${report.id}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 0.7,
                      color: Colors.black87,
                    ),
                  ),
                  if (!fromHome) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        report.reporting.name.toLowerCase().contains("gahezha")
                            ? SvgPicture.asset(
                                "assets/images/logo.svg",
                                height: 15,
                                width: 15,
                              )
                            : Icon(
                                currentUserType == UserType.customer
                                    ? IconlyBold.profile
                                    : Icons.storefront,
                                size: 14,
                                color: primaryBlue,
                              ),
                        const SizedBox(width: 4),
                        Text(
                          report.reporting.name,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                color: primaryBlue,
                              ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
              SizedBox(height: fromHome ? 12 : 8),

              // Type
              Row(
                children: [
                  const Icon(IconlyLight.danger, size: 18, color: Colors.red),
                  const SizedBox(width: 6),
                  Text(
                    report.reportType,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Short description
              Text(
                report.reportDescription,
                maxLines: fromHome ? 2 : null, // null allows unlimited lines
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        IconlyLight.calendar,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('dd MMM yyyy').format(report.createdAt),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall!.copyWith(color: Colors.black45),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ReportModel.getLocalizedReportStatus(
                        context,
                        report.status,
                      ),
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
