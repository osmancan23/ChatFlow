// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      platform: json['platform'] as String,
      isOnline: json['isOnline'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      fcmToken: json['fcmToken'] as String?,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      lastSeen: json['lastSeen'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'profilePhoto': instance.profilePhoto,
      'platform': instance.platform,
      'isOnline': instance.isOnline,
      'fcmToken': instance.fcmToken,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'notificationsEnabled': instance.notificationsEnabled,
      'lastSeen': instance.lastSeen,
    };
