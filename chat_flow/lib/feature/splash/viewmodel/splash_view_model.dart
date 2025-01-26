import 'package:chat_flow/core/base/view_model/base_view_model.dart';
import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/feature/auth/login/view/login_view.dart';
import 'package:chat_flow/feature/main/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Splash ekranı için ViewModel sınıfı
/// Bu sınıf, splash işlemleri için gerekli olan business logic'i içerir
class SplashViewModel extends BaseViewModel {
  /// Splash ekranında yapılacak işlemleri başlatır
  void initSplash(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        checkAuthState(context);
      }
    });
  }

  /// Kullanıcının oturum durumunu kontrol eder
  void checkAuthState(BuildContext context) {
    context.read<AuthBloc>().add(const AuthCheckRequested());
  }

  /// AuthBloc state'ini dinler
  void onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      navigateToPageClear(context, const MainView());
    } else if (state is AuthInitial) {
      navigateToPageClear(context, const LoginView());
    }
  }
}
