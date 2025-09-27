import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/cubits/user/user_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/form_field.dart';
import 'package:iconly/iconly.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(S.current.change_password),
          ),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.current.change_your_password_title,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          S.current.change_your_password_subtitle,
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
                          controller: _passwordController,
                          title: S.current.password,
                          hint: S.current.enter_your_password,
                          icon: IconlyLight.lock,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _newPasswordController,
                          title: S.current.new_password_title,
                          hint: S.current.new_password,
                          icon: IconlyLight.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _confirmPassController,
                          title: S.current.confirm_password_title,
                          hint: S.current.confirm_password,
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
                      // Just UI → no logic
                      UserCubit.instance.changePassword(
                        currentPassword: _passwordController.text.trim(),
                        newPassword: _newPasswordController.text.trim(),
                        context: context,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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
      },
    );
  }
}
