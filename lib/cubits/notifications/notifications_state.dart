import 'package:gahezha/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}

class GetNotificationsLoadingState extends NotificationState {}

class GetNotificationsSuccessState extends NotificationState {}

class GetNotificationsErrorState extends NotificationState {
  final String message;
  GetNotificationsErrorState(this.message);
}

class SendNotificationLoadingState extends NotificationState {}

class SendNotificationSuccessState extends NotificationState {}

class SendNotificationErrorState extends NotificationState {
  final String message;
  SendNotificationErrorState(this.message);
}
