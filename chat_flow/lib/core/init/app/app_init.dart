import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/init/notification/notification_manager.dart';
import 'package:chat_flow/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ApplicationInit {
  ApplicationInit._init();
  static ApplicationInit? _instance;
  static ApplicationInit? get instance {
    // ignore: join_return_with_assignment
    _instance ??= ApplicationInit._init();
    return _instance;
  }

  late List<CameraDescription> cameras;

  Future<void> appInit() async {
    WidgetsFlutterBinding.ensureInitialized();

    HttpOverrides.global = MyHttpOverrides();

    cameras = await availableCameras();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(systemNavigationBarColor: Colors.black.withOpacity(0.002)),
    );

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    setupLocator();

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await locator<NotificationManager>().initFCM();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
