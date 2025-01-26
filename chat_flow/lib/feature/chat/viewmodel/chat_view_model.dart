import 'package:chat_flow/core/base/view_model/base_view_model.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Chat ekranı için ViewModel sınıfı
/// Bu sınıf, chat işlemleri için gerekli olan business logic'i içerir
class ChatViewModel extends BaseViewModel {
  /// Chat servisi
  final _chatService = locator<ChatService>();

  /// Mesaj controller'ı
  final messageController = TextEditingController();

  /// Scroll controller'ı
  final scrollController = ScrollController();

  /// Chat ID
  String? _chatId;
  String? get chatId => _chatId;

  /// Mevcut kullanıcı ID'si
  String get currentUserId => FirebaseAuth.instance.currentUser!.uid;

  /// Diğer kullanıcı
  UserModel? _otherUser;
  UserModel? get otherUser => _otherUser;

  /// Mesajlar listesi
  List<MessageModel> _messages = [];
  List<MessageModel> get messages => _messages;

  /// Diğer kullanıcının yazma durumu
  bool _otherUserTyping = false;
  bool get otherUserTyping => _otherUserTyping;

  /// Son mesajın okunma durumu
  bool _isLastMessageRead = false;
  bool get isLastMessageRead => _isLastMessageRead;

  /// Chat'i başlat
  void initChat(String chatId) {
    _chatId = chatId;
    _listenToMessages();
    _listenToOtherUser();
    _listenToTypingStatus();
    _listenToReadStatus();
    notifyListeners();
  }

  /// Mesajları dinle
  void _listenToMessages() {
    if (_chatId == null) return;

    _chatService.getChatMessages(_chatId!).listen((messages) {
      _messages = messages;
      notifyListeners();
      _scrollToBottom();
    });
  }

  /// Diğer kullanıcıyı dinle
  void _listenToOtherUser() {
    if (_chatId == null) return;

    _chatService.getChatOtherUser(_chatId!).listen((user) {
      _otherUser = user;
      notifyListeners();
    });
  }

  /// Yazma durumunu dinle
  void _listenToTypingStatus() {
    if (_chatId == null) return;

    _chatService.listenToOtherUserTypingStatus(_chatId!).listen((isTyping) {
      _otherUserTyping = isTyping;
      notifyListeners();
    });
  }

  /// Okunma durumunu dinle
  void _listenToReadStatus() {
    if (_chatId == null) return;

    _chatService.getLastMessageReadStatus(_chatId!).listen((isRead) {
      _isLastMessageRead = isRead;
      notifyListeners();
    });
  }

  /// Mesaj gönder
  void sendMessage(BuildContext context) {
    if (_chatId == null || messageController.text.trim().isEmpty) return;

    _chatService.sendMessage(
      chatId: _chatId!,
      content: messageController.text.trim(),
    );

    messageController.clear();
    updateTypingStatus(isTyping: false);
  }

  /// Yazma durumunu güncelle
  void updateTypingStatus({required bool isTyping}) {
    if (_chatId == null) return;

    _chatService.updateChatTypingStatus(
      chatId: _chatId!,
      isTyping: isTyping,
    );
  }

  /// Mesajları okundu olarak işaretle
  void markMessagesAsRead() {
    if (_chatId == null) return;

    _chatService.markMessageAsRead(_chatId!);
  }

  /// Sohbetin en altına kaydır
  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
