import 'package:chat_flow/core/dependcy_injector.dart';
import 'package:chat_flow/core/init/app/app_init.dart';

import 'package:chat_flow/feature/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await ApplicationInit.instance?.appInit();
  runApp(
    MultiBlocProvider(
      providers: DependcyInjector.instance.globalBlocProviders,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Chat Flow',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SplashView(),
        );
      },
    );
  }
}
