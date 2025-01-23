part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

// CREATE CHAT

final class CreateChat extends ChatEvent {
  CreateChat({required this.participantIds});
  final List<String> participantIds;
}

// UPDATE CHAT TYPING STATUS

final class UpdateChatTypingStatus extends ChatEvent {
  UpdateChatTypingStatus({required this.chatId, required this.isTyping});
  final String chatId;
  final bool isTyping;
}

// SEND MESSAGE

final class SendMessage extends ChatEvent {
  SendMessage({required this.chatId, required this.message});
  final String chatId;
  final String message;
}

// MARK MESSAGE AS READ

final class MarkMessageAsRead extends ChatEvent {
  MarkMessageAsRead({required this.chatId});
  final String chatId;
}
