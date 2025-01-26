part of '../view/home_view.dart';

/// Home FAB widget'ı
class _HomeFABWidget extends StatelessWidget {
  const _HomeFABWidget({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => viewModel.navigateToUsers(context),
      child: const Icon(Icons.add),
    );
  }
} 