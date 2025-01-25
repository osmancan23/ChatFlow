import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.fullName,
     this.createdAt,
     this.updatedAt,
    this.profilePhoto,
    this.bio,
    this.isOnline = false,
    this.lastSeen,
    this.chatIds = const [],
    this.notificationsEnabled = true,
    this.platform,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      email: map['email'] as String,
      fullName: map['fullName'] as String,
      profilePhoto: map['profilePhoto'] as String?,
      bio: map['bio'] as String?,
      isOnline: map['isOnline'] as bool,
      lastSeen: map['lastSeen'] as String?,
      chatIds: (map['chatIds'] as List).map((e) => e as String).toList(),
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      platform: map['platform'] as String?,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data()! as Map<String, dynamic>);
  }
  final String id;
  final String email;
  final String fullName;
  String? profilePhoto;
  String? bio;
  bool isOnline;
  String? lastSeen;
  List<String> chatIds;
  final String? createdAt;
  String? updatedAt;
  bool notificationsEnabled;
  String? platform; // 'ios' veya 'android'

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profilePhoto': profilePhoto,
      'bio': bio,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'chatIds': chatIds,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'notificationsEnabled': notificationsEnabled,
      'platform': platform,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? profilePhoto,
    String? bio,
    bool? isOnline,
    String? lastSeen,
    List<String>? chatIds,
    String? createdAt,
    String? updatedAt,
    bool? notificationsEnabled,
    String? platform,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bio: bio ?? this.bio,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      chatIds: chatIds ?? this.chatIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      platform: platform ?? this.platform,
    );
  }
}
