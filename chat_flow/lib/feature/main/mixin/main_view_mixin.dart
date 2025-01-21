part of '../view/main_view.dart';

mixin _MainViewMixin on State<MainView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const ProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
