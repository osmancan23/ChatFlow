import 'dart:async';
import 'dart:developer';

import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:chat_flow/core/service/user/user_service.dart';
import 'package:chat_flow/utils/tools/auth_exception.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Auth bloc sınıfı
/// Bu sınıf, auth işlemleri için gerekli olan business logic'i içerir
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthOnlineStatusChanged>(_onOnlineStatusChanged);
    on<AuthLastSeenUpdated>(_onLastSeenUpdated);
  }

  final _authService = locator<AuthService>();
  final _userService = locator<UserService>();

  /// Login event'i
  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      await _authService.login(email: event.email, password: event.password);
      await _userService.updateOnlineStatus(isOnline: true);
      await _saveToken();
      await _updateFcmToken();
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(AuthExceptionHandler.findExceptionType(e)));
    }
  }

  /// Register event'i
  Future<void> _onRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      await _authService.register(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );
      await _userService.updateOnlineStatus(isOnline: true);
      await _saveToken();
      await _updateFcmToken();
      emit(const AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(AuthExceptionHandler.findExceptionType(e)));
    }
  }

  /// Logout event'i
  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      await _userService.updateOnlineStatus(isOnline: false);
      await _authService.logout();
      await _clearToken();
      emit(const AuthInitial());
    } catch (e) {
      log('Logout hatası: $e');
      emit(AuthError(e.toString()));
    }
  }

  /// Auth check event'i
  Future<void> _onCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      emit(const AuthLoading());
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _userService.updateOnlineStatus(isOnline: true);
        await _saveToken();
        await _updateFcmToken();
        emit(const AuthSuccess());
      } else {
        emit(const AuthInitial());
      }
    } catch (e) {
      log('Auth check hatası: $e');
      emit(AuthError(e.toString()));
    }
  }

  /// Online status event'i
  Future<void> _onOnlineStatusChanged(AuthOnlineStatusChanged event, Emitter<AuthState> emit) async {
    try {
      await _userService.updateOnlineStatus(isOnline: event.isOnline);
    } catch (e) {
      log('Online status güncelleme hatası: $e');
    }
  }

  /// Last seen event'i
  Future<void> _onLastSeenUpdated(AuthLastSeenUpdated event, Emitter<AuthState> emit) async {
    try {
      await _userService.updateLastSeen();
    } catch (e) {
      log('Last seen güncelleme hatası: $e');
    }
  }

  Future<void> _saveToken() async {
    final user = FirebaseAuth.instance.currentUser;
    final token = await user?.getIdToken();
    await _authService.updateToken(token);
  }

  Future<void> _clearToken() async {
    await _authService.updateToken(null);
  }

  Future<void> _updateFcmToken() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseMessaging.instance.getToken().then((value) async {
      log('FCM Token: $value');
      await _authService.saveFcmToken(user!.uid, value);
    });
  }
}
