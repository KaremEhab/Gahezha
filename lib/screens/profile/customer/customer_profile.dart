import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/locale/locale_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/profile/customer/pages/change_email.dart';
import 'package:gahezha/screens/profile/customer/pages/change_password.dart';
import 'package:gahezha/screens/profile/customer/pages/edit_profile.dart';
import 'package:gahezha/screens/profile/customer/pages/privacy_security.dart';
import 'package:gahezha/screens/reports/reports_list.dart';
import 'package:iconly/iconly.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({super.key});

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  bool notifications = true;
  // bool notifications = currentUserModel!.notificationsEnabled ?? true;

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
                onTap: () {
                  UserCubit.instance.logout(context);
                },
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
            height: currentUserType != UserType.guest ? null : 270,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black45,
                  child: CircleAvatar(
                    radius: 48,
                    child: currentUserModel == null
                        ? Icon(IconlyBold.profile, size: 40)
                        : CustomCachedImage(
                            imageUrl: currentUserModel!.profileUrl ?? '',
                            height: double.infinity,
                            borderRadius: BorderRadius.circular(200),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  currentUserModel == null
                      ? "Undefined name"
                      : currentUserModel!.fullName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900],
                  ),
                ),
                if (currentUserType != UserType.guest) ...[
                  const SizedBox(height: 4),
                  Text(
                    currentUserModel == null
                        ? "Undefined email"
                        : currentUserModel!.email,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (currentUserModel != null) const SizedBox(height: 16),
                  if (currentUserModel != null) GradientBorderButton(),
                ],
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

          // Account Section
          if (currentUserType != UserType.guest) ...[
            _buildSectionTitle(S.current.account_settings, context),
            if (currentUserType == UserType.customer)
              buildListTile(
                icon: Icons.monetization_on_outlined,
                title: S.current.commission,
                trailingIcon: currentUserModel!.commissionBalance > 0
                    ? Row(
                        spacing: 5,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                            color: primaryBlue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(radius),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 13,
                              ),
                              child: Text(
                                "${currentUserModel!.referredShopIds.length} ${currentUserModel!.referredShopIds.length > 1 ? S.current.shops : S.current.shop}",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: primaryBlue,
                            borderRadius: BorderRadius.circular(radius),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 13,
                              ),
                              child: Text(
                                "${S.current.sar} ${currentUserModel!.commissionBalance}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
                onTap: () {
                  UserCubit.instance.shareReferral(uId);
                },
              ),
            buildListTile(
              icon: IconlyLight.info_circle,
              title: S.current.reports,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReportsListPage(userType: currentUserType),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),
          ],

          // Settings Section
          _buildSectionTitle(S.current.app_settings, context),
          SwitchListTile(
            value: notifications,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            title: Text(S.current.notifications),
            secondary: Icon(
              notifications
                  ? IconlyBold.notification
                  : IconlyLight.notification,
              color: primaryBlue,
            ),
            onChanged: (val) async {
              setState(() => notifications = val);

              // ✅ استدعاء التحديث
              await UserCubit.instance.editUserData(notificationsEnabled: val);
            },
          ),
          if (currentUserType != UserType.guest) ...[
            // _buildListTile(
            //   icon: IconlyLight.message,
            //   title: S.current.change_email,
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const ChangeEmailPage(),
            //       ),
            //     );
            //   },
            // ),
            buildListTile(
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
          ],
          buildListTile(
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
          buildListTile(
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
          if (currentUserType != UserType.guest)
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
            showDragHandle: true,
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
