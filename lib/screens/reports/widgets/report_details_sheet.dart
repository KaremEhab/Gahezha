import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:intl/intl.dart';

class ReportDetailsSheet extends StatefulWidget {
  final ReportModel report;

  const ReportDetailsSheet({super.key, required this.report});

  @override
  State<ReportDetailsSheet> createState() => _ReportDetailsSheetState();
}

class _ReportDetailsSheetState extends State<ReportDetailsSheet> {
  final TextEditingController responseCtrl = TextEditingController();
  late ReportStatusType selectedStatus = widget.report.status;

  @override
  void initState() {
    super.initState();
    responseCtrl.text = widget.report.reportRespond ?? '';
    responseCtrl.addListener(() => setState(() {}));
  }

  bool get hasChanged {
    final statusChanged = selectedStatus != widget.report.status;
    final responseChanged =
        responseCtrl.text.trim().isNotEmpty &&
        responseCtrl.text.trim() != (widget.report.reportRespond ?? '');
    return statusChanged || responseChanged;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
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
                      Text(
                        "${S.current.report} ${widget.report.id} • ",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(IconlyLight.calendar, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat(
                          'dd MMM yyyy',
                        ).format(widget.report.createdAt),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // --- Reporting Type ---
                  Row(
                    children: [
                      const Icon(
                        IconlyBold.danger,
                        color: Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.report.reportType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Reporter & Reporting ---
                  Row(
                    children: [
                      buildUserIcon(widget.report.reporter),
                      const SizedBox(width: 6),
                      Text(
                        widget.report.reporter.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Icon(IconlyBold.arrow_right, size: 18),
                      ),
                      buildUserIcon(widget.report.reporting),
                      const SizedBox(width: 6),
                      Text(
                        widget.report.reporting.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // --- Description ---
                  Text(
                    widget.report.reportDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Status Dropdown ---
                  Text(
                    S.current.report_status,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AbsorbPointer(
                    absorbing: widget.report.status == ReportStatusType.pending
                        ? false
                        : true,
                    child: DropdownButtonFormField<ReportStatusType>(
                      value: selectedStatus,
                      icon: Icon(
                        widget.report.status == ReportStatusType.resolved
                            ? Icons.check_circle_rounded
                            : IconlyBold.arrow_down_2,
                        size: 20,
                        color: widget.report.status == ReportStatusType.resolved
                            ? Colors.green
                            : Colors.black54,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            widget.report.status == ReportStatusType.resolved
                            ? Colors.green.withOpacity(0.1)
                            : Colors.grey.shade100,
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
                      items: ReportStatusType.values.map((status) {
                        Color textColor;
                        IconData iconData;
                        switch (status) {
                          case ReportStatusType.resolved:
                            textColor = Colors.green.shade700;
                            iconData = IconlyLight.tick_square;
                            break;
                          case ReportStatusType.dismissed:
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
                                ReportModel.getLocalizedReportStatus(
                                  context,
                                  status,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: textColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (val) => setState(
                        () => selectedStatus = val ?? ReportStatusType.pending,
                      ),
                    ),
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
                  onPressed: hasChanged
                      ? () async {
                          await ReportCubit.instance.updateReport(
                            reportId: widget.report.id,
                            status: selectedStatus != widget.report.status
                                ? selectedStatus
                                : null,
                            respond:
                                responseCtrl.text.trim().isNotEmpty &&
                                    responseCtrl.text.trim() !=
                                        (widget.report.reportRespond ?? '')
                                ? responseCtrl.text.trim()
                                : null,
                          );

                          Navigator.pop(context);
                        }
                      : null, // 🔹 disables button
                  style: ElevatedButton.styleFrom(
                    backgroundColor: hasChanged ? primaryBlue : Colors.grey,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(IconlyBold.send, color: Colors.white),
                  label: Text(
                    S.current.send_response_and_update,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
