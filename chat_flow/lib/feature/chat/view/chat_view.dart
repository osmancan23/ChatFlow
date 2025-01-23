
import 'package:chat_flow/core/components/indicator/typing_indicator.dart';
import 'package:chat_flow/core/components/streamBuilder/stream_builder_widget.dart';
import 'package:chat_flow/core/components/text/custom_text.dart';
import 'package:chat_flow/core/constants/app/padding_constants.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:chat_flow/utils/extension/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
part '../mixin/chat_view_mixin.dart';
part '../widget/chat_appbar_widget.dart';
part '../widget/chat_message_box_widget.dart';
part '../widget/chat_message_input_widget.dart';

class ChatView extends StatefulWidget {
  const ChatView({required this.chatId, super.key});
  final String chatId;

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with _ChatViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatAppbarWidget(chatId: widget.chatId),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                StreamBuilderWidget(
                  stream: _chatService.getChatMessages(widget.chatId),
                  builder: (context, List<MessageModel>? messages) {
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: messages?.length ?? 0,
                      itemBuilder: (context, index) {
                        final message = messages![index];
                        return Padding(
                          padding: PaddingConstants.paddingHorizontalSmall,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _ChatMessageBox(message: message, index: index),
                              if ((index == 0) && message.isMe)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    StreamBuilderWidget(
                                      stream: _chatService.getLastMessageReadStatus(widget.chatId),
                                      builder: (context, data) {
                                        return Padding(
                                          padding: PaddingConstants.paddingHorizontalMedium,
                                          child: CustomText(
                                            (data ?? false) ? 'Okundu' : 'Gönderildi',
                                            textStyle: context.general.textTheme.bodySmall,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                _TypingIndicator(
                  chatId: widget.chatId,
                ),
              ],
            ),
          ),
          _ChatMessageInputWidget(
            messageController: _messageController,
            chatId: widget.chatId,
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator({required this.chatId});
  final String chatId;
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> {
  late IChatService _chatService;

  @override
  void initState() {
    _chatService = ChatService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _chatService.listenToOtherUserTypingStatus(widget.chatId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final isTyping = snapshot.data as bool;
          return isTyping
              ? const Align(
                  alignment: Alignment.bottomLeft,
                  child: TypingIndicator(),
                )
              : const SizedBox();
        }
        return const SizedBox();
      },
    );
  }
}
