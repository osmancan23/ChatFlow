part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

// CREATE CHAT

final class ChatCreating extends ChatState {}

final class ChatCreated extends ChatState {
  ChatCreated(this.chat);
  final ChatModel chat;
}

final class ChatError extends ChatState {
  ChatError(this.message);
  final String message;
}

// UPDATE CHAT TYPING STATUS

final class ChatTypingStatusUpdating extends ChatState {}

final class UpdatedChatTypingStatus extends ChatState {}

final class ChatTypingStatusError extends ChatState {
  ChatTypingStatusError(this.message);
  final String message;
}

// SEND MESSAGE

final class ChatMessageSending extends ChatState {}

final class ChatMessageSent extends ChatState {}

final class ChatMessageError extends ChatState {
  ChatMessageError(this.message);
  final String message;
}

// MARK MESSAGE AS READ

final class ChatMessageMarkingAsRead extends ChatState {}

final class ChatMessageMarkedAsRead extends ChatState {}

final class ChatMessageMarkAsReadError extends ChatState {
  ChatMessageMarkAsReadError(this.message);
  final String message;
}
