part of '../view/splash_view.dart';

mixin _SplashViewMixin on State<SplashView> {
  late StreamSubscription<AuthState> _authSubscription;

  @override
  void initState() {
    super.initState();

    // 3 saniye sonra auth check yapılacak
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<AuthBloc>().add(const AuthCheckRequested());
      }
    });

    _authSubscription = context.read<AuthBloc>().stream.listen((state) {
      log(state.toString());
      if (mounted) {
        if (state is AuthSuccess) {
          NavigationService.instance.navigateToPageClear(context: context, page: const MainView());
        } else if (state is AuthFailure || state is AuthInitial) {
          NavigationService.instance.navigateToPageClear(context: context, page: const LoginView());
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}
