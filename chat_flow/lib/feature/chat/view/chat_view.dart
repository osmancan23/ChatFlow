import 'package:chat_flow/core/components/indicator/typing_indicator.dart';
import 'package:flutter/material.dart';
part '../mixin/chat_view_mixin.dart';
part '../widget/chat_appbar_widget.dart';
part '../widget/chat_message_box_widget.dart';
part '../widget/chat_message_input_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.chatId, super.key});
  final int chatId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with _ChatViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatAppbarWidget(widget: widget, isTyping: _isTyping),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    final isMe = index.isEven;
                    return _ChatMessageBox(
                      isMe: isMe,
                      index: index,
                    );
                  },
                ),
                _TypingIndicator(isTyping: _isTyping),
              ],
            ),
          ),
          _ChatMessageInputWidget(messageController: _messageController),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator({
    required bool isTyping,
  }) : _isTyping = isTyping;

  final bool _isTyping;

  @override
  Widget build(BuildContext context) {
    return _isTyping
        ? Positioned(
            bottom: 0,
            left: 0,
            child: AnimatedOpacity(
              opacity: _isTyping ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: const TypingIndicator(),
            ),
          )
        : const SizedBox.shrink();
  }
}
