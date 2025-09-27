import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/locale/locale_cubit.dart';
import 'package:gahezha/cubits/shop/shop_cubit.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/profile/customer/pages/change_email.dart';
import 'package:gahezha/screens/profile/customer/pages/change_password.dart';
import 'package:gahezha/screens/profile/customer/pages/edit_profile.dart';
import 'package:gahezha/screens/profile/customer/pages/privacy_security.dart';
import 'package:gahezha/screens/reports/reports_list.dart';
import 'package:iconly/iconly.dart';

class ShopProfilePage extends StatefulWidget {
  const ShopProfilePage({super.key});

  @override
  State<ShopProfilePage> createState() => _ShopProfilePageState();
}

class _ShopProfilePageState extends State<ShopProfilePage> {
  bool notifications = currentShopModel!.notificationsEnabled;
  bool shopStatus = currentShopModel!.shopStatus;

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
          /// Profile Header
          Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                CustomCachedImage(
                  imageUrl: currentShopModel!.shopBanner,
                  height: double.infinity,
                ),
                Container(color: Colors.black.withOpacity(0.5)),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          currentShopModel!.shopLogo,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        currentShopModel!.shopName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentShopModel!.shopEmail,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
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
                        icon: const Icon(
                          IconlyLight.edit,
                          color: primaryBlue,
                          size: 20,
                        ),
                        label: Text(
                          S.current.edit_shop,
                          style: TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // ✅ rounded corners
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          elevation: 2, // small shadow to lift it
                        ),
                      ),
                    ],
                  ),
                ),
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
            onChanged: (val) async {
              setState(() => notifications = val);

              // ✅ استدعاء التحديث
              await ShopCubit.instance.editShopData(notificationsEnabled: val);
            },
          ),
          SwitchListTile(
            value: shopStatus,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text(
              shopStatus ? "Shop Status: Open" : "Shop Status: Closed",
            ),
            secondary: Padding(
              padding: EdgeInsetsGeometry.directional(start: 2),
              child: CircleAvatar(
                radius: 11,
                backgroundColor: shopStatus ? Colors.green : Colors.red,
                child: CircleAvatar(
                  radius: 9,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: shopStatus ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ),
            onChanged: (val) async {
              setState(() => shopStatus = val);

              // ✅ استدعاء التحديث
              await ShopCubit.instance.editShopData(shopStatus: val);
            },
          ),
          _buildListTile(
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
              label: Text(S.current.delete_shop),
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
      padding: EdgeInsetsGeometry.directional(start: 10, bottom: 8),
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
