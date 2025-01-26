import 'dart:io';

import 'package:chat_flow/core/base/viewModel/base_view_model.dart';
import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/firebase/firebase_storage_service.dart';
import 'package:chat_flow/core/service/user/user_service.dart';
import 'package:chat_flow/feature/auth/login/view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

/// Profil ekranı için ViewModel sınıfı
/// Bu sınıf, profil işlemleri için gerekli olan business logic'i içerir
class ProfileViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final FirebaseStorageService _storageService = locator<FirebaseStorageService>();
  final nameController = TextEditingController();

  UserModel? _user;
  UserModel? get user => _user;

  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  set notificationsEnabled(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  /// Kullanıcı profilini yükler
  Future<void> _loadUserProfile() async {
    isLoading = true;
    _user = await _userService.getCurrentUserProfile();
    if (_user != null) {
      nameController.text = _user!.fullName;
      _notificationsEnabled = _user!.notificationsEnabled;
    }
    isLoading = false;
  }

  /// Profil resmini günceller
  Future<void> updateProfileImage(BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      isLoading = true;
      final imageUrl = await _storageService.uploadFile(file: File(image.path), path: FirebaseStoragePathEnum.avatar);

      if (_user != null) {
        _user = _user!.copyWith(profilePhoto: imageUrl);
        await _userService.updateUserProfile(_user!);
        showSuccess(context, 'Profil resmi güncellendi');
      }
    } catch (e) {
      showError(context, 'Profil resmi güncellenirken hata oluştu');
    } finally {
      isLoading = false;
    }
  }

  /// Profil bilgilerini günceller
  Future<void> updateProfile(BuildContext context) async {
    if (_user == null) return;

    try {
      isLoading = true;
      final updatedUser = _user!.copyWith(
        fullName: nameController.text.trim(),
        notificationsEnabled: _notificationsEnabled,
      );
      await _userService.updateUserProfile(updatedUser);
      await _userService.updateNotificationsEnabled(isEnabled: _notificationsEnabled);
      showSuccess(context, 'Profil güncellendi');
    } catch (e) {
      showError(context, 'Profil güncellenirken hata oluştu');
    } finally {
      isLoading = false;
    }
  }

  /// Çıkış yapar
  void logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  /// AuthBloc state'ini dinler
  void onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthInitial) {
      navigateToPageClear(context, const LoginView());
    }
  }

  @override
  void onDispose() {
    nameController.dispose();
    super.onDispose();
  }
}
