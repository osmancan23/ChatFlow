import 'package:chat_flow/core/models/notification_model.dart';
import 'package:chat_flow/core/service/notification/notification_service.dart';
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
  late NotificationService notificationService;
  late MockFirebaseFirestore mockFirestore;
  late MockDocumentReference mockDocRef;
  late MockCollectionReference mockCollectionRef;

  setUp(() async {
    await TestHelper.setupFirebaseForTesting();
    mockFirestore = MockFirebaseFirestore();
    mockDocRef = MockDocumentReference();
    mockCollectionRef = MockCollectionReference();

    when(mockFirestore.collection(any)).thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
    notificationService = NotificationService(firestore: mockFirestore);
  });

  group('sendNotification tests', () {
    test('should send a notification successfully', () async {
      final notification = NotificationModel(
        id: 'notification1',
        userId: 'user1',
        title: 'Test Title',
        body: 'Test Body',
        timestamp: DateTime.now(),
        isRead: false,
        chatId: 'chat1',
      );

      when(mockFirestore.collection('in_app_notifications'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.add(any)).thenAnswer((_) async => mockDocRef);

      verify(mockCollectionRef.add(any)).called(1);
    });
  });

  group('markAsRead tests', () {
    test('should mark notification as read successfully', () async {
      when(mockFirestore.collection('in_app_notifications'))
          .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
      when(mockCollectionRef.doc('notification1')).thenReturn(mockDocRef);
      when(mockDocRef.update(any)).thenAnswer((_) async => {});

      await notificationService.markNotificationAsRead('notification1');

      verify(mockDocRef.update({'isRead': true})).called(1);
    });
  });
}
