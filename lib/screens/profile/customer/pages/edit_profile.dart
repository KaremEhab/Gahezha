import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/cloudinary/cloudinary_service.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:gahezha/public_widgets/pick_images.dart';
import 'package:iconly/iconly.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileSheet extends StatefulWidget {
  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  Gender selectedGender = currentUserType == UserType.shop
      ? Gender.male
      : currentUserModel!.gender;
  File? pickedImage; // الصورة اللي اتحددت
  File? bannerPickedImage; // الصورة اللي اتحددت
  File? logoPickedImage; // الصورة اللي اتحددت
  bool isUploading = false; // علشان نظهر Loader وقت الرفع

  // ✅ Common controllers (shared between customer/shop)
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  // ✅ Customer-only
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  // ✅ Shop-only
  late TextEditingController shopNameController;
  late TextEditingController categoryController;
  late TextEditingController locationController;
  late TextEditingController preparingTimeFromController;
  late TextEditingController preparingTimeToController;
  late TextEditingController openingTimeFromController;
  late TextEditingController openingTimeToController;
  late TextEditingController shopPhoneController;

  @override
  void initState() {
    super.initState();

    if (currentUserType == UserType.shop) {
      // 🏪 Shop Controllers
      shopNameController = TextEditingController(
        text: currentShopModel?.shopName ?? '',
      );
      categoryController = TextEditingController(
        text: currentShopModel?.shopCategory ?? '',
      );
      locationController = TextEditingController(
        text: currentShopModel?.shopLocation ?? '',
      );
      preparingTimeFromController = TextEditingController(
        text: "${currentShopModel?.preparingTimeFrom ?? ''} ${S.current.min}",
      );
      preparingTimeToController = TextEditingController(
        text: "${currentShopModel?.preparingTimeTo ?? ''} ${S.current.min}",
      );
      openingTimeFromController = TextEditingController(
        text: "${currentShopModel?.openingHoursFrom ?? ''} ${S.current.am}",
      );
      openingTimeToController = TextEditingController(
        text: "${currentShopModel?.openingHoursTo ?? ''} ${S.current.pm}",
      );
      shopPhoneController = TextEditingController(
        text: currentShopModel?.shopPhoneNumber ?? '',
      );

      emailController = TextEditingController(
        text: currentShopModel?.shopEmail ?? '',
      );
      phoneController = TextEditingController(
        text: currentShopModel?.shopPhoneNumber ?? '',
      );
    } else {
      // 👤 Customer Controllers
      firstNameController = TextEditingController(
        text: currentUserModel?.firstName ?? '',
      );
      lastNameController = TextEditingController(
        text: currentUserModel?.lastName ?? '',
      );
      emailController = TextEditingController(
        text: currentUserModel?.email ?? '',
      );
      phoneController = TextEditingController(
        text: currentUserModel?.phoneNumber ?? '',
      );
    }
  }

  Future<void> pickImage(ImageSource source, ImageType type) async {
    final picker = ImagePicker();
    final selectedImage = await picker.pickImage(source: source);

    if (selectedImage != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: selectedImage.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: S.current.edit_profile,
            toolbarColor: Colors.white,
            toolbarWidgetColor: primaryBlue,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: S.current.edit_profile,
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          switch (type) {
            case ImageType.customerProfile:
              pickedImage = File(croppedFile.path);
              break;
            case ImageType.shopLogo:
              logoPickedImage = File(croppedFile.path);
              break;
            case ImageType.shopBanner:
              bannerPickedImage = File(croppedFile.path);
              break;
          }
        });
      }
    } else {
      log('Image picking canceled');
    }
  }

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
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      /// Avatar
                      currentUserType == UserType.shop
                          ? buildShopAvatar()
                          : buildCustomerAvatar(),

                      const SizedBox(height: 30),

                      if (currentUserType != UserType.shop) ...[
                        /// Name
                        Row(
                          spacing: 5,
                          children: [
                            Expanded(
                              child: CustomTextField(
                                readOnly: currentUserType == UserType.guest,
                                controller: firstNameController,
                                title: S.current.first_name,
                                hint: "Kareem",
                                icon: IconlyLight.profile,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Expanded(
                              child: CustomTextField(
                                readOnly: currentUserType == UserType.guest,
                                controller: lastNameController,
                                title: S.current.last_name,
                                hint: "Ehab",
                                icon: IconlyLight.profile,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Gender
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.current.gender,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AbsorbPointer(
                              absorbing: currentUserType == UserType.guest,
                              child: DropdownButtonFormField<Gender>(
                                value: selectedGender,
                                icon: currentUserType == UserType.guest
                                    ? Text("")
                                    : const Icon(
                                        IconlyBold.arrow_down_2,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                decoration: InputDecoration(
                                  labelText: "",
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
                                  prefixIcon: const Icon(Icons.legend_toggle),
                                ),
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                items: Gender.values.map((gender) {
                                  return DropdownMenuItem<Gender>(
                                    value: gender,
                                    child: Text(
                                      lang == "en"
                                          ? gender.name.toUpperCase()
                                          : gender == Gender.male
                                          ? S.current.male
                                          : S.current.female,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) =>
                                    setState(() => selectedGender = val!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],

                      if (currentUserType == UserType.customer) ...[
                        CustomTextField(
                          controller: phoneController,
                          title: S.current.phone_number,
                          hint: "+20 111 219 0563",
                          icon: IconlyLight.call,
                          keyboardType: TextInputType.phone,
                        ),
                      ],

                      const SizedBox(height: 24),

                      /// Shop-only fields
                      if (currentUserType == UserType.shop) ...[
                        CustomTextField(
                          controller: shopNameController,
                          title: S.current.shop_name,
                          hint: S.current.enter_shop_name,
                          icon: IconlyLight.profile,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: locationController,
                          title: S.current.shop_location,
                          hint: S.current.enter_shop_location,
                          icon: IconlyLight.location,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                        /// Shop Category
                        CustomTextField(
                          controller: categoryController,
                          title: S.current.shop_category,
                          hint: S.current.enter_shop_category,
                          icon: IconlyLight.buy,
                          onTap: () async {
                            final selected = await showModalBottomSheet<String>(
                              context: context,
                              isScrollControlled: true, // مهم للسحب الكامل
                              showDragHandle: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (context) {
                                final currentCategory = categoryController.text;

                                return DraggableScrollableSheet(
                                  expand: false,
                                  initialChildSize: 0.5, // يبدأ نص الشاشة
                                  minChildSize: 0.3,
                                  maxChildSize:
                                      0.9, // يصل لأعلى الشاشة عند السحب
                                  builder: (context, scrollController) {
                                    return SafeArea(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Title
                                            const Text(
                                              "Choose a Category",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 20),

                                            // Categories Grid
                                            Expanded(
                                              child: GridView.builder(
                                                controller:
                                                    scrollController, // مهم للتمرير
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 16,
                                                      crossAxisSpacing: 16,
                                                      childAspectRatio: 2,
                                                    ),
                                                itemCount: categories.length,
                                                itemBuilder: (context, index) {
                                                  final c = categories[index];
                                                  final isSelected =
                                                      c["name"] ==
                                                      currentCategory;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(
                                                        context,
                                                        c["name"] as String,
                                                      );
                                                      FocusScope.of(
                                                        context,
                                                      ).unfocus();
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? primaryBlue
                                                            : primaryBlue
                                                                  .withOpacity(
                                                                    0.08,
                                                                  ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                      ),
                                                      child: Column(
                                                        spacing: 8,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            c["icon"]
                                                                as IconData,
                                                            color: isSelected
                                                                ? Colors.white
                                                                : primaryBlue,
                                                          ),
                                                          Text(
                                                            c["name"] as String,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: isSelected
                                                                  ? Colors.white
                                                                  : Colors
                                                                        .black87,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
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
                          S.current.preparing_time,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: preparingTimeFromController,
                                title: "",
                                hint: "24",
                                icon: IconlyLight.time_circle,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                controller: preparingTimeToController,
                                title: "",
                                hint: "38",
                                icon: IconlyLight.time_circle,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        /// Opening Hours (From - To)
                        Text(
                          S.current.opening_hours,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: openingTimeFromController,
                                title: "",
                                hint: "10 ${S.current.am}",
                                icon: IconlyLight.time_circle,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                controller: openingTimeToController,
                                title: "",
                                hint: "11 ${S.current.pm}",
                                icon: IconlyLight.time_circle,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: shopPhoneController,
                          title: S.current.phone_number,
                          hint: "+20 111 219 0563",
                          icon: IconlyLight.call,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),

              /// Save Button
              ?currentUserType == UserType.guest
                  ? null
                  : SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            String? profileUrl;
                            String? bannerUrl;
                            String? logoUrl;
                            if (currentUserModel != null) {
                              profileUrl = currentUserModel!.profileUrl;
                            }
                            if (currentShopModel != null) {
                              bannerUrl = currentShopModel!.shopBanner;
                              logoUrl = currentShopModel!.shopLogo;
                            }

                            // ✅ لو في صورة جديدة اترفعت
                            if (pickedImage != null ||
                                logoPickedImage != null ||
                                bannerPickedImage != null) {
                              setState(() => isUploading = true);

                              final cloudinaryService = CloudinaryService();

                              if (currentUserType == UserType.customer ||
                                  currentUserType == UserType.admin) {
                                if (pickedImage != null) {
                                  final url = await cloudinaryService
                                      .uploadImage(
                                        pickedImage!,
                                        folder:
                                            currentUserType == UserType.admin
                                            ? "adminProfile"
                                            : "profiles", // ✨ صور العملاء
                                      );
                                  if (url != null) profileUrl = url;
                                }
                              } else if (currentUserType == UserType.shop) {
                                if (logoPickedImage != null) {
                                  final url = await cloudinaryService
                                      .uploadImage(
                                        logoPickedImage!,
                                        folder: "logos", // ✨ لوجوهات المحلات
                                      );
                                  if (url != null) logoUrl = url;
                                }
                                if (bannerPickedImage != null) {
                                  final url = await cloudinaryService
                                      .uploadImage(
                                        bannerPickedImage!,
                                        folder: "banners", // ✨ بانرات المحلات
                                      );
                                  if (url != null) bannerUrl = url;
                                }
                              }

                              setState(() => isUploading = false);
                            }

                            // ✅ بناءً على نوع المستخدم
                            if (currentUserType == UserType.customer ||
                                currentUserType == UserType.admin ||
                                currentUserType == UserType.guest) {
                              // ✨ تحديث بيانات المستخدم
                              UserCubit.instance.editUserData(
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                gender: selectedGender,
                                profileUrl:
                                    profileUrl ?? currentUserModel!.profileUrl,
                                phoneNumber: phoneController.text.trim(),
                              );
                            } else if (currentUserType == UserType.shop) {
                              // ✨ تحديث بيانات المحل
                              ShopCubit.instance.editShopData(
                                shopName: shopNameController.text.trim(),
                                shopCategory: categoryController.text,
                                shopLocation: locationController.text.trim(),
                                shopPhoneNumber: shopPhoneController.text
                                    .trim(),
                                shopLogo: logoUrl ?? currentShopModel!.shopLogo,
                                shopBanner:
                                    bannerUrl ?? currentShopModel!.shopBanner,
                                preparingTimeFrom: int.tryParse(
                                  preparingTimeFromController.text,
                                ),
                                preparingTimeTo: int.tryParse(
                                  preparingTimeToController.text,
                                ),
                                openingHoursFrom: int.tryParse(
                                  openingTimeFromController.text,
                                ),
                                openingHoursTo: int.tryParse(
                                  openingTimeToController.text,
                                ),
                              );
                            }

                            if (context.mounted) {
                              Navigator.pop(context, {
                                "profileUrl": profileUrl,
                                "logoUrl": logoUrl,
                                "bannerUrl": bannerUrl,
                              });
                            }
                          },
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
            ],
          ),
        );
      },
    );
  }

  // --- Extracted widgets for clarity ---
  Widget buildShopAvatar() {
    return Center(
      child: Container(
        height: 250,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: Stack(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: bannerPickedImage != null
                      ? Image.file(bannerPickedImage!, fit: BoxFit.cover)
                      : Image.network(
                          currentShopModel!.shopBanner,
                          fit: BoxFit.cover,
                        ),
                ),
                Container(color: Colors.black.withOpacity(0.5)),
                if (logoPickedImage == null)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Material(
                      shape: const CircleBorder(),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(200),
                        onTap: () => showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder: (_) {
                            return PickImageSource(
                              cameraButton: () async {
                                Navigator.pop(context);
                                await pickImage(
                                  ImageSource.camera,
                                  ImageType.shopBanner,
                                );
                              },
                              galleryButton: () async {
                                Navigator.pop(context);
                                await pickImage(
                                  ImageSource.gallery,
                                  ImageType.shopBanner,
                                );
                              },
                            );
                          },
                        ),
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
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: logoPickedImage != null
                                ? FileImage(logoPickedImage!) as ImageProvider
                                : NetworkImage(currentShopModel!.shopLogo),
                          ),
                          if (isUploading)
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: primaryBlue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (bannerPickedImage == null)
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: Material(
                          shape: const CircleBorder(),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(200),
                            onTap: () => showModalBottomSheet(
                              showDragHandle: true,
                              context: context,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) {
                                return PickImageSource(
                                  cameraButton: () async {
                                    Navigator.pop(context);
                                    await pickImage(
                                      ImageSource.camera,
                                      ImageType.shopLogo,
                                    );
                                  },
                                  galleryButton: () async {
                                    Navigator.pop(context);
                                    await pickImage(
                                      ImageSource.gallery,
                                      ImageType.shopLogo,
                                    );
                                  },
                                );
                              },
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: primaryBlue,
                                  strokeAlign: BorderSide.strokeAlignInside,
                                ),
                              ),
                              child: Icon(
                                IconlyBold.profile,
                                color: primaryBlue,
                              ),
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

  Widget buildCustomerAvatar() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 85,
            backgroundColor: primaryBlue.withOpacity(0.3),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: pickedImage != null
                      ? FileImage(pickedImage!) as ImageProvider
                      : NetworkImage(currentUserModel!.profileUrl),
                ),
                if (isUploading)
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(color: primaryBlue),
                    ),
                  ),
              ],
            ),
          ),
          if (currentUserType != UserType.guest)
            Positioned(
              bottom: 5,
              right: 5,
              child: Material(
                shape: const CircleBorder(),
                child: InkWell(
                  borderRadius: BorderRadius.circular(200),
                  onTap: () => showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) {
                      return PickImageSource(
                        cameraButton: () async {
                          Navigator.pop(context);
                          await pickImage(
                            ImageSource.camera,
                            ImageType.customerProfile,
                          );
                        },
                        galleryButton: () async {
                          Navigator.pop(context);
                          await pickImage(
                            ImageSource.gallery,
                            ImageType.customerProfile,
                          );
                        },
                      );
                    },
                  ),
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
}
