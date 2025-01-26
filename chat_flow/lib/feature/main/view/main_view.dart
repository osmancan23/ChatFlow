import 'package:chat_flow/feature/home/view/home_view.dart';
import 'package:chat_flow/feature/main/viewmodel/main_view_model.dart';
import 'package:chat_flow/feature/profile/view/profile_view.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Ana uygulama ekranı
/// Alt navigasyon barı ile farklı ekranlar arasında geçiş sağlayan ekran
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          body: _buildBody(viewModel),
          bottomNavigationBar: _buildBottomNavigationBar(context, viewModel),
        ),
      ),
    );
  }

  /// Body widget'ı
  Widget _buildBody(MainViewModel viewModel) {
    return IndexedStack(
      index: viewModel.currentIndex,
      children: const [
        HomeView(),
        ProfileView(),
      ],
    );
  }

  /// Alt navigasyon barı widget'ı
  Widget _buildBottomNavigationBar(BuildContext context, MainViewModel viewModel) {
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

/// Main ekranı için string sabitleri
class _MainViewStrings {
  const _MainViewStrings._();

  static const String chatTab = 'Sohbetler';
  static const String profileTab = 'Profil';
}
