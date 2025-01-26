part of '../view/users_view.dart';

/// Users Body widget'ı
class _UsersBodyWidget extends StatelessWidget {
  const _UsersBodyWidget({
    required this.viewModel,
  });

  final UsersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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
        return _UserListTileWidget(
          user: user,
          onTap: () => viewModel.onUserTap(context, user),
        );
      },
    );
  }
} 