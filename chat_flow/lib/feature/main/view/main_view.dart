import 'package:chat_flow/feature/home/view/home_view.dart';
import 'package:chat_flow/feature/main/viewmodel/main_view_model.dart';
import 'package:chat_flow/feature/profile/view/profile_view.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
part '../widget/main_body_widget.dart';
part '../widget/main_bottom_navigation_bar_widget.dart';

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
          body: _MainBodyWidget(viewModel: viewModel),
          bottomNavigationBar: _MainBottomNavigationBarWidget(viewModel: viewModel),
        ),
      ),
    );
  }
}

/// Main ekranı için string sabitleri
class _MainViewStrings {
  const _MainViewStrings._();

  static const String chatTab = 'Sohbetler';
  static const String profileTab = 'Profil';
}
