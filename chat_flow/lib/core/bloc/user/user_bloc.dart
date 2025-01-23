import 'package:bloc/bloc.dart';
import 'package:chat_flow/core/models/user_model.dart';
import 'package:chat_flow/core/service/user_service.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(this._userService) : super(UserInitial()) {
    on<FetchCurrentUserProfile>((event, emit) async {
      emit(CurrentUserProfileLoading());
      final user = await _userService.getCurrentUserProfile();
      if (user != null) {
        emit(CurrentUserProfileLoaded(user));
      } else {
        emit(CurrentUserProfileError('Kullanıcı bulunamadı.'));
      }
    });

    on<UpdateUserProfile>((event, emit) async {
      emit(UserProfileUpdateLoading());
      try {
        await _userService.updateUserProfile(event.user);
        emit(UserProfileUpdated());
      } catch (e) {
        emit(UserProfileUpdateError('Kullanıcı güncellenirken hata oluştu.'));
      }
    });
  }
  final IUserService _userService;
}
