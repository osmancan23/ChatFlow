import 'package:bloc_test/bloc_test.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

@immutable
// ignore: must_be_immutable
class MockAuthService extends Mock implements IAuthService {}

class MockUser extends Mock implements User {
  @override
  String get uid => '1';
}

void main() {
  late AuthBloc authBloc;
  late MockAuthService mockAuthService;
  late MockUser mockUser;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUser = MockUser();
    authBloc = AuthBloc(mockAuthService);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Tests', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login is successful',
      build: () {
        when(
          mockAuthService.login(
            email: 'test@example.com',
            password: 'password123',
          ),
        ).thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@example.com',
          password: 'password123',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthFailure] when login fails',
      build: () {
        when(
          mockAuthService.login(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
        ).thenThrow(FirebaseAuthException(code: 'wrong-password'));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(
          email: 'test@example.com',
          password: 'wrongpassword',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        isA<AuthFailure>(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when registration is successful',
      build: () {
        when(
          mockAuthService.register(
            email: 'new@example.com',
            password: 'newpassword123',
            fullName: 'John Doe',
          ),
        ).thenAnswer((_) async => mockUser);
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthRegisterRequested(
          email: 'new@example.com',
          password: 'newpassword123',
          fullName: 'John Doe',
        ),
      ),
      expect: () => [
        const AuthLoading(),
        const AuthSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthInitial] when logout is successful',
      build: () {
        when(mockAuthService.logout()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [
        const AuthLoading(),
        const AuthInitial(),
      ],
    );
  });
}
