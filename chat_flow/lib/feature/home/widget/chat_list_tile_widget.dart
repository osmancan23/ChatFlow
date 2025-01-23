part of '../view/home_view.dart';

class _ChatListTileWidget extends StatelessWidget {
  const _ChatListTileWidget({
    required this.index,
    required this.chat,
  });
  final ChatModel chat;
  final int index;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                'https://static.vecteezy.com/system/resources/previews/004/899/680/non_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg',
              ),
            ),
            title: CustomText(chat.participants.last.fullName),
            subtitle: CustomText(chat.lastMessage?.content),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomText(
                  chat.updatedAt.toIso8601String().formatDateDifference,
                  textStyle: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
              ],
            ),
            onTap: () {
              locator<NavigationService>().navigateToPage(
                context: context,
                page: ChatView(chatId: chat.id),
              );
            },
          ),
        ),
      ),
    );
  }
}
