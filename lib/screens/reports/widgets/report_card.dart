import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/reports/widgets/report_details_sheet.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({
    super.key,
    this.userType = UserType.customer,
    this.name = "Kareem Ehab",
    this.fromHome = false,
  });

  final UserType userType;
  final String name;
  final bool fromHome;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
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
            builder: (_) => ReportDetailsSheet(
              reportId: "1234",
              title: "Hello Gahezha App I want to report this issue.",
              type: S.current.fraudulent_activity,
              description:
                  "User reported suspicious transactions in Gahezha account.",
              date: "02 Sep 2025",
              status: ReportType.pending,
              reporter: name,
            ),
          );
        },
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report ID
              Row(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${S.current.report} #1234",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 0.7,
                      color: Colors.black87,
                    ),
                  ),
                  if (!fromHome) ...[
                    CircleAvatar(radius: 3, backgroundColor: Colors.black),
                    Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          userType == UserType.customer
                              ? IconlyBold.profile
                              : Icons.storefront,
                          size: 15,
                          color: primaryBlue,
                        ),
                        Text(
                          name,
                          style: Theme.of(context).textTheme.bodyLarge!
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
                    S.current.fraudulent_activity,
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
                "User reported suspicious transactions in Gahezha account.",
                maxLines: fromHome ? 2 : 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const Spacer(),

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
                        "02 Sep 2025",
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
                      S.current.pending,
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
