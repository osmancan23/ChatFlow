import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/core/init/notification/notification_manager.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:chat_flow/core/service/chat/chat_service.dart';
import 'package:chat_flow/core/service/firebase/firebase_storage_service.dart';
import 'package:chat_flow/core/service/user/user_service.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void setupLocator() {
  /// MARK: Constants
  ///
  locator
    ..registerLazySingleton(AuthService.new)
    ..registerLazySingleton(UserService.new)
    ..registerLazySingleton(NavigationService.new)
    ..registerLazySingleton(ChatService.new)
    ..registerLazySingleton(NotificationManager.new)
    ..registerLazySingleton(FirebaseStorageService.new);
}
