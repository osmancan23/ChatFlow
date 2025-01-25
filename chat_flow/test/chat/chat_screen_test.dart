import 'package:chat_flow/core/bloc/chat/chat_bloc.dart';
import 'package:chat_flow/core/components/indicator/typing_indicator.dart';

import 'package:chat_flow/core/models/message_model.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/chat_service.dart';
import 'package:chat_flow/feature/chat/view/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockChatBloc extends Mock implements ChatBloc {}

@immutable
// ignore: must_be_immutable
final class MockChatService extends Mock implements IChatService {}

void main() {
  late MockChatBloc mockChatBloc;
  late MockChatService mockChatService;
  const testChatId = 'test-chat-id';

  setUp(() {
    mockChatBloc = MockChatBloc();
    mockChatService = MockChatService();
  });

  Future<void> pumpChatView(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<ChatBloc>.value(value: mockChatBloc),
          ],
          child: const ChatView(chatId: testChatId),
        ),
      ),
    );
  }

  testWidgets('ChatView shows loading indicator when messages are loading', (WidgetTester tester) async {
    // Stream için mock veri
    when(mockChatService.getChatMessages(testChatId)).thenAnswer((_) => Stream.value([]));

    // Diğer kullanıcı bilgisi için mock veri
    when(mockChatService.getChatOtherUser(testChatId)).thenAnswer(
      (_) => Stream.value(
        UserModel(
          id: 'other-user-id',
          fullName: 'Test User',
          email: 'test@example.com',
        ),
      ),
    );

    await pumpChatView(tester);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('ChatView shows messages when loaded', (WidgetTester tester) async {
    final messages = [
      MessageModel(
        id: '1',
        senderId: 'user1',
        content: 'Hello',
        timestamp: DateTime.now(),
      ),
    ];

    when(mockChatService.getChatMessages(testChatId)).thenAnswer((_) => Stream.value(messages));

    when(mockChatService.getChatOtherUser(testChatId)).thenAnswer(
      (_) => Stream.value(
        UserModel(
          id: 'other-user-id',
          fullName: 'Test User',
          email: 'test@example.com',
        ),
      ),
    );

    await pumpChatView(tester);
    await tester.pump();

    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('ChatView shows typing indicator when other user is typing', (WidgetTester tester) async {
    when(mockChatService.getChatMessages(testChatId)).thenAnswer((_) => Stream.value([]));

    when(mockChatService.getChatOtherUser(testChatId)).thenAnswer(
      (_) => Stream.value(
        UserModel(
          id: 'other-user-id',
          fullName: 'Test User',
          email: 'test@example.com',
        ),
      ),
    );

    when(mockChatService.listenToOtherUserTypingStatus(testChatId)).thenAnswer((_) => Stream.value(true));

    await pumpChatView(tester);
    await tester.pump();

    expect(find.byType(TypingIndicator), findsOneWidget);
  });

  testWidgets('ChatView sends message when input submitted', (WidgetTester tester) async {
    when(mockChatService.getChatMessages(testChatId)).thenAnswer((_) => Stream.value([]));

    when(mockChatService.getChatOtherUser(testChatId)).thenAnswer(
      (_) => Stream.value(
        UserModel(
          id: 'other-user-id',
          fullName: 'Test User',
          email: 'test@example.com',
        ),
      ),
    );

    when(mockChatService.sendMessage(testChatId, 'New message')).thenAnswer(
      (_) async => MessageModel(
        id: '1',
        senderId: 'user1',
        content: 'New message',
        timestamp: DateTime.now(),
      ),
    );

    await pumpChatView(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'New message');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    verify(mockChatService.sendMessage(testChatId, 'New message')).called(1);
  });

  testWidgets('ChatView shows error when message sending fails', (WidgetTester tester) async {
    when(mockChatService.getChatMessages(testChatId)).thenAnswer((_) => Stream.value([]));

    when(mockChatService.getChatOtherUser(testChatId)).thenAnswer(
      (_) => Stream.value(
        UserModel(
          id: 'other-user-id',
          fullName: 'Test User',
          email: 'test@example.com',
        ),
      ),
    );

    when(mockChatService.sendMessage(testChatId, 'New message')).thenThrow(Exception('Failed to send message'));

    await pumpChatView(tester);
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'New message');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.text('Failed to send message'), findsOneWidget);
  });
}
