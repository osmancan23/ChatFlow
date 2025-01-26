import 'package:chat_flow/core/base/view_model/base_view_model.dart';
import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/feature/main/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Register ekranı için ViewModel sınıfı
/// Bu sınıf, kayıt işlemleri için gerekli olan business logic'i içerir
class RegisterViewModel extends BaseViewModel {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// AuthBloc state'ini dinler
  void onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthSuccess) {
      navigateToPageClear(context, const MainView());
    } else if (state is AuthError) {
      showError(context, state.message);
    }
  }

  /// Giriş sayfasına geri döner
  void navigateToLogin(BuildContext context) {
    navigateBack(context);
  }

  /// Kayıt işlemini gerçekleştirir
  void register(BuildContext context) {
    if (formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              fullName: nameController.text.trim(),
            ),
          );
    }
  }

  @override
  void onDispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onDispose();
  }
}
