part of '../view/chat_view.dart';

class _ChatAppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  const _ChatAppbarWidget({
    required this.chatId,
  });

  final String chatId;

  @override
  State<_ChatAppbarWidget> createState() => _ChatAppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _ChatAppbarWidgetState extends State<_ChatAppbarWidget> {
  late IChatService _chatService;

  @override
  void initState() {
    _chatService = locator<ChatService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilderWidget(
      stream: _chatService.getChatOtherUser(widget.chatId),
      builder: (context, data) {
        return AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: Hero(
            tag: 'chat_${widget.chatId}',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 20,
                  child: CacheNetworkImageWidget(imageUrl: data?.profilePhoto),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        data?.fullName ?? '',
                        textStyle: Theme.of(context).textTheme.titleMedium,
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: CustomText(
                          data?.lastSeen!.formatDateDifference == 'Şimdi' ? 'Çevrimiçi' : 'Son görülme: ',
                          textStyle: context.theme.textTheme.bodySmall?.copyWith(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
