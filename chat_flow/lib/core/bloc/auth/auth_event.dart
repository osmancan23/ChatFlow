part of 'auth_bloc.dart';

/// Auth event'leri için abstract sınıf
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Login event'i
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Register event'i
class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });

  final String email;
  final String password;
  final String fullName;

  @override
  List<Object?> get props => [email, password, fullName];
}

/// Logout event'i
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Auth check event'i
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Online status event'i
class AuthOnlineStatusChanged extends AuthEvent {
  const AuthOnlineStatusChanged({required this.isOnline});

  final bool isOnline;

  @override
  List<Object?> get props => [isOnline];
}

/// Last seen event'i
class AuthLastSeenUpdated extends AuthEvent {
  const AuthLastSeenUpdated();
}
