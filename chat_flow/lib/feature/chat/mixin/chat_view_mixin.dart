part of '../view/chat_view.dart';

mixin _ChatViewMixin on State<ChatView> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isTyping = false;
  late IChatService _chatService;

  @override
  void initState() {
    _chatService = locator<ChatService>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _chatService.markMessageAsRead(widget.chatId);

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _chatService.updateChatTypingStatus(chatId: widget.chatId, isTyping: false);
    });

    _messageController.removeListener(_onTextChanged);

    _scrollController.dispose();

    super.dispose();
  }

  void _onTextChanged() {
    final isCurrentlyTyping = _messageController.text.isNotEmpty;
    if (isCurrentlyTyping != _isTyping) {
      setState(() {
        _isTyping = isCurrentlyTyping;
      });
    }
  }
}
