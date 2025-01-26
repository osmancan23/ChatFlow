import 'package:chat_flow/core/base/view_model/base_view_model.dart';
import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/feature/auth/register/view/register_view.dart';
import 'package:chat_flow/feature/main/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Login ekranı için ViewModel sınıfı
/// Bu sınıf, login işlemleri için gerekli olan business logic'i içerir
class LoginViewModel extends BaseViewModel {
  LoginViewModel();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;

  @override
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// AuthBloc state'ini dinler
  void onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      navigateToPageClear(context, const MainView());
    } else if (state is AuthFailure) {
      showError(context, state.message);
    }
  }

  /// Kayıt ol sayfasına yönlendirir
  void navigateToRegister(BuildContext context) {
    navigateToPage(context, const RegisterView());
  }

  /// Login işlemini gerçekleştirir
  void login(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  void onDispose() {
    emailController.dispose();
    passwordController.dispose();
    super.onDispose();
  }
}
