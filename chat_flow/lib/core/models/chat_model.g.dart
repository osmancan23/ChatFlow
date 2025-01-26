// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participants: (json['participants'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      typing: Map<String, bool>.from(json['typing'] as Map),
      lastSeen: Map<String, String>.from(json['lastSeen'] as Map),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'participantIds': instance.participantIds,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'typing': instance.typing,
      'lastSeen': instance.lastSeen,
    };
