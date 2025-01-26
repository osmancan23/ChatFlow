part of '../view/chat_view.dart';

/// Chat mesaj listesi widget'ı
class _MessageListWidget extends StatelessWidget {
  const _MessageListWidget({
    required this.viewModel,
    super.key,
  });

  final ChatViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      controller: viewModel.scrollController,
      padding: PaddingConstants.paddingAllSmall,
      itemCount: viewModel.messages.length,
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        final isLastMessage = index == 0;
        final showStatus = isLastMessage && message.senderId == viewModel.currentUserId;
        return _MessageBubbleWidget(
          message: message,
          isMe: message.senderId == viewModel.currentUserId,
          showStatus: showStatus,
          isRead: message.isRead,
        );
      },
    );
  }
} 