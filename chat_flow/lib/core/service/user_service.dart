import 'dart:developer';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Kullanıcı servisi için abstract sınıf
/// Bu sınıf, kullanıcı işlemleri için gerekli olan metodları tanımlar
@immutable
abstract class IUserService {
  /// Mevcut kullanıcının profilini getirir
  Future<UserModel?> getCurrentUserProfile();

  /// Kullanıcı profilini günceller
  Future<void> updateUserProfile(UserModel user);

  /// Bildirim tercihlerini günceller
  Future<void> updateNotificationsEnabled({required bool isEnabled});
}

/// Kullanıcı servisi implementasyonu
/// Firebase Firestore kullanarak kullanıcı işlemlerini gerçekleştirir
class UserService extends IUserService {
  UserService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Mevcut kullanıcının profilini Firestore'dan getirir
  @override
  Future<UserModel?> getCurrentUserProfile() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final docSnapshot = await _firestore.collection('users').doc(userId).get();

      if (!docSnapshot.exists) {
        log('Kullanıcı bulunamadı');
        return null;
      }

      return UserModel.fromFirestore(docSnapshot);
    } catch (e) {
      log('Kullanıcı profili getirilirken hata: $e');
      return null;
    }
  }

  /// Kullanıcı profilini Firestore'da günceller
  @override
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      log('Kullanıcı profili güncellendi');
    } catch (e) {
      log('Kullanıcı profili güncellenirken hata: $e');
      throw Exception('Kullanıcı profili güncellenemedi');
    }
  }

  /// Kullanıcının bildirim tercihlerini günceller
  @override
  Future<void> updateNotificationsEnabled({required bool isEnabled}) async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      await _firestore.collection('users').doc(userId).update({
        'notificationsEnabled': isEnabled,
      });
      log('Bildirim tercihleri güncellendi');
    } catch (e) {
      log('Bildirim tercihleri güncellenirken hata: $e');
      throw Exception('Bildirim tercihleri güncellenemedi');
    }
  }
}
