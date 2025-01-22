import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IChatService {
  // Sohbet işlemleri
  Stream<List<ChatModel>> getUserChats();
  Future<ChatModel> createChat(List<String> participantIds);
  Future<void> deleteChat(String chatId);
  Future<void> updateChatTypingStatus(String chatId, bool isTyping);
  Future<void> updateChatLastSeen(String chatId);

  // Mesaj işlemleri
  Stream<List<MessageModel>> getChatMessages(String chatId);
  Future<MessageModel> sendMessage(String chatId, String content, {String? imageUrl});
  Future<void> deleteMessage(String chatId, String messageId);
  Future<void> markMessageAsRead(String chatId, String messageId);

  // Kullanıcı işlemleri
  Stream<List<UserModel>> getAvailableUsers();
  Future<List<UserModel>> searchUsers(String query);
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
    final chatDoc = await _firestore.collection('chats').add({
      'participantIds': participantIds,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'typing': {},
      'lastSeen': {},
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
  Future<void> deleteChat(String chatId) async {
    // Önce tüm mesajları sil
    final messages = await _firestore.collection('chats').doc(chatId).collection('messages').get();

    final batch = _firestore.batch();
    for (final message in messages.docs) {
      batch.delete(message.reference);
    }

    // Sonra sohbeti sil
    batch.delete(_firestore.collection('chats').doc(chatId));
    await batch.commit();
  }

  @override
  Future<void> updateChatTypingStatus(
    String chatId,
    bool isTyping,
  ) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('chats').doc(chatId).update({
      'typing.$userId': isTyping,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateChatLastSeen(String chatId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    await _firestore.collection('chats').doc(chatId).update({
      'lastSeen.$userId': FieldValue.serverTimestamp(),
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
    String content, {
    String? imageUrl,
  }) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final messageDoc = await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': userId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      if (imageUrl != null) 'imageUrl': imageUrl,
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
  Future<void> deleteMessage(String chatId, String messageId) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).delete();

    // Son mesaj silindiyse, bir önceki mesajı son mesaj olarak ayarla
    final chatDoc = await _firestore.collection('chats').doc(chatId).get();
    if (chatDoc.data()?['lastMessageId'] == messageId) {
      final lastMessage = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      await _firestore.collection('chats').doc(chatId).update({
        'lastMessageId': lastMessage.docs.isEmpty ? null : lastMessage.docs.first.id,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  @override
  Future<void> markMessageAsRead(String chatId, String messageId) async {
    await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).update({
      'isRead': true,
    });
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
  Future<List<UserModel>> searchUsers(String query) async {
    final queryLower = query.toLowerCase();
    final snapshot = await _firestore.collection('users').get();

    return snapshot.docs
        .map(
          (doc) => UserModel.fromMap({
            'id': doc.id,
            ...doc.data(),
          }),
        )
        .where(
          (user) =>
              user.fullName.toLowerCase().contains(queryLower) == true || user.email.toLowerCase().contains(queryLower),
        )
        .toList();
  }
}
