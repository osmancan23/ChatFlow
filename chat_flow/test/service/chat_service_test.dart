import 'package:chat_flow/core/models/chat_model.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_helper.dart';
import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseFirestore>(),
  MockSpec<DocumentReference>(),
  MockSpec<CollectionReference>(),
  MockSpec<DocumentSnapshot>(),
  MockSpec<QuerySnapshot>(),
  MockSpec<Query>(),
])
void main() {
  late ChatService chatService;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference mockDocRef;
  late MockCollectionReference mockCollectionRef;
  late MockDocumentSnapshot mockDocSnapshot;

  setUp(() async {
    await TestHelper.setupFirebaseForTesting();
    mockFirestore = MockFirebaseFirestore();
    mockDocRef = MockDocumentReference();
    mockCollectionRef = MockCollectionReference();
    mockDocSnapshot = MockDocumentSnapshot();

    when(mockFirestore.collection(any)).thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
    chatService = ChatService(firestore: mockFirestore);
  });

  group('createChat tests', () {
    test('should create a new chat successfully', () async {
      final user1 = UserModel(
        id: 'user1',
        email: 'user1@test.com',
        fullName: 'user1',
        platform: 'ios',
        isOnline: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        profilePhoto: 'photo1',
      );
      final user2 = UserModel(
        id: 'user2',
        email: 'user2@test.com',
        fullName: 'user2',
        platform: 'ios',
        isOnline: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        profilePhoto: 'photo2',
      );

      when(mockFirestore.collection('chats'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.add(any)).thenAnswer((_) async => mockDocRef);
      when(mockDocRef.collection('messages'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);

      final result = await chatService.createChat([user1.id, user2.id]);

      expect(result, isA<ChatModel>());
      verify(mockCollectionRef.add(any)).called(1);
    });
  });

  group('sendMessage tests', () {
    test('should send a message successfully', () async {
      const chatId = 'chat1';
      const content = 'Test message';

      when(mockFirestore.collection('chats'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.collection('messages'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.add(any)).thenAnswer((_) async => mockDocRef);

      await chatService.sendMessage(
        chatId: chatId,
        content: content,
      );

      verify(mockCollectionRef.add(any)).called(1);
    });
  });

  group('getChats tests', () {
    test('should get user chats successfully', () async {
      when(mockFirestore.collection('users'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.data()).thenReturn({
        'chats': ['chat1', 'chat2'],
      });

      final result = chatService.getUserChats();

      expect(result, isA<List<String>>());
      expect(result.length, 2);
    });
  });

  group('getChatStream tests', () {
    test('should get chat stream successfully', () async {
      when(mockFirestore.collection('chats'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
      when(mockDocRef.snapshots()).thenAnswer(
        (_) => Stream.value(mockDocSnapshot),
      );
      when(mockDocSnapshot.data()).thenReturn({
        'users': ['user1', 'user2'],
        'lastMessage': null,
        // ignore: inference_failure_on_collection_literal
        'lastSeen': {},
      });

      final stream = chatService.getChatMessages('chat1');

      expect(stream, isA<Stream<ChatModel>>());
    });
  });
}
