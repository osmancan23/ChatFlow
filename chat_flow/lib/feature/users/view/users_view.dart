import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
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
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 15,
        itemBuilder: (context, index) {
          return _UserTileWidget(index: index);
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
