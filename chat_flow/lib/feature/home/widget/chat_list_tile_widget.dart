part of '../view/home_view.dart';

class _ChatListTileWidget extends StatelessWidget {
  const _ChatListTileWidget({
    required this.index,
  });
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
            title: Text('Kullanıcı ${index + 1}'),
            subtitle: const Text('Son mesaj...'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '12:30', // TODO: Replace with actual time
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '2', // TODO: Replace with actual unread count
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            onTap: () {
              NavigationService.instance.navigateToPage(
                context: context,
                page: ChatView(chatId: index),
              );
            },
          ),
        ),
      ),
    );
  }
}
