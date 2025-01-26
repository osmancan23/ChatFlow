part of '../view/home_view.dart';

/// Home AppBar widget'ı
class _HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBarWidget({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const CustomText(_HomeViewStrings.title),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () => viewModel.navigateToProfile(context),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 