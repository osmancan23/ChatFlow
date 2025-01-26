part of '../view/chat_view.dart';

/// Chat mesaj input widget'ı
class _MessageInputWidget extends StatelessWidget {
  const _MessageInputWidget({
    required this.viewModel,
    super.key,
  });

  final ChatViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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