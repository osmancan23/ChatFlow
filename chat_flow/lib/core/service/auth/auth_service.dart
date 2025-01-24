import 'package:chat_flow/core/init/locale_storage/locale_storage_manager.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class IAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> login({required String email, required String password});

  Future<User?> register({required String email, required String password, required String fullName});

  Future<void> logout();

  Future<void> updateToken(String? token);

  Future<void> updateTokenFromStorage();
}

class AuthService extends IAuthService {
  @override
  Future<User?> login({required String email, required String password}) async {
    final userCrendtial = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCrendtial.user;
  }

  @override
  Future<User?> register({required String email, required String password, required String fullName}) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Kullanıcı modelini oluştur
    final user = UserModel(
      id: userCredential.user!.uid,
      email: email,
      fullName: fullName,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _firebaseFirestore.collection('users').doc(user.id).set(user.toMap());

    return userCredential.user;
  }

  @override
  Future<void> updateToken(String? token) async {
    try {
      if (token != null) {
        await LocalStorageManager.setString(LocalStorage.token.key, token);
      } else {
        if (await LocalStorageManager.containsKey(LocalStorage.token.key)) {
          await LocalStorageManager.remove(LocalStorage.token.key);
        }
      }
    } catch (e) {
      print('HATA : $e');
    }
  }

  ///MARK: Update token from storage when app started
  @override
  Future<void> updateTokenFromStorage() async {
    if (await LocalStorageManager.containsKey(LocalStorage.token.key)) {
      final token = await LocalStorageManager.getString(LocalStorage.token.key);
      if (token != null) {}
    }
  }

  @override
  Future<void> logout() async {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId != null) {
      // Kullanıcı çıkış yaparken online durumunu güncelle
      await _firebaseFirestore.collection('users').doc(userId).update({
        'isOnline': false,
        'lastSeen': DateTime.now().toIso8601String(),
      });
    }
    await _firebaseAuth.signOut();
  }
}
