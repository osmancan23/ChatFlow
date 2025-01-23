import 'dart:async';

import 'package:chat_flow/core/bloc/chat/chat_bloc.dart';
import 'package:chat_flow/core/components/streamBuilder/stream_builder_widget.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part '../mixin/users_view_mixin.dart';
part '../widget/user_tile_widget.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> with _UsersViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText('Yeni Sohbet'),
      ),
      body: StreamBuilderWidget(
        stream: _chatService.getAvailableUsers(),
        builder: (context, List<UserModel>? users) {
          return ListView.builder(
            itemCount: users?.length ?? 0,
            itemBuilder: (context, index) {
              final user = users![index];
              return _UserTileWidget(
                user: user,
                index: index,
              );
            },
          );
        },
      ),
    );
  }
}
