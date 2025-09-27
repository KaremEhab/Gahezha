import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/cubits/user/user_cubit.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/public_widgets/cached_images.dart';
import 'package:gahezha/screens/layout/layout.dart';
import 'package:iconly/iconly.dart';

class HomeProfilePopup extends StatelessWidget {
  const HomeProfilePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileToggleCubit, HomeToggleState>(
      builder: (context, state) {
        if (showProfileDetails) {
          return InkWell(
            onTap: () => ProfileToggleCubit.instance.homeProfileButtonToggle(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: kToolbarHeight + 10,
              ),
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.5),
              child: Column(
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 400),
                    child: InkWell(
                      onTap: () {},
                      child: Material(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        elevation: 6,
                        shadowColor: Colors.black26,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Close button (top-right)
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  onPressed: () => ProfileToggleCubit.instance
                                      .homeProfileButtonToggle(),
                                ),
                              ),

                              // Profile picture
                              CircleAvatar(
                                radius: 38,
                                backgroundColor: Colors.grey.shade300,
                                child: CircleAvatar(
                                  radius: 36,
                                  child: CustomCachedImage(
                                    imageUrl: currentUserModel == null
                                        ? currentShopModel!.shopLogo
                                        : currentUserModel!.profileUrl,
                                    height: double.infinity,
                                    borderRadius: BorderRadius.circular(200),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Name
                              Text(
                                currentUserModel == null
                                    ? currentShopModel!.shopName
                                    : currentUserType == UserType.guest
                                    ? S.current.guest_account
                                    : currentUserModel!.fullName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              if (currentUserType != UserType.guest &&
                                  currentUserType != UserType.admin) ...[
                                const SizedBox(height: 6),

                                // Email
                                Text(
                                  currentUserModel == null
                                      ? currentShopModel!.shopEmail
                                      : currentUserModel!.email,
                                  style: TextStyle(fontSize: 14),
                                ),

                                const SizedBox(height: 24),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //     horizontal: 20,
                                //   ),
                                //   child: Divider(
                                //     height: 1,
                                //     color: Colors.grey.withOpacity(0.3),
                                //   ),
                                // ),

                                // const SizedBox(height: 16),
                                //
                                // // Stats
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: [
                                //     FadeInLeft(
                                //       child: _buildProfileStat(
                                //         S.current.orders,
                                //         "120",
                                //       ),
                                //     ),
                                //     FadeInRight(
                                //       child: _buildProfileStat(
                                //         S.current.cart,
                                //         "3",
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],

                              const SizedBox(height: 30),

                              // Action buttons
                              FadeInDown(
                                duration: const Duration(milliseconds: 400),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if (currentUserType != UserType.guest) ...[
                                      _buildActionButton(
                                        context,
                                        Icons.edit,
                                        S.current.edit_profile,
                                        () {
                                          ProfileToggleCubit.instance
                                              .homeProfileButtonToggle(); // close popup
                                          Future.delayed(
                                            const Duration(milliseconds: 200),
                                            () {
                                              context
                                                  .findAncestorStateOfType<
                                                    LayoutState
                                                  >()
                                                  ?.openEditProfile(context);
                                            },
                                          );
                                        },
                                      ),
                                      _buildActionButton(
                                        context,
                                        Icons.logout,
                                        S.current.logout,
                                        () {
                                          Navigator.pop(context);
                                          UserCubit.instance.logout(context);
                                        },
                                      ),
                                    ] else
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            UserCubit.instance.logout(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                            backgroundColor: Colors.red,
                                          ),
                                          child: Text(S.current.logout),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

Widget _buildProfileStat(String label, String value) {
  return Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
    ],
  );
}

Widget _buildActionButton(
  BuildContext context,
  IconData icon,
  String label,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: label == S.current.logout
              ? Colors.red.withOpacity(0.1)
              : Colors.blue.withOpacity(0.1),
          child: Icon(
            icon,
            color: label == S.current.logout ? Colors.red : Colors.blue,
            size: 20,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    ),
  );
}
