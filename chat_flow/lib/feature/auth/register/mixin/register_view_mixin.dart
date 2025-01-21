part of '../view/register_view.dart';

mixin _RegisterViewMixin on State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

class _RegisterViewStrings {
  const _RegisterViewStrings._();

  // AppBar
  static const String title = 'Kayıt Ol';

  // Form
  static const String emailLabel = 'E-posta';
  static const String emailHint = 'ornek@email.com';
  static const String passwordLabel = 'Şifre';
  static const String passwordHint = '••••••••';
  static const String registerButtonText = 'Kayıt Ol';

  // Login Text
  static const String hasAccountText = 'Zaten hesabın var mı?';
  static const String loginButtonText = 'Giriş Yap';
}
