part of '../view/chat_view.dart';

class _ChatAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const _ChatAppbarWidget({
    required this.widget,
    required bool isTyping,
    super.key,
  }) : _isTyping = isTyping;

  final ChatView widget;
  final bool _isTyping;

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Kullanıcı Adı',
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      _isTyping ? 'Yazıyor...' : 'Çevrimiçi',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _isTyping ? Colors.green : null,
                          ),
                      key: ValueKey<bool>(_isTyping),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
