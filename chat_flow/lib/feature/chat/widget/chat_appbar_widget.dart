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
    _chatService = ChatService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilderWidget(
      stream: _chatService.streamOtherUserData(widget.chatId),
      builder: (context, data) {
        return AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: Hero(
            tag: 'chat_${widget.chatId}',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/004/899/680/non_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg',
                  ),
                  radius: 20,
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
                          data?.lastSeen?.formatDateDifference == 'Şimdi'
                              ? 'Çevrimiçi'
                              : 'Son görülme: ${data?.lastSeen?.formatDateDifference}',
                          textStyle: context.general.textTheme.bodySmall?.copyWith(),
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
