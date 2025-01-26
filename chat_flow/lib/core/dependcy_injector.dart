import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/core/bloc/chat/chat_bloc.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/service/chat/chat_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class DependcyInjector {
  DependcyInjector._init() {
    _authBloc = AuthBloc();
    _chatBloc = ChatBloc(locator<ChatService>());
  }
  static DependcyInjector? _instance;

  // ignore: prefer_constructors_over_static_methods
  static DependcyInjector get instance {
    _instance ??= DependcyInjector._init();
    return _instance!;
  }

  late final AuthBloc _authBloc;
  late final ChatBloc _chatBloc;

  // ignore: strict_raw_type
  List<BlocProvider<Bloc>> get globalBlocProviders => [
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
        BlocProvider<ChatBloc>(create: (context) => _chatBloc),
      ];
}
