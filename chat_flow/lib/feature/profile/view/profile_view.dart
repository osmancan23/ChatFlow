import 'dart:async';

import 'package:chat_flow/core/bloc/bloc/user_bloc.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/init/validator/app_validator.dart';
import 'package:chat_flow/core/service/user_service.dart';
import 'package:chat_flow/feature/auth/bloc/auth_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part '../mixin/provile_view_mixin.dart';
part '../widget/profile_avatar_widget.dart';
part '../widget/notification_switch_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_ProfileViewStrings.title),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const _ProfileBodyWidget(),
    );
  }
}

class _ProfileBodyWidget extends StatefulWidget {
  const _ProfileBodyWidget({
    super.key,
  });

  @override
  State<_ProfileBodyWidget> createState() => _ProfileBodyWidgetState();
}

class _ProfileBodyWidgetState extends State<_ProfileBodyWidget> with _ProfileViewMixin {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: PaddingConstants.paddingAllSmall,
      child: BlocConsumer<UserBloc, UserState>(
        bloc: _userBloc,
        listener: (context, state) {
          if (state is UserProfileUpdated) {
            _userBloc.add(FetchCurrentUserProfile());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil güncellendi.'),
              ),
            );
          } else if (state is UserProfileUpdateError) {
            _userBloc.add(FetchCurrentUserProfile());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CurrentUserProfileLoaded) {
            return Column(
              children: [
                const _ProfileAvatarWidget(),
                const SizedBox(height: PaddingConstants.large),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _nameController,
                        labelText: _ProfileViewStrings.nameLabel,
                        prefixIcon: const Icon(Icons.person_outline),
                        validator: AppValidator.name,
                      ),
                      const SizedBox(height: PaddingConstants.small),
                      CustomTextField(
                        controller: _bioController,
                        labelText: _ProfileViewStrings.bioLabel,
                        maxLines: 3,
                        prefixIcon: const Icon(Icons.info_outline),
                        validator: (value) => AppValidator.maxLength(
                          value,
                          200,
                          message: _ProfileViewStrings.bioMaxLengthError,
                        ),
                      ),
                      const SizedBox(height: PaddingConstants.large),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _userBloc.add(
                              UpdateUserProfile(
                                state.user.copyWith(
                                  fullName: _nameController.text,
                                  bio: _bioController.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text(_ProfileViewStrings.updateButtonText),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PaddingConstants.large),
                const _NotificationSwitchWidget(),
              ],
            );
          } else if (state is CurrentUserProfileError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
