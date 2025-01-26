import 'dart:async';
import 'dart:developer';

import 'package:chat_flow/core/bloc/chat/chat_bloc.dart';
import 'package:chat_flow/core/components/cacheNetworkImage/cache_network_image_widget.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:chat_flow/feature/users/viewmodel/users_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
part '../widget/user_tile_widget.dart';

/// Kullanıcılar ekranı
/// Tüm kullanıcıların listelendiği ve arama yapılabildiği ekran
class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersViewModel(),
      child: Consumer<UsersViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: _buildAppBar(),
          body: _buildBody(context, viewModel),
        ),
      ),
    );
  }

  /// AppBar widget'ı
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const CustomText(_UsersViewStrings.title),
    );
  }

  /// Body widget'ı
  Widget _buildBody(BuildContext context, UsersViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: _buildUserList(context, viewModel),
        ),
      ],
    );
  }

  /// Kullanıcı listesi widget'ı
  Widget _buildUserList(BuildContext context, UsersViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.users.isEmpty) {
      return Center(
        child: CustomText(
          _UsersViewStrings.noUsers,
          textStyle: context.theme.textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.users.length,
      padding: PaddingConstants.paddingAllSmall,
      itemBuilder: (context, index) {
        final user = viewModel.users[index];
        return _UserListTile(
          user: user,
          onTap: () => viewModel.onUserTap(context, user),
        );
      },
    );
  }
}

/// Kullanıcı liste öğesi widget'ı
class _UserListTile extends StatelessWidget {
  const _UserListTile({
    required this.user,
    required this.onTap,
  });

  final UserModel user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: user.profilePhoto != null ? NetworkImage(user.profilePhoto!) : null,
        child: user.profilePhoto == null ? Icon(Icons.person, size: 24.r) : null,
      ),
      title: CustomText(
        user.fullName,
        textStyle: context.theme.textTheme.titleMedium,
      ),
      subtitle: CustomText(
        user.email,
        textStyle: context.theme.textTheme.bodySmall,
      ),
    );
  }
}

/// Users ekranı için string sabitleri
class _UsersViewStrings {
  const _UsersViewStrings._();

  static const String title = 'Kullanıcılar';
  static const String noUsers = 'Kullanıcı bulunamadı';
}
