part of "../view/chat_view.dart";

class _ChatMessageInputWidget extends StatelessWidget {
  const _ChatMessageInputWidget({
    required TextEditingController messageController,
    super.key,
  }) : _messageController = messageController;

  final TextEditingController _messageController;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: Implement attachment
            },
            icon: const Icon(Icons.attach_file),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Mesaj yazın...',
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          IconButton(
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                // TODO: Send message
                _messageController.clear();
              }
            },
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
