import 'dart:developer';

import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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

class ChatService implements IChatService {
  ChatService({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;
  final FirebaseFirestore _firestore;

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

        // Katılımcıları al
        final participantDocs = await Future.wait(
          participantIds.map((id) => _firestore.collection('users').doc(id).get()),
        );
        final participants = participantDocs
            .where((doc) => doc.exists)
            .map(
              (doc) => UserModel.fromMap({
                'id': doc.id,
                ...doc.data()!,
              }),
            )
            .toList();

        // Son mesajı al
        MessageModel? lastMessage;
        if (lastMessageId != null) {
          final messageDoc =
              await _firestore.collection('chats').doc(doc.id).collection('messages').doc(lastMessageId).get();
          if (messageDoc.exists) {
            lastMessage = MessageModel.fromFirestore(messageDoc);
          }
        }

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

  @override
  Future<ChatModel> createChat(List<String> participantIds) async {
    // Check if a chat already exists with the same participants
    final existingChats =
        await _firestore.collection('chats').where('participantIds', arrayContainsAny: participantIds).get();

    for (final chat in existingChats.docs) {
      final chatParticipantIds = List<String>.from(chat['participantIds'] as List);
      if (chatParticipantIds.length == participantIds.length &&
          chatParticipantIds.every((id) => participantIds.contains(id))) {
        // Chat already exists with the same participants
        return ChatModel.fromFirestore(chat, participants: []);
      }
    }

    // Create a new chat if no existing chat is found
    final chatDoc = await _firestore.collection('chats').add({
      'participantIds': participantIds,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'typing': Map,
      'lastSeen': Map,
    });

    final participantDocs = await Future.wait(
      participantIds.map((id) => _firestore.collection('users').doc(id).get()),
    );
    final participants = participantDocs
        .where((doc) => doc.exists)
        .map(
          (doc) => UserModel.fromMap({
            'id': doc.id,
            ...doc.data()!,
          }),
        )
        .toList();

    return ChatModel.fromFirestore(
      await chatDoc.get(),
      participants: participants,
    );
  }

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

  @override
  Future<MessageModel> sendMessage(
    String chatId,
    String content,
  ) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final messageDoc = await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': userId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    // Sohbeti güncelle
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessageId': messageDoc.id,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    final messageSnapshot = await messageDoc.get();
    return MessageModel.fromFirestore(messageSnapshot);
  }

  @override
  Future<void> markMessageAsRead(String chatId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
      // Chat belgesini alarak lastMessageId'yi alıyoruz
      final chatDoc = await _firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {
        log('data var');
        // Chat belgesinden lastMessageId'yi alıyoruz
        final lastMessageId = chatDoc.data()?['lastMessageId'] as String;
        log('lastMessageId: $lastMessageId');
        if (lastMessageId.isNotEmpty) {
          // Mesajı almak için lastMessageId'yi kullanıyoruz
          final messageDoc =
              await _firestore.collection('chats').doc(chatId).collection('messages').doc(lastMessageId).get();

          if (messageDoc.exists) {
            // Mesajın senderId'si ile currentUserId'yi karşılaştırıyoruz
            final senderId = messageDoc.data()?['senderId'] as String;

            if (senderId != currentUserId) {
              // Eğer senderId farklıysa isRead alanını true yapıyoruz
              await _firestore.collection('chats').doc(chatId).collection('messages').doc(lastMessageId).update({
                'isRead': true,
              });
            }
          } else {}
        } else {}
      } else {}
    } catch (e) {
      // Hata durumunda hata mesajını yazdırıyoruz
      print('Son mesajı okundu olarak işaretlerken hata oluştu: $e');
      throw Exception('Son mesajı okundu olarak işaretlemek başarısız oldu');
    }
  }

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

  @override
  Stream<bool> listenToOtherUserTypingStatus(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return _firestore.collection('chats').doc(chatId).snapshots().map((snapshot) {
      // Eğer doküman yoksa false döner
      if (!snapshot.exists) return false;

      // participantIds dizisini al
      final participantIds = snapshot.data()?['participantIds'] as List?;

      // Kendiniz haricindeki kullanıcıyı bulun
      final otherUserId = participantIds
          ?.firstWhere(
            (id) => id != currentUserId,
            orElse: () => '', // Eğer başka kullanıcı yoksa boş döner
          )
          .toString();

      if (otherUserId?.isEmpty ?? false) return false;

      // typing alanını al
      final typingMap = snapshot.data()?['typing'] as Map;

      // Diğer kullanıcının typing durumunu döndür
      return typingMap[otherUserId] as bool? ?? false;
    });
  }

  @override
  Stream<UserModel?> getChatOtherUser(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Sohbet belgesini dinle
    return _firestore.collection('chats').doc(chatId).snapshots().asyncExpand((chatSnapshot) {
      if (!chatSnapshot.exists) {
        // Eğer chat belgesi yoksa boş bir stream döndür
        return Stream.value(null);
      }

      // participantIds listesini güvenli bir şekilde kontrol et ve diğer kullanıcıyı bul
      final rawParticipantIds = chatSnapshot.data()?['participantIds'];
      final participantIds =
          rawParticipantIds is List ? rawParticipantIds.map((id) => id.toString()).toList() : <String>[];

      if (participantIds.isEmpty) {
        return Stream.value(null);
      }

      // Diğer kullanıcının ID'sini al
      final otherUserId = participantIds.firstWhere(
        (id) => id != currentUserId,
        orElse: () => '', // Eğer başka kullanıcı yoksa boş döner
      );

      if (otherUserId.isEmpty) {
        return Stream.value(null);
      }

      // Kullanıcının `users` koleksiyonundaki belgesini dinle
      return _firestore.collection('users').doc(otherUserId).snapshots().map((userSnapshot) {
        if (!userSnapshot.exists) return null;

        // Kullanıcıyı `UserModel` olarak döndür
        return UserModel.fromMap(userSnapshot.data()!);
      });
    });
  }

  @override
  Stream<bool> getLastMessageReadStatus(String chatId) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return _firestore
        .collection('chats')
        .doc(chatId)
        .snapshots() // Chat dokümanındaki değişiklikleri dinliyoruz
        .asyncMap((chatDoc) async {
      if (chatDoc.exists) {
        final lastMessageId = chatDoc.data()?['lastMessageId'] as String;

        if (lastMessageId.isNotEmpty) {
          // Son mesajın okundu durumunu almak için lastMessageId ile mesajı alıyoruz
          final messageDoc =
              await _firestore.collection('chats').doc(chatId).collection('messages').doc(lastMessageId).get();

          if (messageDoc.exists) {
            final senderId = messageDoc.data()?['senderId'] as String;

            // Eğer mesajı gönderen kişi, şu anki kullanıcıysa okundu durumunu değiştirmiyoruz
            if (senderId == currentUserId) {
              // Eğer mesajı gönderen kullanıcı farklıysa, isRead'i kontrol ediyoruz
              return messageDoc.data()?['isRead'] as bool;
            }
          }
        }
      }
      return false;
    });
  }
}
