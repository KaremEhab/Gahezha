import 'package:flutter/material.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/models/user_model.dart';
import 'package:gahezha/screens/blocked_and_reported/widgets/account_settings_sheet.dart';
import 'package:iconly/iconly.dart';

class AccountSettingsCard extends StatelessWidget {
  const AccountSettingsCard({
    super.key,
    required this.userType,
    this.userName = "John Doe",
    this.userEmail = "john.doe@example.com",
    this.userPhone = "+20 111 222 3333",
    this.avatarUrl = "https://picsum.photos/200/200?random=1",
    this.bannerUrl = "https://picsum.photos/200/200?random=1",
    this.isBlocked = false,
    this.isReported = false,
    this.isDisabled = false, // NEW
    this.reportedCount = 0,
  });

  final UserType userType;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String avatarUrl;
  final String bannerUrl;
  final bool isBlocked;
  final bool isReported;
  final bool isDisabled; // NEW
  final int reportedCount;

  @override
  Widget build(BuildContext context) {
    // Determine card background color
    final Color bgColor = isBlocked
        ? Colors.red.withOpacity(0.05)
        : isReported
        ? Colors.orange.withOpacity(0.05)
        : isDisabled
        ? Colors.grey.shade200
        : Colors.white;

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        splashColor: isBlocked
            ? Colors.red.withOpacity(0.2)
            : isReported
            ? Colors.orange.withOpacity(0.2)
            : isDisabled
            ? Colors.grey.withOpacity(0.2)
            : primaryBlue.withOpacity(0.1),
        highlightColor: isBlocked
            ? Colors.red.withOpacity(0.2)
            : isReported
            ? Colors.orange.withOpacity(0.2)
            : isDisabled
            ? Colors.grey.withOpacity(0.2)
            : primaryBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius),
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(sheetRadius),
                topRight: Radius.circular(sheetRadius),
              ),
            ),
            builder: (_) => AccountDetailsSheet(
              userType: userType,
              name: userName,
              email: userEmail,
              phone: userPhone,
              avatarUrl: avatarUrl,
              bannerUrl: bannerUrl,
              isBlocked: isBlocked,
              isReported: isReported,
              reportedCount: reportedCount,
              isDisabled: isDisabled, // Pass the new state
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Row(
            children: [
              /// Avatar
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(avatarUrl),
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(width: 12),

              /// User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      userPhone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              // Status Icons
              Row(
                children: [
                  if (isBlocked) const Icon(Icons.block, color: Colors.red),
                  if (isDisabled)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(IconlyBold.lock, color: Colors.grey),
                    ),
                  if (isReported)
                    Row(
                      children: [
                        const SizedBox(width: 4),
                        const Icon(IconlyBold.danger, color: Colors.orange),
                        if (reportedCount > 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              reportedCount.toString(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                      ],
                    ),
                  if (!isBlocked && !isReported && !isDisabled)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Colors.black38,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
