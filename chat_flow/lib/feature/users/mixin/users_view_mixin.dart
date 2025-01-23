part of '../view/users_view.dart';

mixin _UsersViewMixin on State<UsersView> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  late IChatService _chatService;
  @override
  void initState() {
    _chatService = locator<ChatService>();
    super.initState();
  }

  void toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
