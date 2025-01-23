import 'package:chat_flow/core/components/streamBuilder/stream_builder_widget.dart';

import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      appBar: _UsersViewAppbarWidget(
        _isSearching,
        _searchController,
        toggleSearch,
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

class _UsersViewAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const _UsersViewAppbarWidget(this._isSearching, this._searchController, this.toggleSearch);

  final bool _isSearching;
  final TextEditingController _searchController;
  final void Function() toggleSearch;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Kullanıcı ara...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black54),
                ),
                style: const TextStyle(color: Colors.black87),
                autofocus: true,
              )
            : const Text('Yeni Sohbet'),
      ),
      actions: [
        IconButton(
          onPressed: toggleSearch,
          icon: Icon(_isSearching ? Icons.close : Icons.search),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
