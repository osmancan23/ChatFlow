import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:chat_flow/feature/users/view/users_view.dart';
import 'package:flutter/material.dart';
part '../widget/chat_list_tile_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sohbetler'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return _ChatListTileWidget(index: index);
        },
      ),
      floatingActionButton: const _FloatingButtonWidget(),
    );
  }
}

class _FloatingButtonWidget extends StatelessWidget {
  const _FloatingButtonWidget();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: FloatingActionButton(
            onPressed: () {
              NavigationService.instance.navigateToPage(
                context: context,
                page: const UsersView(),
              );
            },
            child: const Icon(Icons.chat),
          ),
        );
      },
    );
  }
}
