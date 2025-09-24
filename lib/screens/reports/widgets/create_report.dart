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
import 'package:uuid/uuid.dart';
import 'package:gahezha/generated/l10n.dart';

class CreateReportSheet extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;

  const CreateReportSheet({
    super.key,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<CreateReportSheet> createState() => _CreateReportSheetState();
}

class _CreateReportSheetState extends State<CreateReportSheet> {
  String? selectedReportType;
  String? selectedAssignedId;
  String? selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> assignedList = [];
  bool isShopAssigned = false;
  bool isAdminAssigned = false;
  bool isCustomerAssigned = false;
  bool isLoadingAssigned = false;

  @override
  Widget build(BuildContext context) {
    final reportTypes = currentUserType == UserType.admin
        ? adminReportTypes
        : currentUserType == UserType.shop
        ? shopReportTypes
        : customerReportTypes;

    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        // TODO: implement listener
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
                  S.current.create_report,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Report Type
                DropdownButtonFormField<String>(
                  value: selectedReportType,
                  hint: Text(
                    S.current.report_type,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  icon: const Icon(
                    IconlyBold.arrow_down_2,
                    size: 20,
                    color: Colors.black54,
                  ),
                  isExpanded: true, // prevents overflow
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
                  items: reportTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),

                  onChanged: (val) => setState(() => selectedReportType = val),
                  menuMaxHeight: 300, // fixed height for scrollable menu
                ),
                const SizedBox(height: 12),

                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Admin Button
                    if (currentUserType != UserType.admin)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: primaryBlue.withOpacity(0.1),
                            foregroundColor: primaryBlue,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: isAdminAssigned
                                  ? primaryBlue
                                  : Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoadingAssigned = true;
                              isAdminAssigned = !isAdminAssigned;
                              isShopAssigned = false;
                              isCustomerAssigned = false;
                              assignedList = [];
                              selectedAssignedId = null;
                            });

                            setState(() {
                              if (isAdminAssigned) {
                                // Admin always assigns to support team
                                assignedList = [
                                  {
                                    'id': 'support_team',
                                    'name': 'Gahezha Support Team',
                                    'image': 'assets/images/logo.svg',
                                  },
                                ];
                                selectedAssignedId = 'support_team';
                              }
                              isLoadingAssigned = false;
                            });
                          },
                          child: Text(
                            S.current.report_app,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    // Customers Button
                    if (currentUserType != UserType.customer)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: primaryBlue.withOpacity(0.1),
                            foregroundColor: primaryBlue,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: isCustomerAssigned
                                  ? primaryBlue
                                  : Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoadingAssigned = true;
                              isCustomerAssigned = !isCustomerAssigned;
                              isAdminAssigned = false;
                              isShopAssigned = false;
                              assignedList = [];
                              selectedAssignedId = null;
                            });

                            if (isCustomerAssigned) {
                              await UserCubit.instance.adminGetAllCustomers();
                            }

                            setState(() {
                              assignedList = UserCubit.instance.allCustomers;
                              isLoadingAssigned = false;
                            });
                          },
                          child: Text(
                            S.current.report_customer,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                    // Shops Button
                    if (currentUserType != UserType.shop)
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: primaryBlue.withOpacity(0.1),
                            foregroundColor: primaryBlue,
                            shadowColor: Colors.transparent,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: isShopAssigned
                                  ? primaryBlue
                                  : Colors.transparent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(radius),
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoadingAssigned = true;
                              isShopAssigned = !isShopAssigned;
                              isAdminAssigned = false;
                              isCustomerAssigned = false;
                              assignedList = [];
                              selectedAssignedId = null;
                            });

                            if (isShopAssigned) {
                              await ShopCubit.instance.adminGetAllShops();
                            }

                            setState(() {
                              assignedList = ShopCubit.instance.allShops;
                              isLoadingAssigned = false;
                            });
                          },
                          child: Text(
                            S.current.report_shop,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),

                if (isShopAssigned || isCustomerAssigned || isAdminAssigned)
                  const SizedBox(height: 15),

                // Assigned List Dropdown
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
                      isExpanded: true, // prevents overflow
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
                      items: assignedList.map((item) {
                        String id = '';
                        Widget child = const SizedBox();

                        if (item is ShopModel) {
                          id = item.id;
                          child = Row(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(IconlyLight.buy),
                              Text(item.shopName),
                            ],
                          );
                        } else if (item is UserModel) {
                          id = item.userId ?? '';
                          child = Row(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(IconlyLight.profile),
                              Text(item.fullName ?? ''),
                            ],
                          );
                        } else if (item is Map<String, dynamic>) {
                          id = item['id'];
                          child = Row(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                item['image'],
                                width: 24,
                                height: 24,
                              ),
                              Expanded(
                                child: Text(
                                  item['name'],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        }

                        return DropdownMenuItem(value: id, child: child);
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => selectedAssignedId = val),
                      menuMaxHeight: 300, // fixed height for scrollable menu
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
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 16),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        selectedReportType == null ||
                            selectedAssignedId == null ||
                            _descriptionController.text.isEmpty
                        ? null
                        : _submitReport,
                    child: Text(S.current.submit),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitReport() async {
    dynamic assignedItem = assignedList.firstWhere(
      (item) =>
          (item is ShopModel && item.id == selectedAssignedId) ||
          (item is UserModel && (item.userId ?? '') == selectedAssignedId) ||
          (item is Map<String, dynamic> && item['id'] == selectedAssignedId),
    );

    String assignedName = '';
    String assignedImage = '';

    if (assignedItem is ShopModel) {
      assignedName = assignedItem.shopName;
      assignedImage = assignedItem.shopLogo;
    } else if (assignedItem is UserModel) {
      assignedName = assignedItem.fullName ?? '';
      assignedImage = assignedItem.profileUrl ?? '';
    } else if (assignedItem is Map<String, dynamic>) {
      assignedName = assignedItem['name'];
      assignedImage = assignedItem['image'];
    }

    await ReportCubit.instance.createReport(
      reportType: selectedReportType!,
      reportDescription: _descriptionController.text,
      reporterId: widget.currentUserId,
      reporterName: widget.currentUserName,
      reporterType: currentUserType.name,
      assignedItem: assignedItem, // ShopModel / UserModel / Map
    );
    Navigator.of(context).pop(); // optionally pass back newReport if needed
  }
}
