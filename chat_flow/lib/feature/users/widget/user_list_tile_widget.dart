part of '../view/users_view.dart';

/// Kullanıcı liste öğesi widget'ı
class _UserListTileWidget extends StatelessWidget {
  const _UserListTileWidget({
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
