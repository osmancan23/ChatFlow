import 'dart:async';
import 'dart:developer';

import 'package:chat_flow/core/constants/enums/lottie_enums.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/navigation/navigation_service.dart';
import 'package:chat_flow/feature/auth/bloc/auth_bloc.dart';
import 'package:chat_flow/feature/auth/login/view/login_view.dart';
import 'package:chat_flow/feature/main/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
part '../mixin/splash_view_mixin.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin, _SplashViewMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animasyonu
            Lottie.asset(
              LottieEnums.login.path,
              width: 200.w,
              height: 200.h,
            ),
            SizedBox(height: 20.h),
            // Uygulama adı
            Text(
              'Chat Flow',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
