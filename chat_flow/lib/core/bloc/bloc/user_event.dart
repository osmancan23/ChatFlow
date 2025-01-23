part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class FetchCurrentUserProfile extends UserEvent {}

final class UpdateUserProfile extends UserEvent {
  UpdateUserProfile(this.user);
  final UserModel user;
}
