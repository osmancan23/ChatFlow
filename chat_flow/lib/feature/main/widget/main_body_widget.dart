part of '../view/main_view.dart';

/// Main body widget'ı
class _MainBodyWidget extends StatelessWidget {
  const _MainBodyWidget({
    required this.viewModel,
  });

  final MainViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: viewModel.currentIndex,
      children: const [
        HomeView(),
        ProfileView(),
      ],
    );
  }
} 