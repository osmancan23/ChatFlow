import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/init/validator/app_validator.dart';
import 'package:flutter/material.dart';
part '../mixin/provile_view_mixin.dart';
part '../widget/profile_avatar_widget.dart';
part '../widget/notification_switch_widget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> with _ProfileViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(_ProfileViewStrings.title),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: PaddingConstants.paddingAllSmall,
        child: Column(
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
                      if (_formKey.currentState!.validate()) {}
                    },
                    child: const Text(_ProfileViewStrings.updateButtonText),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PaddingConstants.large),
            const _NotificationSwitchWidget(),
          ],
        ),
      ),
    );
  }
}
