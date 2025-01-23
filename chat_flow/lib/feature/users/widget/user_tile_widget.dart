part of '../view/users_view.dart';

class _UserTileWidget extends StatefulWidget {
  const _UserTileWidget({
    required this.index,
    required this.user,
  });

  final int index;
  final UserModel user;

  @override
  State<_UserTileWidget> createState() => _UserTileWidgetState();
}

class _UserTileWidgetState extends State<_UserTileWidget> {
  late ChatBloc _chatBloc;
  late StreamSubscription<ChatState> _chatSubscription;

  @override
  void initState() {
    _chatBloc = context.read<ChatBloc>();

    _chatSubscription = _chatBloc.stream.listen((state) {
      log('State: $state');
      if (state is ChatCreated) {
        if (mounted) {
          locator<NavigationService>().navigateToPage(context: context, page: ChatView(chatId: state.chat.id));
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _chatSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (widget.index * 50)),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 50),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Hero(
            tag: 'user_${widget.index}',
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://static.vecteezy.com/system/resources/previews/004/899/680/non_2x/beautiful-blonde-woman-with-makeup-avatar-for-a-beauty-salon-illustration-in-the-cartoon-style-vector.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                border: Border.all(
                  color: Colors.deepPurple.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                widget.user.fullName,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              CustomText(
                widget.user.email,
                textStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          trailing: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                context.read<ChatBloc>().add(
                      CreateChat(
                        participantIds: [
                          FirebaseAuth.instance.currentUser!.uid,
                          widget.user.id,
                        ],
                      ),
                    );
              },
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.deepPurple,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
