part of '../view/login_view.dart';

mixin _LoginViewMixin on State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}

class _LoginViewStrings {
  const _LoginViewStrings._();

  // AppBar
  static const String title = 'Giriş Yap';

  // Form
  static const String emailLabel = 'E-posta';
  static const String emailHint = 'ornek@email.com';
  static const String passwordLabel = 'Şifre';
  static const String passwordHint = '••••••••';
  static const String loginButtonText = 'Giriş Yap';

  // Register Text
  static const String noAccountText = 'Hesabın yok mu?';
  static const String registerButtonText = 'Kayıt Ol';
}
