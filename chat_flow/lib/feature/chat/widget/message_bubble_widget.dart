part of '../view/chat_view.dart';

/// Mesaj balonu widget'ı
class _MessageBubbleWidget extends StatelessWidget {
  const _MessageBubbleWidget({
    required this.message,
    required this.isMe,
    required this.showStatus,
    required this.isRead,
  });

  final MessageModel message;
  final bool isMe;
  final bool showStatus;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 8.h,
          left: isMe ? 50.w : 0,
          right: isMe ? 0 : 50.w,
        ),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isMe ? context.theme.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
            bottomLeft: Radius.circular(isMe ? 12.r : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              message.content,
              textStyle: context.theme.textTheme.bodyMedium?.copyWith(
                color: isMe ? Colors.white : Colors.black87,
              ),
            ),
            if (showStatus) ...[
              5.h.ph,
              CustomText(
                isRead ? _ChatViewStrings.readText : _ChatViewStrings.sentText,
                textStyle: context.theme.textTheme.bodySmall?.copyWith(
                  color: isMe ? Colors.white70 : Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 