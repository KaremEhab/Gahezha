import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';

class ReportDetailsSheet extends StatefulWidget {
  final String reportId;
  final String title;
  final String type;
  final String description;
  final String date;
  final ReportType status;
  final String reporter;

  const ReportDetailsSheet({
    super.key,
    required this.reportId,
    required this.title,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
    required this.reporter,
  });

  @override
  State<ReportDetailsSheet> createState() => _ReportDetailsSheetState();
}

class _ReportDetailsSheetState extends State<ReportDetailsSheet> {
  final TextEditingController responseCtrl = TextEditingController();
  late ReportType selectedStatus = widget.status;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (_, controller) => Scaffold(
        body: SingleChildScrollView(
          controller: controller,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Title & Type ---
              Row(
                children: [
                  const Icon(IconlyBold.danger, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${S.current.report} #${widget.reportId} • ${widget.type}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // --- Description ---
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // --- Reporter & Date ---
              Row(
                children: [
                  const Icon(IconlyBold.profile, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    widget.reporter,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(
                    IconlyLight.calendar,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 6),
                  Text(widget.date),
                ],
              ),
              const SizedBox(height: 24),

              // --- Status Dropdown ---
              Text(
                S.current.report_status,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<ReportType>(
                value: selectedStatus,
                icon: const Icon(
                  IconlyBold.arrow_down_2,
                  size: 20,
                  color: Colors.black54,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(14),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                items: ReportType.values.map((status) {
                  Color textColor;
                  IconData iconData;
                  switch (status) {
                    case ReportType.resolved:
                      textColor = Colors.green.shade700;
                      iconData = IconlyLight.tick_square;
                      break;
                    case ReportType.dismissed:
                      textColor = Colors.grey.shade700;
                      iconData = IconlyLight.close_square;
                      break;
                    default:
                      textColor = Colors.orange.shade700;
                      iconData = IconlyLight.time_circle;
                  }

                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(iconData, color: textColor, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          ReportModel.getLocalizedReportStatus(context, status),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) =>
                    setState(() => selectedStatus = val ?? ReportType.pending),
              ),
              const SizedBox(height: 20),

              // --- Response Box ---
              Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: CustomTextField(
                  controller: responseCtrl,
                  maxLines: 4,
                  title: S.current.respond_to_reporter,
                  hint: S.current.type_response_here,
                  keyboardType: TextInputType.text,
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),

        // --- Bottom Button ---
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                debugPrint("Report ID: ${widget.reportId}");
                debugPrint("Status: $selectedStatus");
                debugPrint("Response: ${responseCtrl.text}");
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(IconlyBold.send, color: Colors.white),
              label: Text(
                S.current.send_response_and_update,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
