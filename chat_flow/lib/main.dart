import 'package:chat_flow/core/dependcy_injector.dart';
import 'package:chat_flow/core/init/app/app_init.dart';
import 'package:chat_flow/feature/splash/view/splash_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Background message handler'ı global olarak tanımla
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Background handler'ı ayarla
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
        return const MaterialApp(
          title: 'Chat Flow',
          debugShowCheckedModeBanner: false,
          home: SplashView(),
        );
      },
    );
  }
}
