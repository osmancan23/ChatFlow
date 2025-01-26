import 'package:chat_flow/core/bloc/auth/auth_bloc.dart';
import 'package:chat_flow/core/constants/enums/lottie_enums.dart';
import 'package:chat_flow/feature/splash/viewmodel/splash_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

/// Splash ekranı
/// Uygulama açılışında gösterilen ekran
class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, _) {
          viewModel.initSplash(context);
          return BlocListener<AuthBloc, AuthState>(
            listener: viewModel.onAuthStateChanged,
            child: Scaffold(
              body: _buildBody(),
            ),
          );
        },
      ),
    );
  }

  /// Body widget'ı
  Widget _buildBody() {
    return Center(
      child: Lottie.asset(
        LottieEnums.login.path,
        width: 300.h,
      ),
    );
  }
}
