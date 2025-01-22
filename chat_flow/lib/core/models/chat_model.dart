import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  const ChatModel({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    this.typing = const {},
    this.lastSeen = const {},
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

  factory ChatModel.fromFirestore(
    DocumentSnapshot doc, {
    required List<UserModel> participants,
    MessageModel? lastMessage,
  }) {
    final data = doc.data()! as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      participants: participants,
      lastMessage: lastMessage,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      typing: Map<String, bool>.from(data['typing'] as Map? ?? {}),
      lastSeen: (data['lastSeen'] as Map?)?.map(
            (key, value) => MapEntry(
              key as String,
              (value as Timestamp).toDate(),
            ),
          ) ??
          {},
    );
  }
  final String id;
  final List<UserModel> participants;
  final MessageModel? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, bool> typing;
  final Map<String, DateTime> lastSeen;
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  Map<String, dynamic> toFirestore() => {
        'participantIds': participants.map((p) => p.id).toList(),
        'lastMessageId': lastMessage?.id,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
        'typing': typing,
        'lastSeen': lastSeen.map(
          (key, value) => MapEntry(key, Timestamp.fromDate(value)),
        ),
      };

  ChatModel copyWith({
    String? id,
    List<UserModel>? participants,
    MessageModel? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, bool>? typing,
    Map<String, DateTime>? lastSeen,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      typing: typing ?? this.typing,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  bool get isGroup => participants.length > 2;

  String getOtherParticipantId(String currentUserId) {
    return participants.firstWhere((p) => p.id != currentUserId).id;
  }

  bool isTyping(String userId) => typing[userId] ?? false;

  DateTime? getLastSeen(String userId) => lastSeen[userId];

  bool hasUnreadMessages(String userId) {
    if (lastMessage == null || lastSeen[userId] == null) return false;
    return lastMessage!.timestamp.isAfter(lastSeen[userId]!);
  }
}
