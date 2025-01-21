import 'package:chat_flow/feature/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class DependcyInjector {
  DependcyInjector._init() {
    _authBloc = AuthBloc();
  }
  static DependcyInjector? _instance;

  static DependcyInjector get instance {
    _instance ??= DependcyInjector._init();
    return _instance!;
  }

  late final AuthBloc _authBloc;

  // ignore: strict_raw_type
  List<BlocProvider<Bloc>> get globalBlocProviders => [
        BlocProvider<AuthBloc>(create: (context) => _authBloc),
      ];
}
