import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/locale/locale_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/screens/profile/customer/pages/change_email.dart';
import 'package:gahezha/screens/profile/customer/pages/change_password.dart';
import 'package:gahezha/screens/profile/customer/pages/edit_profile.dart';
import 'package:gahezha/screens/profile/customer/pages/privacy_security.dart';
import 'package:iconly/iconly.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  bool notifications = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: Text(S.current.profile),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: lang == 'en' ? 7 : 0,
              left: lang == 'ar' ? 7 : 0,
            ),
            child: Material(
              color: Colors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(radius),
              child: InkWell(
                borderRadius: BorderRadius.circular(radius),
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(13),
                  child: Icon(IconlyBold.logout, size: 18, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // Profile Header
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withOpacity(0.05),
                  Colors.blue.withOpacity(0.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    "https://picsum.photos/200/200?random=12",
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "John Doe",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "johndoe@gmail.com",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                GradientBorderButton(),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Account Section
          // _buildSectionTitle("Account Settings", context),
          // _buildListTile(
          //   icon: IconlyLight.bag,
          //   title: "My Orders",
          //   onTap: () {},
          // ),
          // _buildListTile(
          //   icon: IconlyLight.location,
          //   title: "Addresses",
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const AddressesPage()),
          //     );
          //   },
          // ),

          // const SizedBox(height: 10),

          // Settings Section
          _buildSectionTitle(S.current.app_settings, context),
          SwitchListTile(
            value: notifications,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text(S.current.notifications),
            secondary: Icon(
              notifications
                  ? IconlyBold.notification
                  : IconlyLight.notification,
              color: primaryBlue,
            ),
            onChanged: (val) => setState(() => notifications = val),
          ),
          _buildListTile(
            icon: IconlyLight.message,
            title: S.current.change_email,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangeEmailPage(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: IconlyLight.lock,
            title: S.current.change_password,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePasswordPage(),
                ),
              );
            },
          ),
          _buildListTile(
            icon: IconlyLight.shield_done,
            title: S.current.privacy_policy,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyAndPolicyPage(),
                ),
              );
            },
          ),

          // 🔥 NEW Language Switch Tile
          _buildListTile(
            leadingIcon: lang == 'en' ? " 🇺🇸" : " 🇸🇦",
            title: lang == 'en' ? "English" : "العربية",
            onTap: () {
              if (lang == 'en') {
                setState(() => lang = 'ar');
                context.read<LocaleCubit>().changeLocale(lang);
              } else {
                setState(() => lang = 'en');
                context.read<LocaleCubit>().changeLocale(lang);
              }

              // (context as Element).markNeedsBuild();
            },
          ),

          const SizedBox(height: 20),

          // Delete Account Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(IconlyBold.delete),
              label: Text(S.current.delete_account),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontWeight: FontWeight.w900),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildListTile({
    IconData? icon,
    String? leadingIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: leadingIcon != null
          ? Text(leadingIcon, style: const TextStyle(fontSize: 15))
          : Icon(icon, color: primaryBlue),
      title: Text(title),
      trailing: Icon(
        leadingIcon != null
            ? Icons.swap_horizontal_circle
            : Icons.arrow_forward_ios,
        size: leadingIcon != null ? 22 : 16,
        color: leadingIcon != null ? primaryBlue : Colors.grey,
      ),
      onTap: onTap,
    );
  }
}

class GradientBorderButton extends StatelessWidget {
  const GradientBorderButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.withOpacity(0.4), Colors.blue.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(1.5), // thickness of gradient border
      child: OutlinedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(sheetRadius),
              ),
            ),
            builder: (context) => const EditProfileSheet(),
          );
        },
        icon: const Icon(Icons.edit, size: 18),
        label: Text(S.current.edit_profile),
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          backgroundColor: Colors.white.withOpacity(0.4), // button fill
          side: const BorderSide(
            color: Colors.transparent,
          ), // hide default border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
