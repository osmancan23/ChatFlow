part of '../view/chat_view.dart';

class _ChatMessageInputWidget extends StatefulWidget {
  const _ChatMessageInputWidget({
    required TextEditingController messageController,
    required this.chatId,
  }) : _messageController = messageController;

  final TextEditingController _messageController;
  final String chatId;

  @override
  State<_ChatMessageInputWidget> createState() => _ChatMessageInputWidgetState();
}

class _ChatMessageInputWidgetState extends State<_ChatMessageInputWidget> {
  late IChatService _chatService;

  @override
  void initState() {
    _chatService = locator<ChatService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(-1, -1),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: widget._messageController,
                decoration: const InputDecoration(
                  hintText: 'Mesaj yazın...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    await _chatService.updateChatTypingStatus(chatId: widget.chatId, isTyping: true);
                  } else {
                    await _chatService.updateChatTypingStatus(chatId: widget.chatId, isTyping: false);
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                if (widget._messageController.text.isNotEmpty) {
                  try {
                    await _chatService.sendMessage(widget.chatId, widget._messageController.text);
                  } catch (e) {
                    print(e);
                  }
                  widget._messageController.clear();
                }
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
