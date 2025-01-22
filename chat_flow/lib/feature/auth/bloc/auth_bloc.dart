import 'package:chat_flow/utils/tools/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chat_flow/core/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        super(const AuthInitial()) {
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
  }
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  Future<void> _onAuthLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(const AuthSuccess());
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
      // Firebase Auth ile kullanıcı oluştur
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      // Kullanıcı modelini oluştur
      final user = UserModel(
        id: userCredential.user!.uid,
        email: event.email,
        fullName: event.fullName,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Firestore'a kullanıcı bilgilerini kaydet
      await _firestore.collection('users').doc(user.id).set(user.toMap());

      emit(const AuthSuccess());
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
      final userId = _firebaseAuth.currentUser?.uid;
      if (userId != null) {
        // Kullanıcı çıkış yaparken online durumunu güncelle
        await _firestore.collection('users').doc(userId).update({
          'isOnline': false,
          'lastSeen': DateTime.now().toIso8601String(),
        });
      }
      await _firebaseAuth.signOut();
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
        emit(const AuthSuccess());
      } catch (e) {
        emit(const AuthSuccess());
      }
    } else {
      emit(const AuthInitial());
    }
  }
}
