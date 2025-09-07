import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  final nameController = TextEditingController(text: "John Doe");
  final emailController = TextEditingController(text: "johndoe@gmail.com");

  // Shop-only controllers
  final categoryController = TextEditingController(text: "Fast Food");
  final locationController = TextEditingController(text: "Cairo, Egypt");
  final preparingTimeController = TextEditingController(
    text: "~ 24 - 38 Minutes",
  );
  final openingTimeController = TextEditingController(
    text: "Opens from 10 AM - 11 PM",
  );
  final phoneController = TextEditingController(text: "+20 111 219 0563");

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.6,
      builder: (context, scrollController) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Avatar
                  currentUserType == UserType.customer
                      ? buildCustomerAvatar()
                      : buildShopAvatar(),

                  const SizedBox(height: 30),

                  /// Name
                  CustomTextField(
                    controller: nameController,
                    title: S.current.full_name,
                    hint: S.current.full_name,
                    icon: IconlyLight.profile,
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 16),

                  /// Email
                  CustomTextField(
                    controller: emailController,
                    title: S.current.email,
                    hint: S.current.enter_your_email,
                    icon: IconlyLight.message,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 24),

                  /// Shop-only fields
                  if (currentUserType == UserType.shop) ...[
                    CustomTextField(
                      controller: locationController,
                      title: "Shop Location",
                      hint: "Enter shop location",
                      icon: IconlyLight.location,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 16),

                    /// Shop Category
                    CustomTextField(
                      controller: categoryController,
                      title: "Shop Category",
                      hint: "Select shop category",
                      icon: IconlyLight.buy,
                      onTap: () async {
                        final selected = await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (context) {
                            final categories = [
                              {"name": "Fast Food", "icon": Icons.fastfood},
                              {"name": "Bakery", "icon": Icons.cake},
                              {"name": "Cafe", "icon": Icons.local_cafe},
                              {"name": "Supermarket", "icon": Icons.store},
                            ];

                            final currentCategory = categoryController.text;

                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Handle bar
                                  Container(
                                    width: 50,
                                    height: 5,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),

                                  // Title
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Choose a Category",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),

                                  // Categories Grid
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 16,
                                          crossAxisSpacing: 16,
                                          childAspectRatio: 3,
                                        ),
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      final c = categories[index];
                                      final isSelected =
                                          c["name"] == currentCategory;

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pop(
                                            context,
                                            c["name"] as String,
                                          );
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? primaryBlue // selected background
                                                : primaryBlue.withOpacity(0.08),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                c["icon"] as IconData,
                                                color: isSelected
                                                    ? Colors.white
                                                    : primaryBlue,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                c["name"] as String,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        if (selected != null) {
                          setState(() {
                            categoryController.text = selected;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    /// Preparing Time (From - To)
                    Text(
                      "Preparing Time",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: "24 min"),
                            title: "",
                            hint: "e.g. 24",
                            icon: IconlyLight.time_circle,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: "38 min"),
                            title: "",
                            hint: "e.g. 38",
                            icon: IconlyLight.time_circle,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    /// Opening Hours (From - To)
                    Text(
                      "Opening Hours",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: "10 AM"),
                            title: "",
                            hint: "e.g. 10 AM",
                            icon: IconlyLight.time_circle,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: TextEditingController(text: "11 PM"),
                            title: "",
                            hint: "e.g. 11 PM",
                            icon: IconlyLight.time_circle,
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: phoneController,
                      title: "Phone Number",
                      hint: "Enter shop phone number",
                      icon: IconlyLight.call,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),

            /// Save Button
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(S.current.save_changes),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- Extracted widgets for clarity ---
Widget buildCustomerAvatar() {
  return Center(
    child: Container(
      height: 250,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        children: [
          InkWell(
            onTap: () => log("Cover image tapped"),
            child: Stack(
              children: [
                CustomCachedImage(
                  imageUrl: "https://picsum.photos/600/300",
                  height: double.infinity,
                ),
                Container(color: Colors.black.withOpacity(0.5)),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Material(
                    shape: const CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(200),
                      onTap: () => log("Cover edit tapped"),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryBlue,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        child: Icon(IconlyBold.ticket, color: primaryBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: primaryBlue.withOpacity(0.3),
                    child: const CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/200",
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Material(
                      shape: const CircleBorder(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(200),
                        onTap: () => log("Avatar edit tapped"),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryBlue,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: Icon(IconlyBold.profile, color: primaryBlue),
                        ),
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

Widget buildShopAvatar() {
  return Center(
    child: Stack(
      children: [
        CircleAvatar(
          radius: 85,
          backgroundColor: primaryBlue.withOpacity(0.3),
          child: const CircleAvatar(
            radius: 80,
            backgroundImage: NetworkImage("https://picsum.photos/200"),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Material(
            shape: const CircleBorder(),
            child: InkWell(
              borderRadius: BorderRadius.circular(200),
              onTap: () => log("Shop avatar edit tapped"),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: primaryBlue,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Icon(IconlyBold.edit, color: primaryBlue),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
