import 'dart:developer';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IUserService {
  Future<UserModel?> getCurrentUserProfile();

  Future<void> updateUserProfile(UserModel user);

  Future<UserModel?> getChatUserProfile(String chatId);

  
}

class UserService extends IUserService {
  UserService({required FirebaseFirestore firestore}) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Future<UserModel?> getCurrentUserProfile() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final docSnapshot = await _firestore.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      } else {
        log('Kullanıcı bulunamadı.');
        return null;
      }
    } catch (e) {
      log('Hata oluştu: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> getChatUserProfile(String userId) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(userId).get();

      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      } else {
        log('Kullanıcı bulunamadı.');
        return null;
      }
    } catch (e) {
      log('Hata oluştu: $e');
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      log('Kullanıcı güncellendi.');
    } catch (e) {
      log('Hata oluştu: $e');
    }
  }
}
