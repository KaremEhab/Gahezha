import 'package:flutter/material.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        "title": "${S.current.order_ready} 🎉",
        "message": "Your flower bouquet is ready for pickup.",
        "time": DateTime.now().subtract(const Duration(minutes: 10)),
        "isRead": false,
      },
      {
        "title": "${S.current.order_accepted} ✅",
        "message": S.current.order_accepted,
        "time": DateTime.now().subtract(const Duration(hours: 1)),
        "isRead": true,
      },
      {
        "title": "${S.current.welcome} 👋",
        "message": S.current.thanks_for_joining,
        "time": DateTime.now().subtract(const Duration(days: 1)),
        "isRead": true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.notifications),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          final formattedTime = DateFormat(
            "hh:mm a",
          ).format(item["time"] as DateTime);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              gradient: item["isRead"] == false
                  ? LinearGradient(
                      colors: [
                        Colors.blue.withOpacity(0.4),
                        Colors.blue.withOpacity(0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: item["isRead"] != null ? Colors.grey.shade100 : null,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: item["isRead"] != null
                            ? Colors.blue.shade50
                            : Colors.blue.shade300,
                        child: Icon(
                          item["isRead"] != null
                              ? IconlyLight.notification
                              : IconlyBold.notification,
                          color: item["isRead"] != null
                              ? Colors.blueGrey
                              : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["title"] as String,
                              style: TextStyle(
                                fontWeight: item["isRead"] != null
                                    ? FontWeight.w500
                                    : FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["message"] as String,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
