part of '../view/main_view.dart';

/// Main bottom navigation bar widget'ı
class _MainBottomNavigationBarWidget extends StatelessWidget {
  const _MainBottomNavigationBarWidget({
    required this.viewModel,
  });

  final MainViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: viewModel.currentIndex,
      onTap: viewModel.onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.chat),
          label: _MainViewStrings.chatTab,
          backgroundColor: context.theme.primaryColor,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: _MainViewStrings.profileTab,
          backgroundColor: context.theme.primaryColor,
        ),
      ],
    );
  }
} 