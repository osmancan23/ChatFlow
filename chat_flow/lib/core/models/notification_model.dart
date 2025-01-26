import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String chatId;
  final DateTime timestamp;
  final bool isRead;
  final String userId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.chatId,
    required this.timestamp,
    required this.isRead,
    required this.userId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      title: data['title'] as String,
      body: data['body'] as String,
      chatId: data['chatId'] as String,
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.parse(data['timestamp'] as String),
      isRead: data['isRead'] as bool? ?? false,
      userId: data['userId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'chatId': chatId,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'userId': userId,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? chatId,
    DateTime? timestamp,
    bool? isRead,
    String? userId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      chatId: chatId ?? this.chatId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
    );
  }
} 