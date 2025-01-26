import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../test_helper.dart';
import 'auth_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FirebaseAuth>(),
  MockSpec<FirebaseFirestore>(),
  MockSpec<DocumentReference>(),
  MockSpec<CollectionReference>(),
  MockSpec<DocumentSnapshot>(),
  MockSpec<UserCredential>(),
  MockSpec<User>(),
])
void main() {
  late AuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockDocumentReference mockDocRef;
  late MockCollectionReference mockCollectionRef;
  late MockDocumentSnapshot mockDocSnapshot;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() async {
    await TestHelper.setupFirebaseForTesting();
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockDocRef = MockDocumentReference();
    mockCollectionRef = MockCollectionReference();
    mockDocSnapshot = MockDocumentSnapshot();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();

    when(mockFirebaseFirestore.collection(any))
        .thenReturn(mockCollectionRef as CollectionReference<Map<String, dynamic>>);
    when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockUser.uid).thenReturn('test-uid');
    when(mockUser.email).thenReturn('test@test.com');

    authService = AuthService();
  });

  group('signIn tests', () {
    test('should sign in successfully', () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockDocRef.get()).thenAnswer((_) async => mockDocSnapshot);
      when(mockDocSnapshot.data()).thenReturn({
        'id': 'test-uid',
        'email': 'test@test.com',
        'fullName': 'Test User',
        'profilePhoto': 'test-photo',
        'platform': 'ios',
        'isOnline': true,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      final result = await authService.login(email: 'osmancan@gmail.com', password: '123456');

      expect(result, isA<UserModel>());
      expect(result?.uid, 'test-uid');
      expect(result?.email, 'test@test.com');
    });
  });

  group('signUp tests', () {
    test('should sign up successfully', () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockDocRef.set(any)).thenAnswer((_) async => {});

      final result = await authService.register(
        email: 'test@test.com',
        password: 'password',
        fullName: 'Test User',
      );

      expect(result, isA<UserModel>());
      expect(result?.uid, 'test-uid');
      expect(result?.email, 'test@test.com');
      expect(result?.displayName, 'Test User');
    });
  });

  group('signOut tests', () {
    test('should sign out successfully', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      await authService.logout();

      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
