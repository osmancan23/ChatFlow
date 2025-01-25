import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.chatId,
    required this.senderId,
    required this.timestamp,
    required this.isRead,
    required this.platform,
  });

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return NotificationModel(
      id: doc.id,
      userId: data['userId'] as String,
      title: data['title'] as String,
      body: data['body'] as String,
      type: data['type'] as String,
      chatId: data['chatId'] as String,
      senderId: data['senderId'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool? ?? false,
      platform: data['platform'] as String,
    );
  }

  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final String chatId;
  final String senderId;
  final DateTime timestamp;
  final bool isRead;
  final String platform;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'type': type,
      'chatId': chatId,
      'senderId': senderId,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'platform': platform,
    };
  }
} 