part of '../view/chat_view.dart';

class _ChatAppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  const _ChatAppbarWidget({
    required this.chatViewModel,
  });

  final ChatViewModel chatViewModel;

  @override
  State<_ChatAppbarWidget> createState() => _ChatAppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _ChatAppbarWidgetState extends State<_ChatAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      leadingWidth: 80.w,
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            radius: 16.r,
            backgroundImage: widget.chatViewModel.otherUser?.profilePhoto != null
                ? NetworkImage(widget.chatViewModel.otherUser!.profilePhoto!)
                : null,
            child: widget.chatViewModel.otherUser?.profilePhoto == null ? Icon(Icons.person, size: 20.r) : null,
          ),
        ],
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            widget.chatViewModel.otherUser?.fullName ?? '',
            textStyle: context.theme.textTheme.titleMedium,
          ),
          CustomText(
            widget.chatViewModel.otherUserTyping
                ? _ChatViewStrings.typingText
                : widget.chatViewModel.otherUser?.isOnline ?? false
                    ? _ChatViewStrings.onlineText
                    : widget.chatViewModel.otherUser?.lastSeen != null
                        ? 'Son görülme: ${widget.chatViewModel.otherUser!.lastSeen?.formatDateDifference}'
                        : '',
            textStyle: context.theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
