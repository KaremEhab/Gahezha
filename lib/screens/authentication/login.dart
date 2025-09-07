import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gahezha/constants/cache_helper.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/authentication/signup.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:iconly/iconly.dart';

import '../../generated/l10n.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bool isiOS = Platform.isIOS;

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
                    decoration: InputDecoration(
                      labelText: S.current.email,
                      prefixIcon: const Icon(IconlyLight.message),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 16),

                  /// Password + Forgot Password
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextFormField(
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
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
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
                            MaterialPageRoute(builder: (_) => const Layout()),
                          );
                        },
                        child: Text(
                          S.current.forgot_password,
                          style: const TextStyle(fontWeight: FontWeight.w500),
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Signup()),
                          );
                        },
                        child: Text(
                          S.of(context).sign_up,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
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
                /// Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      currentUserType = UserType.customer;
                      CacheHelper.saveData(
                        key: "currentUserType",
                        value: currentUserType.name,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Layout()),
                      );
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

                /// Divider with text
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[300]),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          S.current.or,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 1, color: Colors.grey[300]),
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
