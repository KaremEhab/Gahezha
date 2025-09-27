enum NotificationType { orderStatus, newProduct, newOrder }

class NotificationModel {
  final String id;
  final String label;
  final String content;
  final DateTime createdAt;
  final SenderReceiver sender;
  final SenderReceiver receiver;
  final bool isRead;
  final NotificationType notificationType;
  final Map<String, dynamic>? payload;

  NotificationModel({
    required this.id,
    required this.label,
    required this.content,
    required this.createdAt,
    required this.sender,
    required this.receiver,
    required this.isRead,
    required this.notificationType,
    this.payload,
  });

  NotificationModel copyWith({
    String? id,
    String? label,
    String? content,
    DateTime? createdAt,
    SenderReceiver? sender,
    SenderReceiver? receiver,
    bool? isRead,
    NotificationType? notificationType,
    Map<String, dynamic>? payload,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      label: label ?? this.label,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      isRead: isRead ?? this.isRead,
      notificationType: notificationType ?? this.notificationType,
      payload: payload ?? this.payload,
    );
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      sender: SenderReceiver.fromMap(map['sender'] ?? {}),
      receiver: SenderReceiver.fromMap(map['receiver'] ?? {}),
      isRead: map['isRead'] ?? false,
      notificationType: notificationTypeFromString(
        map['notificationType'] ?? '',
      ),
      payload: map['payload'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'sender': sender.toMap(),
      'receiver': receiver.toMap(),
      'isRead': isRead,
      'notificationType': notificationTypeToString(notificationType),
      'payload': payload,
    };
  }
}

class SenderReceiver {
  final String id;
  final String profile;
  final String name;

  SenderReceiver({required this.id, required this.profile, required this.name});

  factory SenderReceiver.fromMap(Map<String, dynamic> map) {
    return SenderReceiver(
      id: map['id'] ?? '',
      profile: map['profile'] ?? '',
      name: map['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'profile': profile, 'name': name};
  }
}

NotificationType notificationTypeFromString(String value) {
  switch (value) {
    case 'orderStatus':
      return NotificationType.orderStatus;
    case 'newProduct':
      return NotificationType.newProduct;
    case 'newOrder':
      return NotificationType.newOrder;
    default:
      return NotificationType.orderStatus;
  }
}

String notificationTypeToString(NotificationType type) {
  return type.toString().split('.').last;
}
