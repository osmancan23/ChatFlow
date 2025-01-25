part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class CurrentUserProfileLoading extends UserState {}

final class CurrentUserProfileLoaded extends UserState {
  CurrentUserProfileLoaded(this.user);
  final UserModel user;
}

final class CurrentUserProfileError extends UserState {
  CurrentUserProfileError(this.message);
  final String message;
}

final class UserProfileUpdated extends UserState {}

final class UserProfileUpdateError extends UserState {
  UserProfileUpdateError(this.message);
  final String message;
}

final class UserProfileUpdateLoading extends UserState {}

final class UpdatingNotificationPreference extends UserState {}

final class NotificationPreferenceUpdated extends UserState {}

final class NotificationPreferenceUpdateError extends UserState {
  NotificationPreferenceUpdateError(this.message);
  final String message;
}
