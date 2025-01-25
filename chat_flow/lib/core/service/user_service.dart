import 'dart:developer';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IUserService {
  Future<UserModel?> getCurrentUserProfile();

  Future<void> updateUserProfile(UserModel user);


  Future<void> updateNotificationsEnabled({required bool isEnabled});
}

class UserService extends IUserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      log('Kullanıcı güncellendi.');
    } catch (e) {
      log('Hata oluştu: $e');
    }
  }

  @override
  Future<void> updateNotificationsEnabled({required bool isEnabled}) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;

      await _firestore.collection('users').doc(userId).update({
        'notificationsEnabled': isEnabled,
      });
    } catch (e) {
      print('Error updating notificationsEnabled: $e');
    }
  }
}
