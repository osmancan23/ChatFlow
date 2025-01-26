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

  /// Çevrimiçi durumunu günceller
  Future<void> updateOnlineStatus({required bool isOnline});

  /// Son görülme zamanını günceller
  Future<void> updateLastSeen();
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
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;

      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists) return null;

      return UserModel.fromMap({
        'id': doc.id,
        ...doc.data()!,
      });
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
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'notificationsEnabled': isEnabled,
      });
      log('Bildirim tercihleri güncellendi');
    } catch (e) {
      log('Bildirim tercihleri güncellenirken hata: $e');
      throw Exception('Bildirim tercihleri güncellenemedi');
    }
  }

  /// Çevrimiçi durumunu günceller
  @override
  Future<void> updateOnlineStatus({required bool isOnline}) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'isOnline': isOnline,
        'lastSeen': isOnline ? null : FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Çevrimiçi durumu güncellenirken hata: $e');
      throw Exception('Çevrimiçi durumu güncellenemedi');
    }
  }

  /// Son görülme zamanını günceller
  @override
  Future<void> updateLastSeen() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Son görülme zamanı güncellenirken hata: $e');
      throw Exception('Son görülme zamanı güncellenemedi');
    }
  }
}
