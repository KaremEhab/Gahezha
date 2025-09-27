import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gahezha/cubits/notifications/notifications_cubit.dart';
import 'package:gahezha/cubits/notifications/notifications_state.dart';
import 'package:gahezha/generated/l10n.dart';
import 'package:gahezha/main.dart';
import 'package:gahezha/models/notification_model.dart';
import 'package:gahezha/models/order_model.dart';
import 'package:gahezha/screens/cart/widgets/preparing_order_page.dart';
import 'package:intl/intl.dart';
import 'package:iconly/iconly.dart';
import 'package:gahezha/constants/vars.dart'; // علشان uId

class NotificationsPage extends StatefulWidget {
  final bool isShop;
  const NotificationsPage({super.key, this.isShop = false});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    NotificationCubit.instance.getNotificationsByUserId(docId: uId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.notifications),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationError) {
            return Center(child: Text("❌ ${state.message}"));
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(child: Text(S.current.no_notifications));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final item = notifications[index];
                final formattedTime = DateFormat(
                  "hh:mm a",
                ).format(item.createdAt);

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: item.isRead == false
                        ? LinearGradient(
                            colors: [
                              Colors.blue.withOpacity(0.4),
                              Colors.blue.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: item.isRead ? Colors.grey.shade100 : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        final payloadMap = item.payload;
                        if (payloadMap == null) return; // ✅ تأكد إنه مش null

                        try {
                          log("🔗 Notification tapped: $payloadMap");

                          final type =
                              payloadMap['type']; // خلاص مش هيعمل error
                          if (type == null) return;

                          switch (type) {
                            case 'newOrder' || 'orderStatus':
                              final order = OrderModel.fromMap(
                                payloadMap['order'] ?? {},
                              );
                              navigateTo(
                                context: context,
                                screen: OrderStatusPage(orderModel: order),
                              );
                              break;

                            default:
                              log("⚠️ Unknown notification type: $type");
                          }

                          // علّم الإشعار مقروء
                          NotificationCubit.instance.markRead(
                            docId: uId,
                            notificationId: item.id,
                          );
                        } catch (e, st) {
                          log("❌ Error parsing notification payload: $e");
                          log(st.toString());
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: item.isRead
                                  ? Colors.blue.shade50
                                  : Colors.blue.shade300,
                              child: Icon(
                                item.isRead
                                    ? IconlyLight.notification
                                    : IconlyBold.notification,
                                color: item.isRead
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
                                    item.label,
                                    style: TextStyle(
                                      fontWeight: item.isRead
                                          ? FontWeight.w500
                                          : FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.content,
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
            );
          }

          return const SizedBox.shrink(); // default لو مفيش حالة مناسبة
        },
      ),
    );
  }
}
