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
  final TextEditingController _descriptionController = TextEditingController();

  List<dynamic> assignedList = [];
  bool isLoadingAssigned = false;

  @override
  Widget build(BuildContext context) {
    final reportTypes = currentUserType == UserType.admin
        ? adminReportTypes
        : currentUserType == UserType.shop
            ? shopReportTypes
            : customerReportTypes;

    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {},
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
                  items: reportTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(
                        type,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedReportType = val),
                  menuMaxHeight: 300,
                ),
                const SizedBox(height: 12),

                // Assignment Section
                if (currentUserType == UserType.admin) ...[
                  // Admin assigns to shops or customers
                  Row(
                    spacing: 5,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isLoadingAssigned = true;
                              assignedList = [];
                              selectedAssignedId = null;
                            });
                            await UserCubit.instance.adminGetAllCustomers();
                            setState(() {
                              assignedList = UserCubit.instance.allCustomers;
                              isLoadingAssigned = false;
                            });
                          },
                          child: Text(S.current.report_customer),
                        ),
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            setState(() {
                              isLoadingAssigned = true;
                              assignedList = [];
                              selectedAssignedId = null;
                            });
                            await ShopCubit.instance.adminGetAllShops();
                            setState(() {
                              assignedList = ShopCubit.instance.allShops;
                              isLoadingAssigned = false;
                            });
                          },
                          child: Text(S.current.report_shop),
                        ),
                      ),
                    ],
                  ),
                ] else if (currentUserType == UserType.shop) ...[
                  // Shop sees customers + admin
                  FutureBuilder(
                    future: UserCubit.instance.adminGetAllCustomers(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          assignedList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // Combine customers + support team
                      assignedList = [
                        {
                          'id': 'support_team',
                          'name': 'Gahezha Support Team',
                          'image': 'assets/images/logo.svg',
                        },
                        ...UserCubit.instance.allCustomers,
                      ];

                      return DropdownButtonFormField<String>(
                        value: selectedAssignedId,
                        hint: Text(
                          S.current.assign_to,
                          style: const TextStyle(color: Colors.black54),
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
                        items: assignedList.map((item) {
                          String id = '';
                          Widget child = const SizedBox();

                          if (item is UserModel) {
                            id = item.userId ?? '';
                            child = Row(
                              spacing: 8,
                              children: [
                                const Icon(IconlyLight.profile),
                                Text(item.fullName ?? ''),
                              ],
                            );
                          } else if (item is Map<String, dynamic>) {
                            id = item['id'];
                            child = Row(
                              spacing: 8,
                              children: [
                                SvgPicture.asset(
                                  item['image'],
                                  width: 24,
                                  height: 24,
                                ),
                                Text(item['name']),
                              ],
                            );
                          }
                          return DropdownMenuItem(value: id, child: child);
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => selectedAssignedId = val),
                      );
                    },
                  ),
                ] else if (currentUserType == UserType.customer) ...[
                  // Customers can assign only to shops
                  FutureBuilder(
                    future: ShopCubit.instance.adminGetAllShops(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          assignedList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      assignedList = ShopCubit.instance.allShops;

                      return DropdownButtonFormField<String>(
                        value: selectedAssignedId,
                        hint: Text(
                          S.current.assign_to,
                          style: const TextStyle(color: Colors.black54),
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
                        items: assignedList.map((item) {
                          if (item is ShopModel) {
                            return DropdownMenuItem(
                              value: item.id,
                              child: Row(
                                spacing: 8,
                                children: [
                                  const Icon(IconlyLight.buy),
                                  Text(item.shopName),
                                ],
                              ),
                            );
                          }
                          return const DropdownMenuItem(
                            value: null,
                            child: Text("Unknown"),
                          );
                        }).toList(),
                        onChanged: (val) =>
                            setState(() => selectedAssignedId = val),
                      );
                    },
                  ),
                ],

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
                    onPressed: selectedReportType == null ||
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

    await ReportCubit.instance.createReport(
      reportType: selectedReportType!,
      reportDescription: _descriptionController.text,
      reporterId: widget.currentUserId,
      reporterName: widget.currentUserName,
      reporterType: currentUserType.name,
      assignedItem: assignedItem,
    );

    Navigator.of(context).pop();
  }
}