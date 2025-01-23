part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class FetchCurrentUserProfile extends UserEvent {}

final class UpdateUserProfile extends UserEvent {
  UpdateUserProfile(this.user, this.image);
  final UserModel user;
  final File? image;
}
