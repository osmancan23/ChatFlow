import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._chatService) : super(ChatInitial()) {
    on<CreateChat>((event, emit) async {
      emit(ChatCreating());
      try {
        final chat = await _chatService.createChat(event.participantIds);
        emit(ChatCreated(chat));
      } catch (e) {
        log('Error: $e');
        emit(ChatError(e.toString()));
      }
    });

    on<UpdateChatTypingStatus>((event, emit) async {
      emit(ChatTypingStatusUpdating());
      try {
        await _chatService.updateChatTypingStatus(chatId: event.chatId, isTyping: event.isTyping);
        emit(UpdatedChatTypingStatus());
      } catch (e) {
        emit(ChatTypingStatusError(e.toString()));
      }
    });

    on<SendMessage>((event, emit) async {
      emit(ChatMessageSending());
      try {
        await _chatService.sendMessage(event.chatId, event.message);
        emit(ChatMessageSent());
      } catch (e) {
        emit(ChatMessageError(e.toString()));
      }
    });

    on<MarkMessageAsRead>((event, emit) async {
      emit(ChatMessageMarkingAsRead());
      try {
        await _chatService.markMessageAsRead(event.chatId);
        emit(ChatMessageMarkedAsRead());
      } catch (e) {
        emit(ChatMessageMarkAsReadError(e.toString()));
      }
    });
  }
  final IChatService _chatService;
}
