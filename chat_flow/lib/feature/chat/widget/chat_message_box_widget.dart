part of '../view/chat_view.dart';

class _ChatMessageBox extends StatelessWidget {
  const _ChatMessageBox({
    required this.index,
    required this.message,
  });

  final MessageModel message;
  final int index;
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + (index * 50)),
      curve: Curves.easeOutQuad,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(message.isMe ? (1 - value) * 100 : (value - 1) * 100, 0),
          child: Opacity(
            opacity: value,
            child: Align(
              alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: message.isMe ? Theme.of(context).primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        color: message.isMe ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.timestamp.toIso8601String().formatDateDifference,
                      style: TextStyle(
                        fontSize: 12,
                        color: message.isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
