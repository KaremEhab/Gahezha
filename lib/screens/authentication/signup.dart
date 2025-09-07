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
import 'package:gahezha/screens/layout/layout.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/generated/l10n.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key, this.isShop = false});

  final bool isShop;

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
  TextEditingController _shopCategory = TextEditingController();
  TextEditingController _shopLocation = TextEditingController();
  TextEditingController _preparingTimeFrom = TextEditingController();
  TextEditingController _preparingTimeTo = TextEditingController();
  TextEditingController _openingHoursFrom = TextEditingController();
  TextEditingController _openingHoursTo = TextEditingController();
  TextEditingController _shopPhoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isiOS = Platform.isIOS;

    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if (state is SignupSuccessState) {
          // Navigate to layout after success
          if (widget.isShop) {
            currentUserType = UserType.shop;
          } else {
            currentUserType = UserType.customer;
          }
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Layout()),
            );
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    /// Logo
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/logo.svg',
                        height: 100,
                      ),
                    ),

                    const SizedBox(height: 50),

                    if (widget.isShop) ...[
                      /// Shop Name
                      CustomTextField(
                        controller: _shopName,
                        title: "Shop Name",
                        hint: "Enter your shop name",
                        icon: Icons.storefront,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Email
                      CustomTextField(
                        controller: _shopEmail,
                        title: "Shop Email",
                        hint: "Enter your shop email",
                        icon: IconlyLight.message,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Category
                      CustomTextField(
                        controller: _shopCategory,
                        title: "Category",
                        hint: "Enter shop category",
                        icon: IconlyLight.category,
                      ),

                      const SizedBox(height: 16),

                      /// Shop Location
                      CustomTextField(
                        controller: _shopLocation,
                        title: "Location",
                        hint: "Enter shop location",
                        icon: IconlyLight.location,
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
                              controller: _preparingTimeFrom,
                              title: "",
                              hint: "e.g. 24",
                              icon: IconlyLight.time_circle,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _preparingTimeTo,
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
                              controller: _openingHoursFrom,
                              title: "",
                              hint: "e.g. 10 AM",
                              icon: IconlyLight.time_circle,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _openingHoursTo,
                              title: "",
                              hint: "e.g. 11 PM",
                              icon: IconlyLight.time_circle,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Shop Phone Number
                      CustomTextField(
                        controller: _shopPhoneNumber,
                        title: "Phone Number",
                        hint: "Enter shop phone number",
                        icon: IconlyLight.call,
                        keyboardType: TextInputType.phone,
                      ),
                    ] else
                      Column(
                        spacing: 16,
                        children: [
                          /// Full Name
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
                          CustomTextField(
                            controller: _email,
                            title: "Email",
                            hint: "Enter your email",
                            icon: IconlyLight.message,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false, // initial obscure state
                          ),

                          /// Email
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
                                      gender.name.toUpperCase(),
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

                          /// Password
                          CustomTextField(
                            controller: _phoneNumber,
                            title: "Phone Number",
                            hint: "+20 111 219 0563",
                            icon: IconlyLight.call,
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

                    const SizedBox(height: 10),

                    /// Already have account → Login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(S.of(context).already_have_account),
                        TextButton(
                          onPressed: () {
                            navigateReplacement(
                              context: context,
                              screen: const Login(),
                            );
                          },
                          child: Text(
                            S.of(context).login,
                            style: const TextStyle(fontWeight: FontWeight.w600),
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
                          final firstName = _firstName.text.trim();
                          final lastName = _lastName.text.trim();
                          final email = _email.text.trim();
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

                          if (widget.isShop) {
                            final shopName = _shopName.text.trim();
                            final shopEmail = _shopEmail.text.trim();

                            // Sign up user first
                            SignupCubit.instance.userSignup(
                              email: email,
                              password: password,
                              firstName: firstName,
                              lastName: lastName,
                              gender: selectedGender,
                            );

                            // Then create shop document
                            final uid = FirebaseAuth.instance.currentUser?.uid;
                            if (uid != null) {
                              //   await FirebaseFirestore.instance
                              //       .collection('shops')
                              //       .doc(uid)
                              //       .set({
                              //         'shopName': shopName,
                              //         'shopEmail': shopEmail,
                              //         'shopStatus': selectedShopStatus,
                              //         'shopProfileUrl': _shopProfileUrl.text,
                              //         'shopBannerUrl': _shopBannerUrl.text,
                              //         'shopCategory': _shopCategory.text,
                              //         'shopLocation': _shopLocation.text,
                              //         'shopPreparingTime': _shopPreparingTime.text,
                              //         'shopOpeningHours': _shopOpeningHours.text,
                              //         'shopPhoneNumber': _shopPhoneNumber.text,
                              //         'ownerId': uid,
                              //         'createdAt': FieldValue.serverTimestamp(),
                              //       });
                              // }
                            } else {
                              // Normal user signup
                              SignupCubit.instance.userSignup(
                                email: email,
                                password: password,
                                firstName: firstName,
                                lastName: lastName,
                                gender: selectedGender,
                              );
                            }

                            // Navigate to layout after success
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Layout(),
                                ),
                              );
                            }
                          } else {
                            // Normal user signup
                            SignupCubit.instance.userSignup(
                              email: email,
                              password: password,
                              firstName: firstName,
                              lastName: lastName,
                              gender: selectedGender,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              S.of(context).or,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Social buttons
                    if (isiOS)
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              icon: "assets/icons/google-icon.svg",
                              text: S.of(context).google,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SocialButton(
                              icon: "assets/icons/apple-icon.svg",
                              text: S.of(context).apple,
                              onTap: () {},
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: _SocialButton(
                          icon: "assets/icons/google-icon.svg",
                          text: S.of(context).continue_with_google,
                          onTap: () {},
                        ),
                      ),
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
