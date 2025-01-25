import 'dart:developer';

import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:chat_flow/utils/tools/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authService) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }
  final IAuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authService.login(email: event.email, password: event.password);

      if (user != null) {
        await _saveToken(user);

        emit(const AuthSuccess());
        await _updateFcmToken(user.uid);
      } else {
        emit(const AuthFailure('Kullanıcı bilgileri hatalı'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthExceptionHandler.findExceptionType(e)));
    }
  }

  Future<void> _onAuthRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = await _authService.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );

      if (user != null) {
        await _saveToken(user);
        emit(const AuthSuccess());
        await _updateFcmToken(user.uid);
      } else {
        emit(const AuthFailure('Kullanıcı kaydı sırasında bir hata oluştu'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Bir hata oluştu'));
    } catch (e) {
      emit(const AuthFailure('Kullanıcı kaydı sırasında bir hata oluştu'));
    }
  }

  Future<void> _onAuthLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _authService.logout();
      await _clearToken();
      emit(const AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        // Kullanıcı giriş yaptığında online durumunu güncelle
        await _firestore.collection('users').doc(user.uid).update({
          'isOnline': true,
          'lastSeen': DateTime.now().toIso8601String(),
        });
        await _saveToken(user);

        emit(const AuthSuccess());
        await _updateFcmToken(user.uid);
      } catch (e) {
        emit(const AuthSuccess());
      }
    } else {
      emit(const AuthInitial());
    }
  }

  Future<void> _saveToken(User? user) async {
    final token = await user?.getIdToken();
    await _authService.updateToken(token);
  }

  Future<void> _clearToken() async {
    await _authService.updateToken(null);
  }

  Future<void> _updateFcmToken(String userId) async {
    await FirebaseMessaging.instance.getToken().then((value) async {
      log('FCM Token: $value');
      await _authService.saveFcmToken(userId, value);
    });
  }
}
