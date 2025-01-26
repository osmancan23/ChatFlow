part of '../view/home_view.dart';

/// Chat liste öğesi widget'ı
class _ChatListTileWidget extends StatelessWidget {
  const _ChatListTileWidget({
    required this.chat,
    required this.index,
  });

  final ChatModel chat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Hero(
        tag: 'chat_$index',
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  chat.getOtherUser()?.profilePhoto != null ? NetworkImage(chat.getOtherUser()!.profilePhoto!) : null,
              child: chat.getOtherUser()?.profilePhoto == null ? Icon(Icons.person, size: 24.r) : null,
            ),
            title: CustomText(
              chat.getOtherUser()?.fullName ?? '',
              textStyle: context.theme.textTheme.titleMedium,
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: CustomText(
                    chat.lastMessage?.content ?? '',
                    textStyle: context.theme.textTheme.bodySmall,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  chat.updatedAt.formatDateDifference,
                  textStyle: context.theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
              ],
            ),
            onTap: () => context.read<HomeViewModel>().onChatTap(context, chat.id),
          ),
        ),
      ),
    );
  }
}
