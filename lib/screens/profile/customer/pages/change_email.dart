import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldEmailController = TextEditingController();
  final _newEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(S.current.change_email)),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryBlue.withOpacity(0.05),
                      primaryBlue.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.change_your_email_title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      S.current.change_your_email_subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _oldEmailController,
                      title: S.current.old_email_title,
                      hint: S.current.old_email,
                      icon: IconlyLight.message,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _newEmailController,
                      title: S.current.new_email_title,
                      hint: S.current.new_email,
                      icon: IconlyLight.message,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      title: S.current.password,
                      hint: S.current.enter_your_password,
                      icon: IconlyLight.lock,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final oldEmail = _oldEmailController.text.trim();
                  final newEmail = _newEmailController.text.trim();
                  final password = _passwordController.text.trim();

                  log(oldEmail);
                  log(newEmail);
                  log(password);

                  // UserCubit.instance.changeEmail(
                  //   oldEmail: oldEmail,
                  //   newEmail: newEmail,
                  //   password: password,
                  // );

                  log("Success");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius),
                ),
                elevation: 4,
                shadowColor: primaryBlue.withOpacity(0.4),
              ),
              child: Text(
                S.current.submit,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
