import 'package:chat_flow/utils/extension/iterable_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';

part 'chat_model.g.dart';

@JsonSerializable()
class ChatModel {
  final String id;
  final List<String> participantIds;
  final List<UserModel> participants;
  final MessageModel? lastMessage;
  final String createdAt;
  final String updatedAt;
  final Map<String, bool> typing;
  final Map<String, String> lastSeen;

  ChatModel({
    required this.id,
    required this.participantIds,
    required this.participants,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.typing,
    required this.lastSeen,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  factory ChatModel.fromFirestore(
    DocumentSnapshot doc, {
    List<UserModel> participants = const [],
    MessageModel? lastMessage,
  }) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      id: doc.id,
      participantIds: List<String>.from(data['participantIds'] as List),
      participants: participants,
      lastMessage: lastMessage,
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate().toIso8601String()
          : data['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
          : data['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      typing: Map<String, bool>.from(data['typing'] as Map? ?? {}),
      lastSeen: Map<String, String>.from(data['lastSeen'] as Map? ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'typing': typing,
      'lastSeen': lastSeen,
    };
  }

  ChatModel copyWith({
    String? id,
    List<String>? participantIds,
    List<UserModel>? participants,
    MessageModel? lastMessage,
    String? createdAt,
    String? updatedAt,
    Map<String, bool>? typing,
    Map<String, String>? lastSeen,
  }) {
    return ChatModel(
      id: id ?? this.id,
      participantIds: participantIds ?? this.participantIds,
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

  UserModel? getOtherUser() {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return participants.where((p) => p.id != currentUserId).getIterableItem(0);
  }

  bool isTyping(String userId) => typing[userId] ?? false;

  DateTime? getLastSeen(String userId) => lastSeen[userId] != null ? DateTime.parse(lastSeen[userId]!) : null;

  bool hasUnreadMessages(String userId) {
    if (lastMessage == null || lastSeen[userId] == null) return false;
    return DateTime.parse(lastMessage!.timestamp).isAfter(DateTime.parse(lastSeen[userId]!));
  }
}
