import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel {
  const MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);

  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return MessageModel(
      id: doc.id,
      senderId: data['senderId'] as String,
      content: data['content'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] as bool? ?? false,
      imageUrl: data['imageUrl'] as String?,
    );
  }
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;

  // write get method for isMe current user id == senderId

  bool get isMe => senderId == FirebaseAuth.instance.currentUser?.uid;

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  Map<String, dynamic> toFirestore() => {
        'senderId': senderId,
        'content': content,
        'timestamp': Timestamp.fromDate(timestamp),
        'isRead': isRead,
        'imageUrl': imageUrl,
      };

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? content,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
