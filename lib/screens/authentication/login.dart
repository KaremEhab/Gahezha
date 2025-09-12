import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/authentication/login/login_cubit.dart';
import 'package:gahezha/cubits/authentication/signup/signup_cubit.dart';
import 'package:gahezha/models/shop_model.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:gahezha/waiting_for_approval.dart';
import 'package:iconly/iconly.dart';

import '../../generated/l10n.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>(); // ✅ Form key
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isiOS = Platform.isIOS;

    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          if (context.mounted) {
            if (currentUserType == UserType.shop) {
              if (currentShopModel!.shopAcceptanceStatus ==
                  ShopAcceptanceStatus.accepted) {
                log('user id: $uId');
                navigateAndFinish(context: context, screen: const Layout());
              } else {
                if (!mounted) return;
                navigateAndFinish(
                  context: context,
                  screen: const WaitingForApprovalPage(),
                );
              }
            } else {
              log('user id: $uId');
              navigateAndFinish(context: context, screen: const Layout());
            }
          }
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () =>
              FocusScope.of(context).unfocus(), // 🔹 Unfocus on tap outside
          child: Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  // 🔹 Make scrollable
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey, // ✅ Attach form key
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),

                        /// Logo
                        Center(
                          child: SvgPicture.asset(
                            'assets/images/logo.svg',
                            height: 120,
                          ),
                        ),

                        const SizedBox(height: 60),

                        /// Welcome text
                        Center(
                          child: Column(
                            children: [
                              Text(
                                S.current.welcome_back,
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                S.current.login_continue,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// Email Field
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: S.current.email,
                            prefixIcon: const Icon(IconlyLight.message),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Email can't be empty";
                            }
                            // Optional: add basic email format check
                            if (!RegExp(
                              r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value.trim())) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        /// Password + Forgot Password
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              controller: _password,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: S.current.password,
                                prefixIcon: const Icon(IconlyLight.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? IconlyLight.show
                                        : IconlyLight.hide,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Password can't be empty";
                                }
                                if (value.trim().length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null;
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                currentUserType = UserType.admin;
                                CacheHelper.saveData(
                                  key: "currentUserType",
                                  value: currentUserType.name,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const Layout(),
                                  ),
                                );
                              },
                              child: Text(
                                S.current.forgot_password,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        /// Already have account → Login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context).dont_have_account),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                  context: context,
                                  screen: const Signup(),
                                );
                              },
                              child: Text(
                                S.of(context).sign_up,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decorationColor: primaryBlue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(S.current.or),
                            TextButton(
                              onPressed: () {
                                navigateTo(
                                  context: context,
                                  screen: const Signup(isShop: true),
                                );
                              },
                              child: Text(
                                S.current.create_shop,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  decorationColor: primaryBlue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Login Button
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        spacing: 5,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                LoginCubit.instance.guestLogin();
                              },
                              child: Text(
                                S.current.guest,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: () {
                                // ✅ Validate before login
                                if (_formKey.currentState!.validate()) {
                                  LoginCubit.instance.userLogin(
                                    email: _email.text.trim(),
                                    password: _password.text.trim(),
                                  );
                                } else {
                                  // Optional: show snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please fill all fields"),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                S.current.login,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Divider with text
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
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
                              S.current.or,
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

                    /// Social login buttons
                    if (isiOS)
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              icon: "assets/icons/google-icon.svg",
                              text: S.current.google,
                              onTap: () {
                                // TODO: implement Google Sign-In
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SocialButton(
                              icon: "assets/icons/apple-icon.svg",
                              text: S.current.apple,
                              onTap: () {
                                // TODO: implement Apple Sign-In
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: _SocialButton(
                          icon: "assets/icons/google-icon.svg",
                          text: S.current.continue_with_google,
                          onTap: () {
                            currentUserType = UserType.shop;
                            CacheHelper.saveData(
                              key: "currentUserType",
                              value: currentUserType.name,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const Layout()),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 40),
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
