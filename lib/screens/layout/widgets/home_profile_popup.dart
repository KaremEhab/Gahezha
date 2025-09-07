import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_cubit.dart';
import 'package:gahezha/cubits/profile_toggle/profile_toggle_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/public_widgets/cached_images.dart';

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
                                radius: 36,
                                child: CustomCachedImage(
                                  imageUrl: "https://i.pravatar.cc/300",
                                  height: double.infinity,
                                  borderRadius: BorderRadius.circular(200),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Name
                              const Text(
                                "John Doe",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Email
                              const Text(
                                "johndoe@email.com",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),

                              const SizedBox(height: 16),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Divider(
                                  height: 1,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Stats
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  FadeInLeft(
                                    child: _buildProfileStat(
                                      S.current.orders,
                                      "120",
                                    ),
                                  ),
                                  FadeInRight(
                                    child: _buildProfileStat(
                                      S.current.cart,
                                      "3",
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Action buttons
                              FadeInDown(
                                duration: const Duration(milliseconds: 400),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildActionButton(
                                      context,
                                      Icons.settings,
                                      S.current.settings,
                                      () {},
                                    ),
                                    _buildActionButton(
                                      context,
                                      Icons.edit,
                                      S.current.edit,
                                      () {},
                                    ),
                                    _buildActionButton(
                                      context,
                                      Icons.logout,
                                      S.current.logout,
                                      () {},
                                    ),
                                  ],
                                ),
                              ),
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
