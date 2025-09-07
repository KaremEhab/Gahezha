import 'package:flutter/material.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart';

class ReportDetailsSheet extends StatefulWidget {
  final String reportId;
  final String title;
  final String type;
  final String description;
  final String date;
  final String status;
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
  String selectedStatus = "Pending";

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.status;
  }

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
                      "Report #${widget.reportId} • ${widget.type}",
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
                "Report Status",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
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
                items: ["Pending", "Resolved", "Dismissed"].map((status) {
                  Color textColor;
                  switch (status) {
                    case "Resolved":
                      textColor = Colors.green.shade700;
                      break;
                    case "Dismissed":
                      textColor = Colors.grey.shade700;
                      break;
                    default: // Pending
                      textColor = Colors.orange.shade700;
                  }

                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(
                          status == "Resolved"
                              ? IconlyLight.tick_square
                              : status == "Dismissed"
                              ? IconlyLight.close_square
                              : IconlyLight.time_circle,
                          color: textColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          status,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedStatus = val!),
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
                  title: "Respond to Reporter",
                  hint: "Type your response here...",
                  keyboardType: TextInputType.text,
                ),
              ),
              // Text(
              //   "Respond to Reporter",
              //   style: Theme.of(
              //     context,
              //   ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8),
              // TextField(
              //   controller: responseCtrl,
              //   maxLines: 4,
              //   decoration: InputDecoration(
              //     hintText: "Type your response here...",
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              // ),
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
              label: const Text(
                "Send Response & Update",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
