import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/report/report_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/models/report_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/generated/l10n.dart';

class EditReportSheet extends StatefulWidget {
  final ReportModel report;

  const EditReportSheet({super.key, required this.report});

  @override
  State<EditReportSheet> createState() => _EditReportSheetState();
}

class _EditReportSheetState extends State<EditReportSheet> {
  late String selectedReportKey; // ✅ key من الـ Map
  late String? selectedAssignedId;
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> assignedList = [];
  bool isLoadingAssigned = false;
  bool isShopAssigned = false;
  bool isAdminAssigned = false;
  bool isCustomerAssigned = false;

  /// Check if data has changed
  bool get _hasChanged {
    final reportingId = widget.report.reporting.id;
    return selectedReportKey != widget.report.reportType ||
        _descriptionController.text.trim() !=
            widget.report.reportDescription.trim() ||
        selectedAssignedId != reportingId;
  }

  @override
  void initState() {
    super.initState();

    selectedReportKey = widget.report.reportType;
    _descriptionController.text = widget.report.reportDescription;
    selectedAssignedId = widget.report.reporting.id;

    final reporting = widget.report.reporting;

    // Case 1: Already assigned to support team
    if (reporting.id == 'support_team') {
      isAdminAssigned = true;
      assignedList = [
        {
          'id': 'support_team',
          'name_en': 'Gahezha Support Team', // ثابت للرفع
          'name_locale': S.current.gahezha_support_team, // معرّب للعرض
          'image': 'assets/images/logo.svg',
        },
      ];
    }
    // Case 2: If *I am the reporter* and I'm a customer → report shop
    else if (widget.report.reporter.id == uId &&
        currentUserType == UserType.customer) {
      isShopAssigned = true;
      assignedList = ShopCubit.instance.allShops;
    }
    // Case 3: If *I am the reporter* and I'm a shop → report customer
    else if (widget.report.reporter.id == uId &&
        currentUserType == UserType.shop) {
      isCustomerAssigned = true;
      assignedList = UserCubit.instance.allCustomers;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ اختار الـ Map المناسب
    final reportTypesMap = currentUserType == UserType.admin
        ? adminReportTypesMap
        : currentUserType == UserType.shop
        ? shopReportTypesMap
        : customerReportTypesMap;

    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportUpdated) {
          Navigator.of(context).pop(); // Close sheet after successful update
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.edit_report,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                /// Report Type
                DropdownButtonFormField<String>(
                  value: selectedReportKey,
                  hint: Text(
                    S.current.report_type,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  icon: const Icon(
                    IconlyBold.arrow_down_2,
                    size: 20,
                    color: Colors.black54,
                  ),
                  isExpanded: true,
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
                  // ✅ Use Map entries
                  items: reportTypesMap.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(
                        entry.value,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedReportKey = val!),
                  menuMaxHeight: 300,
                ),
                const SizedBox(height: 12),

                // Assignment Buttons
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (currentUserType != UserType.admin)
                      _buildAssignButton(
                        label: S.current.report_app,
                        active: isAdminAssigned,
                        onPressed: () {
                          setState(() {
                            isLoadingAssigned = true;
                            isAdminAssigned = true;
                            isShopAssigned = false;
                            isCustomerAssigned = false;
                            assignedList = [
                              {
                                'id': 'support_team',
                                'name_en': 'Gahezha Support Team',
                                'name_locale': S.current.gahezha_support_team,
                                'image': 'assets/images/logo.svg',
                              },
                            ];
                            selectedAssignedId = 'support_team';
                            isLoadingAssigned = false;
                          });
                        },
                      ),

                    if (currentUserType != UserType.shop)
                      _buildAssignButton(
                        label: S.current.report_shop,
                        active: isShopAssigned,
                        onPressed: () async {
                          // Fetch shops first
                          await ShopCubit.instance.adminGetAllShops();
                          setState(() {
                            isLoadingAssigned = true;
                            isShopAssigned = true;
                            isAdminAssigned = false;
                            isCustomerAssigned = false;
                            assignedList = ShopCubit.instance.allShops;
                            // reset selectedAssignedId because previous value might not exist
                            selectedAssignedId = assignedList.isNotEmpty
                                ? assignedList.first.id
                                : null;
                            isLoadingAssigned = false;
                          });
                        },
                      ),

                    if (currentUserType != UserType.customer)
                      _buildAssignButton(
                        label: S.current.report_customer,
                        active: isCustomerAssigned,
                        onPressed: () async {
                          await UserCubit.instance.adminGetAllCustomers();
                          setState(() {
                            isLoadingAssigned = true;
                            isCustomerAssigned = true;
                            isShopAssigned = false;
                            isAdminAssigned = false;
                            assignedList = UserCubit.instance.allCustomers;
                            selectedAssignedId = assignedList.isNotEmpty
                                ? assignedList.first.userId
                                : null;
                            isLoadingAssigned = false;
                          });
                        },
                      ),
                  ],
                ),
                if (isShopAssigned || isCustomerAssigned || isAdminAssigned)
                  const SizedBox(height: 15),

                // Assigned Dropdown
                if (isShopAssigned || isCustomerAssigned || isAdminAssigned)
                  AbsorbPointer(
                    absorbing:
                        currentUserType != UserType.admin &&
                        (selectedAssignedId != null &&
                            selectedAssignedId == 'support_team'),
                    child: DropdownButtonFormField<String>(
                      value: selectedAssignedId,
                      hint: Text(
                        S.current.assign_to,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      icon: isLoadingAssigned
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : currentUserType != UserType.admin &&
                                (selectedAssignedId != null &&
                                    selectedAssignedId == 'support_team')
                          ? Text("")
                          : const Icon(
                              IconlyBold.arrow_down_2,
                              size: 20,
                              color: Colors.black54,
                            ),
                      isExpanded: true,
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
                      items: assignedList
                          .map((item) {
                            String id = '';
                            Widget child = const SizedBox();
                            if (item is ShopModel) {
                              id = item.id;
                              child = Text(item.shopName);
                            } else if (item is UserModel) {
                              id = item.userId ?? '';
                              child = Text(item.fullName ?? '');
                            } else if (item is Map<String, dynamic>) {
                              id = item['id'];
                              child = Row(
                                children: [
                                  SvgPicture.asset(
                                    item['image'],
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(item['name_locale']), // ✅ يعرض حسب اللغة
                                ],
                              );
                            }
                            return DropdownMenuItem(value: id, child: child);
                          })
                          .toSet()
                          .toList(), // Remove duplicates
                      onChanged: (val) =>
                          setState(() => selectedAssignedId = val),
                      menuMaxHeight: 300,
                    ),
                  ),

                const SizedBox(height: 12),

                // Description
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: CustomTextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    title: "",
                    hint: S.current.report_description,
                  ),
                ),
                const SizedBox(height: 16),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (!_hasChanged ||
                            selectedReportKey == null ||
                            selectedAssignedId == null ||
                            _descriptionController.text.isEmpty ||
                            state is ReportLoading)
                        ? null
                        : _submitUpdate,
                    child: state is ReportLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(S.current.save_changes),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssignButton({
    required String label,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: primaryBlue.withOpacity(0.1),
          foregroundColor: primaryBlue,
          side: BorderSide(color: active ? primaryBlue : Colors.transparent),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Future<void> _submitUpdate() async {
    final assignedItem = assignedList.firstWhere(
      (item) =>
          (item is ShopModel && item.id == selectedAssignedId) ||
          (item is UserModel && (item.userId ?? '') == selectedAssignedId) ||
          (item is Map<String, dynamic> && item['id'] == selectedAssignedId),
    );

    await ReportCubit.instance.updateReport(
      reportId: widget.report.id,
      status: null,
      reportType: selectedReportKey,
      respond: null,
      assignedItem: assignedItem is Map<String, dynamic>
          ? {
              ...assignedItem,
              'name': assignedItem['name_en'], // ✅ الإنجليزي فقط للرفع
            }
          : assignedItem is ShopModel
          ? {'id': assignedItem.id, 'name': assignedItem.shopName}
          : {
              'id': (assignedItem as UserModel).userId,
              'name': assignedItem.fullName,
            },
    );
  }
}
