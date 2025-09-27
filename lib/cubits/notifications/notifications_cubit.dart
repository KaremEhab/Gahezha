import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:gahezha/constants/vars.dart';
import 'package:gahezha/cubits/notifications/notifications_state.dart';
import 'package:gahezha/models/notification_model.dart';
import 'package:gahezha/models/user_model.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit._privateConstructor() : super(NotificationInitial());

  static final NotificationCubit _instance =
      NotificationCubit._privateConstructor();

  factory NotificationCubit() => _instance;

  static NotificationCubit get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Dio _dio = Dio();

  static const _fcmEndpoint =
      'https://fcm.googleapis.com/v1/projects/gahezha/messages:send';

  /// Send single notification to single or multiple users
  Future<void> sendNotification({
    required List<SenderReceiver> receivers, // userIds or shopIds
    required bool isShop,
    required SenderReceiver sender, // who's sending the notification
    required String label, // notification label/title
    required String content, // notification body/content
    required NotificationType notificationType,
    Map<String, dynamic>? payload,
  }) async {
    emit(NotificationLoading());

    try {
      final batch = _firestore.batch();
      NotificationModel? notification;

      for (var receiver in receivers) {
        final docRef = _firestore
            .collection(isShop ? 'shops' : 'users')
            .doc(receiver.id)
            .collection('notifications')
            .doc(); // Firestore generates unique id

        // حفظ الإشعار في Firestore
        notification = NotificationModel(
          id: docRef.id,
          label: label,
          content: content,
          createdAt: DateTime.now(),
          sender: sender,
          receiver: receiver,
          isRead: false,
          notificationType: notificationType,
          payload: payload ?? {},
        );
        batch.set(docRef, notification.toMap());

        // 🔔 إرسال الإشعار عبر FCM
        DocumentSnapshot<Map<String, dynamic>> snapshot = await _firestore
            .collection(isShop ? 'shops' : 'users')
            .doc(receiver.id)
            .get();
        Map<String, dynamic>? data = snapshot.data();

        // إذا المستخدم أو المتجر عنده tokens
        if (data != null && data['fcmTokens'] != null) {
          // تحقق من إعدادات الإشعارات
          bool canSend = false;
          switch (notificationType) {
            case NotificationType.orderStatus:
              canSend = data['orderStatus'] ?? true;
              break;
            case NotificationType.newOrder:
              canSend = data['newOrder'] ?? true;
              break;
            case NotificationType.newProduct:
              canSend = data['newProduct'] ?? true;
              break;
          }

          if (!canSend) {
            log(
              '🔕 Skipping FCM notification to ${receiver.id}: setting disabled',
            );
            continue;
          }

          final List<String> fcmTokens = List<String>.from(
            data['fcmTokens'],
          ).toSet().toList();

          for (final token in fcmTokens) {
            try {
              await _dio.post(
                _fcmEndpoint,
                options: Options(
                  headers: {
                    'Authorization': 'Bearer $accessToken',
                    'Content-Type': 'application/json',
                  },
                ),
                data: {
                  "message": {
                    "token": token,
                    "notification": {"title": label, "body": content},
                    if (payload != null)
                      "data": {"payload": jsonEncode(payload)},
                  },
                },
              );
              log("✅ FCM Notification sent to $token");
            } catch (e) {
              log("⚠️ Error sending FCM to $token: $e");
            }
          }
        }
      }

      await batch.commit();
      log(
        "✅ Notification stored and sent to ${receivers.length} ${isShop ? 'shops' : 'users'}",
      );
      emit(NotificationLoaded([notification!]));
    } catch (e, stack) {
      log('❌ sendNotification Error: $e\n$stack');
      emit(NotificationError(e.toString()));
    }
  }

  /// Get notification by id
  Future<NotificationModel?> getNotificationById({
    required String docId,
    required String notificationId,
  }) async {
    final doc = await _firestore
        .collection(
          currentUserType == UserType.shop
              ? 'shops'
              : currentUserType == UserType.admin
              ? 'admins'
              : 'users',
        )
        .doc(docId)
        .collection('notifications')
        .doc(notificationId)
        .get();

    if (!doc.exists) return null;
    return NotificationModel.fromMap(doc.data()!);
  }

  /// Get all notifications for a user/shop
  Future<void> getNotificationsByUserId({required String docId}) async {
    emit(NotificationLoading());
    try {
      final snapshot = await _firestore
          .collection(
            currentUserType == UserType.shop
                ? 'shops'
                : currentUserType == UserType.admin
                ? 'admins'
                : 'users',
          )
          .doc(docId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .get();

      final notifications = snapshot.docs
          .map((doc) => NotificationModel.fromMap(doc.data()))
          .toList();

      emit(NotificationLoaded(notifications));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Delete single or multiple notifications
  Future<void> deleteNotification({
    required String docId,
    required bool isShop,
    required List<String> notificationIds,
  }) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection(
          currentUserType == UserType.shop
              ? 'shops'
              : currentUserType == UserType.admin
              ? 'admins'
              : 'users',
        )
        .doc(docId)
        .collection('notifications');

    for (var id in notificationIds) {
      batch.delete(collectionRef.doc(id));
    }
    await batch.commit();
  }

  /// Mark single notification as read
  Future<void> markRead({
    required String docId,
    required String notificationId,
  }) async {
    // ✅ 1. عدّل الـ state المحلي
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final updatedList = currentState.notifications.map((n) {
        if (n.id == notificationId) {
          return n.copyWith(isRead: true); // copyWith يخليها مقروءة
        }
        return n;
      }).toList();

      emit(NotificationLoaded(updatedList)); // ⬅️ حدّث UI فورًا
    }

    // ✅ 2. حدّث الـ Firebase
    final docRef = _firestore
        .collection(
          currentUserType == UserType.shop
              ? 'shops'
              : currentUserType == UserType.admin
              ? 'admins'
              : 'users',
        )
        .doc(docId)
        .collection('notifications')
        .doc(notificationId);

    await docRef.update({'isRead': true});
  }

  /// Mark multiple notifications as read
  Future<void> markReadMultiple({
    required String docId,
    required bool isShop,
    required List<String> notificationIds,
  }) async {
    final batch = _firestore.batch();
    final collectionRef = _firestore
        .collection(
          currentUserType == UserType.shop
              ? 'shops'
              : currentUserType == UserType.admin
              ? 'admins'
              : 'users',
        )
        .doc(docId)
        .collection('notifications');

    for (var id in notificationIds) {
      batch.update(collectionRef.doc(id), {'isRead': true});
    }
    await batch.commit();
  }
}
