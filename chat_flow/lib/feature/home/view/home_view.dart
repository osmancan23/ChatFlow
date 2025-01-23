import 'package:chat_flow/core/components/streamBuilder/stream_builder_widget.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:chat_flow/feature/users/view/users_view.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
part '../widget/chat_list_tile_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late IChatService _chatService;

  @override
  void initState() {
    _chatService = ChatService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sohbetler'),
      ),
      body: StreamBuilderWidget(
        stream: _chatService.getUserChats(),
        builder: (context, List<ChatModel>? chats) {
          return ListView.builder(
            itemCount: chats?.length ?? 0,
            itemBuilder: (context, index) {
              final chat = chats![index];
              return _ChatListTileWidget(
                index: index,
                chat: chat,
              );
            },
          );
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
