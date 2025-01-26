import 'dart:async';
import 'dart:io';

import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/core/bloc/user/user_bloc.dart';
import 'package:chat_flow/core/components/button/button.dart';
import 'package:chat_flow/core/components/cacheNetworkImage/cache_network_image_widget.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';

import 'package:chat_flow/core/service/user/user_service.dart';
import 'package:chat_flow/feature/profile/viewmodel/profile_view_model.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
part '../widget/profile_avatar_widget.dart';
part '../widget/notification_switch_widget.dart';

/// Profil ekranı
/// Kullanıcının profil bilgilerini görüntülemesini ve düzenlemesini sağlayan ekran
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: Consumer<ProfileViewModel>(
        builder: (context, viewModel, _) => BlocListener<AuthBloc, AuthState>(
          listener: viewModel.onAuthStateChanged,
          child: Scaffold(
            appBar: _buildAppBar(context, viewModel),
            body: _buildBody(context, viewModel),
          ),
        ),
      ),
    );
  }

  /// AppBar widget'ı
  PreferredSizeWidget _buildAppBar(BuildContext context, ProfileViewModel viewModel) {
    return AppBar(
      title: const CustomText(_ProfileViewStrings.title),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => viewModel.logout(context),
        ),
      ],
    );
  }

  /// Body widget'ı
  Widget _buildBody(BuildContext context, ProfileViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: PaddingConstants.paddingAllSmall,
      child: Column(
        children: [
          _buildProfileImage(context, viewModel),
          20.h.ph,
          _buildNameField(viewModel),
          20.h.ph,
          _buildNotificationToggle(viewModel),
          30.h.ph,
          _buildUpdateButton(context, viewModel),
        ],
      ),
    );
  }

  /// Profil resmi widget'ı
  Widget _buildProfileImage(BuildContext context, ProfileViewModel viewModel) {
    return GestureDetector(
      onTap: () => viewModel.updateProfileImage(context),
      child: CircleAvatar(
        radius: 60.r,
        backgroundImage: viewModel.user?.profilePhoto != null ? NetworkImage(viewModel.user!.profilePhoto!) : null,
        child: viewModel.user?.profilePhoto == null ? Icon(Icons.person, size: 60.r) : null,
      ),
    );
  }

  /// İsim alanı widget'ı
  Widget _buildNameField(ProfileViewModel viewModel) {
    return CustomTextField(
      controller: viewModel.nameController,
      labelText: _ProfileViewStrings.nameLabel,
      hintText: _ProfileViewStrings.nameHint,
      prefixIcon: const Icon(Icons.person_outline),
    );
  }

  /// Bildirim toggle widget'ı
  Widget _buildNotificationToggle(ProfileViewModel viewModel) {
    return SwitchListTile(
      title: const CustomText(_ProfileViewStrings.notificationsLabel),
      value: viewModel.notificationsEnabled,
      onChanged: (value) => viewModel.notificationsEnabled = value,
    );
  }

  /// Güncelle butonu widget'ı
  Widget _buildUpdateButton(BuildContext context, ProfileViewModel viewModel) {
    return ButtonWidget(
      onTap: () => viewModel.updateProfile(context),
      text: _ProfileViewStrings.updateButtonText,
    );
  }
}

/// Profil ekranı için string sabitleri
class _ProfileViewStrings {
  const _ProfileViewStrings._();

  static const String title = 'Profil';
  static const String nameLabel = 'Ad Soyad';
  static const String nameHint = 'John Doe';
  static const String notificationsLabel = 'Bildirimleri Aç';
  static const String updateButtonText = 'Güncelle';
}
