part of '../view/users_view.dart';

/// Users AppBar widget'ı
class _UsersAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const _UsersAppBarWidget();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CustomText(_UsersViewStrings.title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 