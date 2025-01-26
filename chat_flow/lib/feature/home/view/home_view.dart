import 'package:chat_flow/core/components/cacheNetworkImage/cache_network_image_widget.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:chat_flow/feature/home/viewmodel/home_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
part '../widget/chat_list_tile_widget.dart';

/// Ana ekran
/// Kullanıcının mevcut sohbetlerini görüntülediği ve yönettiği ekran
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: _buildAppBar(context, viewModel),
          body: _buildBody(context, viewModel),
          floatingActionButton: _buildFAB(context, viewModel),
        ),
      ),
    );
  }

  /// AppBar widget'ı
  PreferredSizeWidget _buildAppBar(BuildContext context, HomeViewModel viewModel) {
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

  /// Body widget'ı
  Widget _buildBody(BuildContext context, HomeViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.chats.isEmpty) {
      return Center(
        child: CustomText(
          _HomeViewStrings.noChats,
          textStyle: context.theme.textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: viewModel.chats.length,
      padding: PaddingConstants.paddingAllSmall,
      itemBuilder: (context, index) {
        final chat = viewModel.chats[index];
        return _ChatListTile(
          chat: chat,
          onTap: () => viewModel.onChatTap(context, chat.id),
        );
      },
    );
  }

  /// Floating Action Button widget'ı
  Widget _buildFAB(BuildContext context, HomeViewModel viewModel) {
    return FloatingActionButton(
      onPressed: () => viewModel.navigateToUsers(context),
      child: const Icon(Icons.add),
    );
  }
}

/// Sohbet liste öğesi widget'ı
class _ChatListTile extends StatelessWidget {
  const _ChatListTile({
    required this.chat,
    required this.onTap,
  });

  final ChatModel chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage:
            chat.getOtherUser()?.profilePhoto != null ? NetworkImage(chat.getOtherUser()!.profilePhoto!) : null,
        child: chat.getOtherUser()?.profilePhoto == null ? Icon(Icons.person, size: 24.r) : null,
      ),
      title: CustomText(
        chat.getOtherUser()?.fullName,
        textStyle: context.theme.textTheme.titleMedium,
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: CustomText(
              chat.lastMessage?.content ?? '',
              textStyle: context.theme.textTheme.bodySmall,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Home ekranı için string sabitleri
class _HomeViewStrings {
  const _HomeViewStrings._();

  static const String title = 'Sohbetler';
  static const String noChats = 'Henüz sohbet yok';
}
