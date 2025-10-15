import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/authentication/signup/signup_cubit.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:gahezha/screens/google_maps/map_screen.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/generated/l10n.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({
    super.key,
    this.referrerId = "",
    this.uId = "",
    this.username = "",
    this.email = "",
    this.isShop = false,
    this.isGoogle = false,
    this.isGuestMode = false,
  });

  final String referrerId, uId, username, email;
  final bool isShop, isGoogle, isGuestMode;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Gender selectedGender = Gender.male;

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  TextEditingController _shopName = TextEditingController();
  TextEditingController _shopEmail = TextEditingController();
  TextEditingController _shopPassword = TextEditingController();
  TextEditingController _shopConfirmPassword = TextEditingController();
  TextEditingController _shopCategory = TextEditingController();
  TextEditingController _shopLocation = TextEditingController();
  TextEditingController _preparingTimeFrom = TextEditingController();
  TextEditingController _preparingTimeTo = TextEditingController();
  TextEditingController _openingHoursFrom = TextEditingController();
  TextEditingController _openingHoursTo = TextEditingController();
  TextEditingController _shopPhoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    String username = widget.username;
    String email = widget.email;

    if (widget.isGoogle) {
      _firstName.text = username;
      _lastName.text = "";
      _email.text = email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isiOS = Platform.isIOS;

    log("${widget.referrerId} Reportssssssssss");

    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (widget.isGoogle
            ? state is SignupCreateUserSuccessState
            : state is SignupSuccessState) {
          // Navigate to layout after success
          if (widget.isShop) {
            currentUserType = UserType.shop;
          } else {
            currentUserType = UserType.customer;
          }
          if (context.mounted) {
            navigateAndFinish(context: context, screen: const Layout());
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: widget.isGuestMode
                ? AppBar(
                    backgroundColor: Colors.white,
                    forceMaterialTransparency: true,
                    elevation: 0,
                    title: Text(S.current.sign_up),
                  )
                : null,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: widget.isGuestMode ? 10 : 50),

                    /// Logo
                    if (!widget.isGuestMode)
                      Center(
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 100,
                        ),
                      ),

                    if (!widget.isGuestMode) const SizedBox(height: 50),

                    if (widget.isShop) ...[
                      /// Shop Name
                      CustomTextField(
                        controller: _shopName,
                        title: S.current.shop_name,
                        hint: S.current.enter_shop_name,
                        icon: Icons.storefront,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Category
                      CustomTextField(
                        controller: _shopCategory,
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
                              final currentCategory = _shopCategory.text;

                              return DraggableScrollableSheet(
                                expand: false,
                                initialChildSize: 0.5, // يبدأ نص الشاشة
                                minChildSize: 0.3,
                                maxChildSize: 0.9, // يصل لأعلى الشاشة عند السحب
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
                                                          c["icon"] as IconData,
                                                          color: isSelected
                                                              ? Colors.white
                                                              : primaryBlue,
                                                        ),
                                                        Text(
                                                          c["name"] as String,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
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
                              _shopCategory.text = selected;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      /// Shop Location
                      CustomTextField(
                        controller: _shopLocation,
                        title: S.current.shop_location,
                        hint: S.current.enter_shop_location,
                        icon: IconlyLight.location,
                        // onTap: () {
                        //   navigateTo(context: context, screen: MapScreen());
                        // },
                      ),

                      const SizedBox(height: 16),

                      /// Preparing Time (From - To)
                      Text(
                        "${S.current.preparing_time} (${S.current.minuets})",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _preparingTimeFrom,
                              title: "",
                              hint: "24",
                              icon: IconlyLight.time_circle,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _preparingTimeTo,
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _openingHoursFrom,
                              title: "",
                              hint: "10 ${S.current.am}",
                              icon: IconlyLight.time_circle,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _openingHoursTo,
                              title: "",
                              hint: "11 ${S.current.pm}",
                              icon: IconlyLight.time_circle,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Shop Phone Number
                      CustomTextField(
                        controller: _shopPhoneNumber,
                        title: S.current.phone_number,
                        hint: "+20 111 219 0563",
                        icon: IconlyLight.call,
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Email
                      CustomTextField(
                        controller: _shopEmail,
                        title: S.current.email,
                        hint: S.current.enter_your_email,
                        icon: IconlyLight.message,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Password
                      CustomTextField(
                        controller: _shopPassword,
                        title: S.current.password,
                        hint: S.current.enter_your_password,
                        icon: IconlyLight.lock,
                        obscureText: true, // initial obscure state
                        keyboardType: TextInputType.text,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Confirm Password
                      CustomTextField(
                        controller: _shopConfirmPassword,
                        title: S.current.confirm_password_title,
                        hint: S.current.reEnter_password,
                        icon: IconlyLight.lock,
                        obscureText: true, // initial obscure state
                        keyboardType: TextInputType.text,
                      ),
                    ] else
                      Column(
                        spacing: 16,
                        children: [
                          /// Full Name
                          if (!widget.isGoogle)
                            Row(
                              spacing: 5,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: _firstName,
                                    title: "First Name",
                                    hint: "Kareem",
                                    icon: IconlyLight.profile,
                                    keyboardType: TextInputType.text,
                                    obscureText: false, // initial obscure state
                                  ),
                                ),
                                Expanded(
                                  child: CustomTextField(
                                    controller: _lastName,
                                    title: "Last Name",
                                    hint: "Ehab",
                                    icon: IconlyLight.profile,
                                    keyboardType: TextInputType.text,
                                    obscureText: false, // initial obscure state
                                  ),
                                ),
                              ],
                            ),

                          /// Email
                          if (!widget.isGoogle)
                            CustomTextField(
                              controller: _email,
                              title: "Email",
                              hint: "Enter your email",
                              icon: IconlyLight.message,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false, // initial obscure state
                            ),

                          /// Gender
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<Gender>(
                                value: selectedGender,
                                icon: const Icon(
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
                            ],
                          ),

                          /// Phone Number
                          CustomTextField(
                            controller: _phoneNumber,
                            title: "Phone Number",
                            hint: "+20 111 219 0563",
                            icon: IconlyLight.call,
                            keyboardType: TextInputType.phone,
                          ),

                          /// Password
                          CustomTextField(
                            controller: _password,
                            title: "Password",
                            hint: "Enter your password",
                            icon: IconlyLight.lock,
                            obscureText: true, // initial obscure state
                          ),

                          /// Confirm Password
                          CustomTextField(
                            controller: _confirmPassword,
                            title: "Confirm Password",
                            hint: "Re-enter your password",
                            icon: IconlyLight.lock,
                            obscureText: true, // initial obscure state
                          ),
                        ],
                      ),

                    // const SizedBox(height: 10),

                    /// Already have account → Login
                    if (!widget.isGoogle)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.of(context).already_have_account),
                          TextButton(
                            onPressed: () {
                              navigateAndFinish(
                                context: context,
                                screen: const Login(),
                              );
                            },
                            child: Text(
                              S.of(context).login,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 10),

                    /// Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!widget.isShop) {
                            // Normal user signup
                            final firstName = _firstName.text.trim();
                            final lastName = _lastName.text.trim();
                            final email = _email.text.trim();
                            final phoneNumber = _phoneNumber.text.trim();
                            final password = _password.text;
                            final confirmPassword = _confirmPassword.text;

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match"),
                                ),
                              );
                              return;
                            }

                            if (!widget.isGoogle) {
                              SignupCubit.instance.userSignup(
                                email: email,
                                password: password,
                                firstName: firstName,
                                lastName: lastName,
                                phoneNumber: phoneNumber,
                                gender: selectedGender,
                              );
                            } else {
                              SignupCubit.instance.userCreate(
                                userId: widget.uId,
                                firstName: firstName,
                                lastName: lastName,
                                phoneNumber: phoneNumber,
                                gender: selectedGender,
                                email: email,
                              );
                              ;
                            }
                          } else {
                            // Shop signup
                            final shopName = _shopName.text.trim();
                            final shopCategory = _shopCategory.text.trim();
                            final shopLocation = _shopLocation.text.trim();
                            final preparingFrom =
                                int.tryParse(_preparingTimeFrom.text) ?? 0;
                            final preparingTo =
                                int.tryParse(_preparingTimeTo.text) ?? 0;
                            final openingFrom =
                                int.tryParse(_openingHoursFrom.text) ?? 0;
                            final openingTo =
                                int.tryParse(_openingHoursTo.text) ?? 0;
                            final shopPhone = _shopPhoneNumber.text.trim();
                            final shopEmail = _shopEmail.text.trim();
                            final password = _shopPassword.text;
                            final confirmPassword = _shopConfirmPassword.text;

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Passwords do not match"),
                                ),
                              );
                              return;
                            }

                            SignupCubit.instance.shopSignup(
                              email: shopEmail,
                              password: password,
                              shopName: shopName,
                              shopCategory: shopCategory,
                              shopLocation: shopLocation,
                              preparingTimeFrom: preparingFrom,
                              preparingTimeTo: preparingTo,
                              openingHoursFrom: openingFrom,
                              openingHoursTo: openingTo,
                              shopPhoneNumber: shopPhone,
                              referredByUserId: widget.referrerId,
                            );
                          }
                        },
                        child: Text(
                          S.of(context).sign_up,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    /// Divider
                    // if (!widget.isGoogle)
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(vertical: 14),
                    //     child: Row(
                    //       children: [
                    //         Expanded(
                    //           child: Divider(
                    //             thickness: 1,
                    //             color: Colors.grey[300],
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 8,
                    //           ),
                    //           child: Text(
                    //             S.of(context).or,
                    //             style: TextStyle(color: Colors.grey[600]),
                    //           ),
                    //         ),
                    //         Expanded(
                    //           child: Divider(
                    //             thickness: 1,
                    //             color: Colors.grey[300],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),

                    /// Social buttons
                    // if (!widget.isGoogle)
                    //   if (isiOS)
                    //     Row(
                    //       children: [
                    //         Expanded(
                    //           child: _SocialButton(
                    //             icon: "assets/icons/google-icon.svg",
                    //             text: S.of(context).google,
                    //             onTap: () {},
                    //           ),
                    //         ),
                    //         const SizedBox(width: 12),
                    //         Expanded(
                    //           child: _SocialButton(
                    //             icon: "assets/icons/apple-icon.svg",
                    //             text: S.of(context).apple,
                    //             onTap: () {},
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    //   else
                    //     SizedBox(
                    //       width: double.infinity,
                    //       child: _SocialButton(
                    //         icon: "assets/icons/google-icon.svg",
                    //         text: S.of(context).continue_with_google,
                    //         onTap: () {},
                    //       ),
                    //     ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey.shade300),
      ),
      icon: SvgPicture.asset(icon, width: 22),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}
