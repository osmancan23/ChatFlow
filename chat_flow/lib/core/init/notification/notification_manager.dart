import 'dart:convert';
import 'dart:developer';
import 'package:chat_flow/core/init/locator/locator_service.dart';
import 'package:chat_flow/core/service/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

@immutable
final class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initFCM() async {
    await _firebaseMessaging.getToken().then((value) => debugPrint('fcm token $value'));

    await _firebaseMessaging.requestPermission();

    await _initPushNotifications();

    await _initLocalNotifications();
  }

  // Push Notifications
  Future<void> _initPushNotifications() async {
    await _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('getInitialMessage data: ${message.data}');
      }
    });

    // Background
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onMessageOpenedApp data: ${message.data}');
    });

    await _foregroundNotification();
  }

  // Foreground
  Future<void> _foregroundNotification() async {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  // Local Notifications
  Future<void> _initLocalNotifications() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _sendNotification(String targetToken, String senderName, String message) async {
    const serverKey =
        'AAAACtQa_tc:APA91bE5rGB-AU2mUfNDs6bbA_EjqO0kmqmaLe9JOqVFlBr36vB319ltEfK6c_jkDThZqqwGlhhiuY01WiOqC41cSj38KO5TdAHjljKfzd9q1ZSfrlMZyejv1dfUv-oFBj5WuCblkgDe'; // Firebase projenizdeki sunucu anahtarı
    const fcmUrl = 'https://fcm.googleapis.com/fcm/send';

    try {
      final response = await http.post(
        Uri.parse(fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode({
          'to': targetToken,
          'notification': {
            'title': '$senderName size bir mesaj gönderdi!',
            'body': message,
            'sound': 'default',
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'message': message,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Bildirim gönderildi: ${response.body}');
      } else {
        print('Bildirim gönderimi hatası: ${response.body}');
      }
    } catch (e) {
      print('Hata: $e');
    }
  }

// Background
  Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    await Firebase.initializeApp();

    log('Handling a background message: ${message.messageId}');
  }

  Future<void> sendMessage(String receiverId, String message, String name) async {
    final token = await locator<AuthService>().getUserFcmToken(receiverId);

    if (token != null) {
      // FCM bildirimi gönder
      await _sendNotification(token, name, message);
    } else {
      print('Hedef kullanıcının FCM tokenı bulunamadı.');
    }
  }
}
