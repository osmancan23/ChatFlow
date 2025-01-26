import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.platform,
    required this.isOnline,
    required this.createdAt,
    required this.updatedAt,
    this.profilePhoto,
    this.fcmToken,
    this.notificationsEnabled = true,
    this.lastSeen,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      profilePhoto: map['profilePhoto'] as String?,
      platform: map['platform'] as String? ?? 'unknown',
      isOnline: map['isOnline'] as bool? ?? false,
      fcmToken: map['fcmToken'] as String?,
      createdAt: map['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      updatedAt: map['updatedAt'] as String? ?? DateTime.now().toIso8601String(),
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      lastSeen: map['lastSeen'] as String?,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return UserModel.fromMap({
      'id': doc.id,
      ...data,
    });
  }
  final String id;
  final String email;
  final String fullName;
  String? profilePhoto;
  final String platform;
  final bool isOnline;
  final String? fcmToken;
  final String createdAt;
  final String updatedAt;
  final bool notificationsEnabled;
  String? lastSeen;
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profilePhoto': profilePhoto,
      'platform': platform,
      'isOnline': isOnline,
      'fcmToken': fcmToken,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'notificationsEnabled': notificationsEnabled,
      'lastSeen': lastSeen,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profilePhoto,
    String? platform,
    bool? isOnline,
    String? fcmToken,
    String? createdAt,
    String? updatedAt,
    bool? notificationsEnabled,
    String? lastSeen,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      platform: platform ?? this.platform,
      isOnline: isOnline ?? this.isOnline,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
