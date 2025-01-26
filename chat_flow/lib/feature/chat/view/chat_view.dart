import 'package:chat_flow/core/components/cacheNetworkImage/cache_network_image_widget.dart';
import 'package:chat_flow/core/components/streamBuilder/stream_builder_widget.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/components/text_field/custom_text_field.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:chat_flow/feature/chat/viewmodel/chat_view_model.dart';
import 'package:chat_flow/utils/extension/context_extensions.dart';
import 'package:chat_flow/utils/extension/num_extensions.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
part '../widget/chat_appbar_widget.dart';
part '../widget/chat_message_box_widget.dart';
part '../widget/chat_message_input_widget.dart';

/// Chat ekranı
/// Kullanıcıların mesajlaşmasını sağlayan ekran
class ChatView extends StatelessWidget {
  const ChatView({
    required this.chatId,
    super.key,
  });

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = ChatViewModel();
        viewModel.initChat(chatId);
        return viewModel;
      },
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          appBar: _buildAppBar(context, viewModel),
          body: _buildBody(context, viewModel),
        ),
      ),
    );
  }

  /// AppBar widget'ı
  PreferredSizeWidget _buildAppBar(BuildContext context, ChatViewModel viewModel) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            viewModel.otherUser?.fullName ?? '',
            textStyle: context.theme.textTheme.titleMedium,
          ),
          if (viewModel.otherUserTyping)
            CustomText(
              _ChatViewStrings.typingText,
              textStyle: context.theme.textTheme.bodySmall,
            ),
        ],
      ),
    );
  }

  /// Body widget'ı
  Widget _buildBody(BuildContext context, ChatViewModel viewModel) {
    return Column(
      children: [
        Expanded(
          child: _buildMessageList(viewModel),
        ),
        _buildMessageInput(context, viewModel),
      ],
    );
  }

  /// Mesaj listesi widget'ı
  Widget _buildMessageList(ChatViewModel viewModel) {
    return ListView.builder(
      reverse: true,
      controller: viewModel.scrollController,
      padding: PaddingConstants.paddingAllSmall,
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return _MessageBubble(
          message: message,
          isMe: message.senderId == viewModel.currentUserId,
          isRead: viewModel.isLastMessageRead,
        );
      },
    );
  }

  /// Mesaj input widget'ı
  Widget _buildMessageInput(BuildContext context, ChatViewModel viewModel) {
    return Container(
      padding: PaddingConstants.paddingAllSmall,
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: viewModel.messageController,
              hintText: _ChatViewStrings.messageHint,
              onChanged: (value) => viewModel.updateTypingStatus(isTyping: value.isNotEmpty),
            ),
          ),
          10.w.pw,
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => viewModel.sendMessage(context),
          ),
        ],
      ),
    );
  }
}

/// Mesaj balonu widget'ı
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.isRead,
  });

  final MessageModel message;
  final bool isMe;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8.h,
          left: isMe ? 50.w : 0,
          right: isMe ? 0 : 50.w,
        ),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isMe ? context.theme.primaryColor : context.theme.cardColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              message.content,
              textStyle: context.theme.textTheme.bodyMedium?.copyWith(
                color: isMe ? Colors.white : null,
              ),
            ),
            if (isMe) ...[
              5.h.ph,
              Icon(
                isRead ? Icons.done_all : Icons.done,
                size: 16.r,
                color: Colors.white70,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Chat ekranı için string sabitleri
class _ChatViewStrings {
  const _ChatViewStrings._();

  static const String typingText = 'Yazıyor...';
  static const String messageHint = 'Mesajınızı yazın...';
}
