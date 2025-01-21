part of '../view/profile_view.dart';

mixin _ProfileViewMixin on State<ProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}

class _ProfileViewStrings {
  const _ProfileViewStrings._();

  // AppBar
  static const String title = 'Profil';

  // Form
  static const String nameLabel = 'Ad Soyad';
  static const String bioLabel = 'Hakkımda';
  static const String updateButtonText = 'Profili Güncelle';
  static const String bioMaxLengthError = 'Hakkımda en fazla 200 karakter olmalıdır';

  // Settings
  static const String notificationsLabel = 'Bildirimler';
}
