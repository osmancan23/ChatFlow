import 'dart:developer';

import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/notification/notification_manager.dart';
import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Chat servisi için abstract sınıf
/// Bu sınıf, chat işlemleri için gerekli olan metodları tanımlar
@immutable
abstract class IChatService {
  // Sohbet işlemleri
  Stream<List<ChatModel>> getUserChats();
  Future<ChatModel> createChat(List<String> participantIds);
  Future<void> updateChatTypingStatus({required String chatId, required bool isTyping});

  // Mesaj işlemleri
  Stream<List<MessageModel>> getChatMessages(String chatId);
  Future<MessageModel> sendMessage(String chatId, String content);
  Future<void> markMessageAsRead(String chatId);

  // Kullanıcı işlemleri
  Stream<List<UserModel>> getAvailableUsers();
  Stream<bool> listenToOtherUserTypingStatus(String chatId);
  Stream<UserModel?> getChatOtherUser(String chatId);
  Stream<bool> getLastMessageReadStatus(String chatId);
}

/// Chat servisi implementasyonu
/// Firebase Firestore kullanarak chat işlemlerini gerçekleştirir
class ChatService implements IChatService {
  ChatService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

  /// Kullanıcının tüm sohbetlerini stream olarak döndürür
  /// Her bir sohbet için katılımcıları ve son mesajı da getirir
  @override
  Stream<List<ChatModel>> getUserChats() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore
        .collection('chats')
        .where('participantIds', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = <ChatModel>[];

      for (final doc in snapshot.docs) {
        final participantIds = List<String>.from(doc.data()['participantIds'] as List);
        final lastMessageId = doc.data()['lastMessageId'] as String?;

        // Katılımcıları getir
        final participants = await _getParticipants(participantIds);

        // Son mesajı getir
        final lastMessage = await _getLastMessage(doc.id, lastMessageId);

        chats.add(
          ChatModel.fromFirestore(
            doc,
            participants: participants,
            lastMessage: lastMessage,
          ),
        );
      }

      return chats;
    });
  }

  /// Verilen katılımcı ID'leri ile yeni bir sohbet oluşturur
  /// Eğer aynı katılımcılarla bir sohbet zaten varsa, onu döndürür
  @override
  Future<ChatModel> createChat(List<String> participantIds) async {
    // Mevcut sohbeti kontrol et
    final existingChat = await _findExistingChat(participantIds);
    if (existingChat != null) return existingChat;

    // Yeni sohbet oluştur
    final chatDoc = await _firestore.collection('chats').add({
      'participantIds': participantIds,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'typing': {},
      'lastSeen': {},
    });

    final participants = await _getParticipants(participantIds);

    return ChatModel.fromFirestore(
      await chatDoc.get(),
      participants: participants,
    );
  }

  /// Sohbetteki yazma durumunu günceller
  @override
  Future<void> updateChatTypingStatus({
    required String chatId,
    required bool isTyping,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('chats').doc(chatId).update({
      'typing.$userId': isTyping,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Belirli bir sohbetin mesajlarını stream olarak döndürür
  @override
  Stream<List<MessageModel>> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(MessageModel.fromFirestore).toList(),
        );
  }

  /// Yeni bir mesaj gönderir ve bildirim oluşturur
  @override
  Future<MessageModel> sendMessage(String chatId, String content) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Mesajı oluştur
    final messageDoc = await _createMessage(chatId, userId, content);

    // Sohbeti güncelle
    await _updateChatWithLastMessage(chatId, messageDoc.id);

    // Bildirim gönder
    await _sendNotification(chatId, userId, content);

    final messageSnapshot = await messageDoc.get();
    return MessageModel.fromFirestore(messageSnapshot);
  }

  /// Son mesajı okundu olarak işaretler
  @override
  Future<void> markMessageAsRead(String chatId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) return;

      final lastMessageId = chatDoc.data()?['lastMessageId'] as String?;
      if (lastMessageId?.isEmpty ?? true) return;

      final messageDoc = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(lastMessageId)
          .get();

      if (!messageDoc.exists) return;

      final senderId = messageDoc.data()?['senderId'] as String?;
      if (senderId == currentUserId) return;

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(lastMessageId)
          .update({'isRead': true});
    } catch (e) {
      log('Mesaj okundu işaretlenirken hata: $e');
      throw Exception('Mesaj okundu işaretlenemedi');
    }
  }

  /// Mevcut kullanıcı dışındaki tüm kullanıcıları stream olarak döndürür
  @override
  Stream<List<UserModel>> getAvailableUsers() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore.collection('users').where('id', isNotEqualTo: userId).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => UserModel.fromMap({
                  'id': doc.id,
                  ...doc.data(),
                }),
              )
              .toList(),
        );
  }

  /// Diğer kullanıcının yazma durumunu stream olarak döndürür
  @override
  Stream<bool> listenToOtherUserTypingStatus(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore.collection('chats').doc(chatId).snapshots().map((snapshot) {
      if (!snapshot.exists) return false;

      final participantIds = List<String>.from(snapshot.data()?['participantIds'] as List? ?? []);
      final otherUserId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) return false;

      final typingMap = snapshot.data()?['typing'] as Map? ?? {};
      return typingMap[otherUserId] as bool? ?? false;
    });
  }

  /// Sohbetteki diğer kullanıcının bilgilerini stream olarak döndürür
  @override
  Stream<UserModel?> getChatOtherUser(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore.collection('chats').doc(chatId).snapshots().asyncExpand((chatSnapshot) {
      if (!chatSnapshot.exists) return Stream.value(null);

      final participantIds = List<String>.from(chatSnapshot.data()?['participantIds'] as List? ?? []);
      final otherUserId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '',
      );

      if (otherUserId.isEmpty) return Stream.value(null);

      return _firestore.collection('users').doc(otherUserId).snapshots().map((userSnapshot) {
        if (!userSnapshot.exists) return null;
        return UserModel.fromMap(userSnapshot.data()!);
      });
    });
  }

  /// Son mesajın okunma durumunu stream olarak döndürür
  @override
  Stream<bool> getLastMessageReadStatus(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    
    return _firestore.collection('chats').doc(chatId).snapshots().asyncMap((chatDoc) async {
      if (!chatDoc.exists) return false;

      final lastMessageId = chatDoc.data()?['lastMessageId'] as String?;
      if (lastMessageId?.isEmpty ?? true) return false;

      final messageDoc = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(lastMessageId)
          .get();

      if (!messageDoc.exists) return false;

      final senderId = messageDoc.data()?['senderId'] as String?;
      if (senderId != currentUserId) return false;

      return messageDoc.data()?['isRead'] as bool? ?? false;
    });
  }

  // Private Helper Methods

  /// Katılımcıların bilgilerini getirir
  Future<List<UserModel>> _getParticipants(List<String> participantIds) async {
    final participantDocs = await Future.wait(
      participantIds.map((id) => _firestore.collection('users').doc(id).get()),
    );
    
    return participantDocs
        .where((doc) => doc.exists)
        .map(
          (doc) => UserModel.fromMap({
            'id': doc.id,
            ...doc.data()!,
          }),
        )
        .toList();
  }

  /// Son mesajı getirir
  Future<MessageModel?> _getLastMessage(String chatId, String? lastMessageId) async {
    if (lastMessageId == null) return null;

    final messageDoc = await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(lastMessageId)
        .get();

    return messageDoc.exists ? MessageModel.fromFirestore(messageDoc) : null;
  }

  /// Mevcut bir sohbeti bulur
  Future<ChatModel?> _findExistingChat(List<String> participantIds) async {
    final existingChats = await _firestore
        .collection('chats')
        .where('participantIds', arrayContainsAny: participantIds)
        .get();

    for (final chat in existingChats.docs) {
      final chatParticipantIds = List<String>.from(chat['participantIds'] as List);
      if (chatParticipantIds.length == participantIds.length &&
          chatParticipantIds.every((id) => participantIds.contains(id))) {
        return ChatModel.fromFirestore(chat, participants: []);
      }
    }
    return null;
  }

  /// Yeni bir mesaj oluşturur
  Future<DocumentReference> _createMessage(String chatId, String userId, String content) async {
    return _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': userId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  /// Sohbeti son mesaj ile günceller
  Future<void> _updateChatWithLastMessage(String chatId, String messageId) async {
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessageId': messageId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Bildirim gönderir
  Future<void> _sendNotification(String chatId, String userId, String content) async {
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    final participantIds = List<String>.from(chatDoc.data()?['participantIds'] as List);
    final otherUserId = participantIds.firstWhere((id) => id != userId);

    final currentUserDoc = await _firestore.collection('users').doc(userId).get();
    final currentUser = UserModel.fromFirestore(currentUserDoc);

    await locator<NotificationManager>().sendMessage(otherUserId, content, currentUser.fullName);
  }
}
